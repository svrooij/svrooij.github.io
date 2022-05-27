---
title: "Protect against certificate extraction - Client credentials"
published: true
categories:
  - Development
tags:
  - Security
  - Azure AD
twitter_image: /assets/images/undraw_Safe_re_kiil.png
---

You have this multi-tenant application that is protected with Azure AD, great! How about the certificate you're using as a client credential? If you followed the Microsoft samples it's probably stored in the Azure Key Vault. This seems really secure, but there is one thing no one thought about **Certificate Extraction**.

![undraw image](/assets/images/undraw_Safe_re_kiil.png)

<!--more-->

## Certificates in application might leak

> No problem, we store all certificates in an Azure Key Vault and only the application has access using a managed identity.

All the [samples](https://svrooij.io/2022/01/20/secure-multi-tenant-app/#keyvault-to-the-rescue-not-really) I have seen use the `SecretClient` or the `CertificateClient` to **GET** the certificate using managed identities and then do something with them **locally**.

> **IF** the certificate is available to the application, it **MIGHT** be extracted and send to some other service.

Wether it's by changing the application code or by getting it from the memory, having the certificate available locally is not as secure as you thought. It might even be possible to fetch the certificate directly from the key vault since an attacker might also be able to use the managed identity.

## Certificates as client credentials

Certificates used as client credentials are:

- Long-lived (60 days / 1 year / multiple years)
- Partially public, which are not secret (Cert hash, Subject, ...)
- Partially private, which should be threated as highly sensitive.
- used to get access as an application for the lifetime of the certificate

Luckily the logins of these **service principals** are logged into Azure AD, but only in the tenant they are used in. So your company might be able to detect malicious logins to your tenant, but you cannot count on your customers to do the same.

Microsoft says you need to rotate the certificates/secrets at least every 60 days, but lets face it, who follows that recommendation? And if you rotate the certificates every 60 days, wouldn't it still be an issue if the data of one (or all) of your customers can be accessed between the extraction and the rotation of the certificates? And the only way to figure this out is to check all the Azure AD logs of all your customers?

### Certificate available to client

If you followed along with the official Microsoft samples for using the Key Vault to secure your client certificate, you are vulnerable to certificate extraction. The certificates are available on the client, and they can be extracted.

<div class="mermaid">
sequenceDiagram;
    participant c as Client application
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
    c-->>m: Send certificate with long lifetime to some service
    m-->>m: Create signed assertion
    m-->>ad: Get Access token
    end
    c->>c: Create signed assertion
    c->>ad: Get token with assertion
    ad->>c: Access token for Graph/custom API
</div>

## Client assertions

[Client assertions](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-certificate-credentials) are a way for applications to authenticate. This is how all current samples do it. A client assertion is just a JWT token describing the client with a valid signature from a pre-registered certificate.

<div class="mermaid">
sequenceDiagram;
    participant c as Client application
    participant ad as Azure AD
    c->>c: Load certificate from some where (Certificate store / Key Vault)
    c->>c: Create unsigned assertion with client id and public cert info
    c->>c: Convert unsigned token to Base64
    c->>c: Sign assertion with certificate (private part)
    c->>ad: Access token for api x (client id + signed assertion)?
    ad->>ad: Validate signed assertion
    ad->>c: Access token (valid for 3600 seconds)
</div>

## Protecting against certificate extraction

To protect against this attack, we first need to find out what it's doing with the certificate. And possibly figure out a way to accomplish the same without the need to access the certificate locally. In case of client credentials the certificate is used to sign some data (tenant ID, Client ID, Certificate hash) that isn't considered a secret with the private key contained in the certificate.

## Signed client assertion without certificate access

What if we could get a signed client assertion without access to the certificate? The KeyVault has a [Sign](https://docs.microsoft.com/en-us/rest/api/keyvault/keys/sign/sign) operation, that means we are able sign any data directly in the Key Vault without being able to extract the certificate.

<div class="mermaid">
sequenceDiagram;
    participant c as Client application
    participant kv as Key Vault
    participant ad as Azure AD
    c->>c: Create unsigned assertion with public cert info
    c->>c: Convert to Base64
    rect rgb(225,225,225)
    note right of c: Managed identity
    c->>kv: Sign data with certificate x?
    kv-->>ad: Is this managed identity allowed to sign?
    ad-->>kv: Yes / No
    kv->>c: Here is the signature
    end
    c->>c: Append signature to assertion as Base64
    c->>ad: Access token for api x (client id + signed assertion)?
    ad->>ad: Validate signed assertion
    ad->>c: Access token (valid for 3600 seconds)
</div>

### Protecting against persistent access

This solution only prevents extraction of the certificate and allowing for long term access to customer data. If an attacker would be able to control the application/server they would still be able to generate an access token for the other tenant, but they can only do that as long they have access to your application.

The login actions of the managed identity is logged in your Azure AD, and the sign action in logged in the Key Vault. If you put an alert on the number of requests to the key vault, you should be able to discover more/less requests then normal, and figure out the application has been hacked.

## Know about certificate extraction

It's most import for companies to be aware of this issue, so please share this post to as much developers/architects as possible.

As long as you're aware of the issue you might get to solve it before you're attacked. There are a lot off other things you can do with certificates, like encrypting/decrypting data, which are also vulnerable for certificate extraction. You can also encrypt/decrypt data while keeping the certificate in the key vault.

## Getting access token in a secure way?

The most secure way to get an access token is to [use a managed identity](/2022/04/21/access-api-with-managed-identity/) but that isn't always possible. The second most secure way is to use a managed identity to connect to the Key Vault and sign the client assertion in the cloud.

With the above information you should be able to figure out a way to securely get access tokens for your client application with the certificate stored securely in the Key Vault.

If you don't want to figure out how to sign client assertions in the cloud, you can check out one of these links that might help you solve the issue. We have build a special MSAL.net extension to help you do just that.

- [Sign assertion in Key Vault](https://svrooij.io/2022/01/20/secure-multi-tenant-app/#keyvault-to-the-rescue)
- [Nuget Smartersoft.Identity.Client.Assertion](https://www.nuget.org/packages/Smartersoft.Identity.Client.Assertion/)
- [Source Smartersoft.Identity.Client.Assertion](https://github.com/Smartersoft/identity-client-assertion/tree/main/src/Smartersoft.Identity.Client.Assertion)
- [MSAL.Net client assertions](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-net-client-assertions)

Since I'm a dotnet developer these links are only for dotnet, the solution (signing the tokens in the Key Vault), is available in the Key Vault rest api. There are ways to accomplish the same in other languages.

<script src="{{ "/assets/mermaid-8.9.2/mermaid.min.js" | relative_url }}"></script>
