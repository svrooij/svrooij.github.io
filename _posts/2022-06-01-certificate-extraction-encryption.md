---
title: "Protect against certificate extraction - encryption"
published: true
categories:
  - Development
tags:
  - Security
  - Encryption
twitter_image: /assets/images/undraw_Security_on_re_e491.png
---

You're encrypting sensitive data with RSA encryption, great start! But how do you protect your certificates from being extracted? You get hacked and they steal your encrypted data, no problem, it's encrypted! If they hack you, are you sure they can't also steal the certificate? This series covers several risks of **Certificate Extraction** and what you can do about it.

![undraw image](/assets/images/undraw_Security_on_re_e491.png)

<!--more-->

## Certificate extraction series

- [Client credentials - remote sign](/2022/05/27/certificate-extraction-client-credentials/)
- [En-/decrypting in the cloud](/2022/06/01/certificate-extraction-encryption/) (this post)

## Certificates in application might leak

> No problem, we store all certificates in an Azure Key Vault and only the application has access using a managed identity.

Yes you're mostly right, the app has access to the certificate using a managed identity. But it **downloads** it before using it for decrypting. Which means the certificate is available on the server where your app is running. And if you get hacked they might also be able to change the code of the application and extract the certificate to use it for decrypting all the encrypted data.

> **IF** the certificate is available to the application, it **MIGHT** be extracted and send to some other service.

<div class="mermaid">
sequenceDiagram;
    participant c as Client application
    participant s as Storage
    participant kv as Key Vault
    participant ad as Azure AD
    participant m as Malicious actor
    rect rgb(191,227,180)
    note right of c: Managed identity
    c->>ad: Access token for KeyVault?
    ad->>c: Here you go
    end
    c->>kv: Get certificate
    kv->>c: Here is the certificate
    rect rgb(244,113,116)
    note right of c: Cert available in memory!
    c-->>m: Upload certificate to remote server
    m-->>m: Decrypt all extracted data remotely
    end
    c->>s: Get encrypted data with ID
    s->>c: Encrypted data
    c->>c: Decrypt data with local certificate
</div>

## Data encryption with certificates

You can use certificates to encrypt data, which makes it a lot harder for an attacker to do something malicious with it.
To encrypt data using a certificate you'll need the **public key** of the certificate. Which means you can ask others to encrypt data for you, without them knowing the **private key** of your certificate.

We don't have to go in much details on how to do the encryption, but you can find enough samples on [stackoverflow](https://stackoverflow.com/a/41595289/639153).

```csharp
public static byte[] EncryptDataOaepSha1(X509Certificate2 cert, byte[] data)
{
    using (RSA rsa = cert.GetRSAPublicKey())
    {
        return rsa.Encrypt(data, RSAEncryptionPadding.OaepSHA1);
    }
}
```

The main thing to understand here is that you only need the **public** key to encrypt data.

## Data decryption with certificates

To decrypt data you'll need the **private key** of the certificate, this key is meant to kept secret, because it can be used to decrypt all the data. You can use code similar to this to decrypt the data:

```csharp
public static byte[] DecryptDataOaepSha1(X509Certificate2 cert, byte[] data)
{
    using (RSA rsa = cert.GetRSAPrivateKey())
    {
        return rsa.Decrypt(data, RSAEncryptionPadding.OaepSHA1);
    }
}
```

## Protecting against certificate extraction

To protect against attackers being able to get their hands on the certificate and being able to decrypt all the encrypted data, we are going to make sure that **no application or user/admin** has access to the private key of the certificate.

Upon certificate generation in the Azure Key Vault, you have the option to set **Exportable Private Key** to `No` under `Advanced Policy Configuration`. Which means the private key, will **NEVER** be exported.

![Key vault generate not exportable certificate](/assets/images/2022/06/keyvault-private-key-not-exportable.png)

*It's possible to create a local backup including this private key, but the local backup can only be restored in a key vault in the same Azure subscription. see [Key Vault backup](https://docs.microsoft.com/en-us/azure/key-vault/general/backup).*

## Decrypting data in the cloud

Now that we have this certificate in the Key Vault with private key marked as **not exportable**, how do we decrypt the data? The KeyVault has a [Decrypt](https://docs.microsoft.com/en-us/rest/api/keyvault/keys/decrypt/decrypt) operation, that means we are able to decrypt any data directly in the Key Vault without being able to extract the certificate.

<div class="mermaid">
sequenceDiagram;
    participant c as Client application
    participant s as Storage
    participant kv as Key Vault
    participant ad as Azure AD
    c->>s: Get encrypted data by id
    s->>c: Here is the encrypted data
    rect rgb(225,225,225)
    note right of c: Managed identity
    c->>kv: Decrypt data with certificate x?
    kv-->>ad: Is this managed identity allowed to decrypt?
    ad-->>kv: Yes / No
    kv->>c: Here is the decrypted data
    end
    c->>c: Convert decrypted bytes to needed format
</div>

## Encrypting data in the cloud

For encrypting data, you don't need the private key, so you can still download the certificate and use that for encryption. Because you marked the private key as **not exportable**, it will not be included in the certificate. And you'll only receive the public part of the certificate.

But for convenience the KeyVault also has an [Encrypt](https://docs.microsoft.com/en-us/rest/api/keyvault/keys/encrypt/encrypt) endpoint.

<div class="mermaid">
sequenceDiagram;
    participant c as Client application
    participant s as Storage
    participant kv as Key Vault
    participant ad as Azure AD
    c->>c: Convert data to byte[]
    rect rgb(225,225,225)
    note right of c: Managed identity
    c->>kv: Encrypt data with certificate
    kv-->>ad: Is this managed identity allowed to encrypt?
    ad-->>kv: Yes / No
    kv->>c: Here is the encrypted data
    end
    c->>s: Save encrypted data
</div>

## Know about certificate extraction

It's most import for companies to be aware of this issue, so please share this series to as much developers/architects as possible.

As long as you're aware of the issue you might get to solve it before you're attacked. There are a lot off things you can do with certificates, and most of them have a cloud alternative.

## Use managed identities as much as possible

A lot of services in Azure support [managed identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview), you should use them as much as possible. Keeping secrets is hard, so why don't you let Microsoft do the hard part, that is one thing less to worry.

In this sample we only use the managed identity to access the key vault, but you can also use managed identities to access [cosmos db](https://docs.microsoft.com/en-us/azure/cosmos-db/managed-identity-based-authentication) if you use that for storage.

<script src="{{ "/assets/mermaid-8.9.2/mermaid.min.js" | relative_url }}"></script>
