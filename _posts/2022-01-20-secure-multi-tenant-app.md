---
title: "Securing multi-tenant app with Managed Identity"
published: true
categories:
  - Development
tags:
  - MSAL
  - Multi-tenant
  - Security
card_image: /assets/images/header-development.png
twitter_image: /assets/images/2022/01/2022-01-20-secure-multi-tenant-app.png
---

Keeping your secrets secure, can be a huge challenge. And keeping secrets becomes a huge responsibility, especially if you're in the business of building multi-tenant applications. Microsoft created managed identities to ease this responsibility, but [according to the faq](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/managed-identities-faq#can-i-use-a-managed-identity-to-access-a-resource-in-a-different-directorytenant), you cannot use them to secure resources in other tenants. And that is exactly where we could use extra help is securing secrets.

<!--more-->

## Certificates instead of client secrets

We configure all our (multi-tenant) applications to only use certificates as  credentials in the client credential flow. This is great as long as you can keep the certificate secret, otherwise it's just a complicated password. 

Curious how using certificates instead of passwords work? Check out the [documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-net-client-assertions) on client assertions.

Simplified steps:

1. Create unsigned client assertion (JWT with some details about the client, the used certificate and the intended audience)
2. Sign client assertion (using RSA) with private key from certificate.
3. Add signature to client assertion.
4. Send signed client assertion to token endpoint, instead of a regular secret.

## KeyVault to the rescue (not really)

I've seen a lot of samples where people suggest to just create a certificate in the KeyVault, secure the connection to the KeyVault with the Managed Identity, and then **Get the secret** from the KeyVault to sign the client assertion.

```csharp
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

public async Task<string> GetToken(...)
{
  const string ceyVaultUri = "https://{kv-domain}.vault.azure.net/";
  const string certName = "{some-certificate-name}";
  var tokenCredential = new DefaultAzureCredential();
  var secretClient = new SecretClient(new Uri(keyVaultUri), tokenCredential);
  var secretResult = await secretClient.GetSecretAsync(certName).ExecuteAsync();
  // Certificate is now present on client machine
  var certificate = new X509Certificate2(Convert.FromBase64String(secretResult.Value.Value));

  const string clientId = "d294e746-425b-44fa-896c-dacf2c7938b8";
  const string tenantId = "42a26c5d-b8ed-4f1b-8760-655f98154373";

  var app = ConfidentialClientApplicationBuilder
    .Create(clientId)
    .WithAuthority(AzureCloudInstance.AzurePublic, tenantId)
    .WithCertificate(certificate)
    .Build();

  var tokenResult = await app
    .AcquireTokenForClient(new[] { "https://graph.microsoft.com/.default" })
    .ExecuteAsync();

  return tokenResult.AccessToken;
}
```

Looks pretty secure right? The certificate is securely stored in the KeyVault and we use a Managed Identity to access it. MSAL does the client assertion signing for you, and everything just works.

In this case the **Certificate** is just used as a complicated password that is saved somewhere relatively secure. And we have a secure way to access it. Here lies the problem, if we have a way of accessing it, a malicious actor might also find a way to access it.

## KeyVault to the rescue

KeyVault has a way of storing and retrieving secrets, but you can also use the KeyVault to Sign data with some key stored in the KeyVault. Almost every certificate in the KeyVault consits of several parts. Certificate (public part), the secret (used above to get the complete certificate) and a key.

The Key can be used to [Sign data](https://docs.microsoft.com/en-us/dotnet/api/azure.security.keyvault.keys.cryptography.cryptographyclient.signdataasync?view=azure-dotnet) and that is exactly what we need for client assertions. So how is this different?

Instead of download the certificate to the client, we ask the **KeyVault** to **sign** the unsigned client assertion. That way the client application will never have access to the private key, and since it [cannot](#configure-certificate-to-be-not-exportable) be extracted from the KeyVault this is much safer. Because you'll need an active connection to the KeyVault to create a client assertion.

While you could do this yourself, I've made an extension for the **Microsoft.Identity.Client** to automatically create a signed client assertion while never downloading the certificate.

`dotnet add package Smartersoft.Identity.Client.Assertion --version 0.1.5`

- [nuget package](https://www.nuget.org/packages/Smartersoft.Identity.Client.Assertion/)
- [source code](https://github.com/Smartersoft/identity-client-assertion)

```csharp
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Smartersoft.Identity.Client.Assertion;

public async Task<string> GetToken(...)
{
  const string keyVaultUri = "https://{kv-domain}.vault.azure.net/";
  const string certName = "{some-certificate-name}";
  var tokenCredential = new DefaultAzureCredential();

  const string clientId = "d294e746-425b-44fa-896c-dacf2c7938b8";
  const string tenantId = "42a26c5d-b8ed-4f1b-8760-655f98154373";

  var app = ConfidentialClientApplicationBuilder
    .Create(clientId)
    .WithAuthority(AzureCloudInstance.AzurePublic, tenantId)
    //.WithCertificate(certificate)
    .WithKeyVaultCertificate(tenantId, clientId, new Uri(keyVaultUri), certName, tokenCredential)
    .Build();

  var tokenResult = await app
    .AcquireTokenForClient(new[] { "https://graph.microsoft.com/.default" })
    .ExecuteAsync();

  return tokenResult.AccessToken;
}
```

This [code](https://github.com/Smartersoft/identity-client-assertion/blob/683892632686d4aeea04b2adf7fdf3051f3bcaaf/src/Smartersoft.Identity.Client.Assertion/ClientAssertionGenerator.cs#L180-L191) will be called to create the client assertion from the certificate name. It will call the KeyVault twice and that isn't very efficient.

It's just a drop-in replacement for the first version where you would download the certificate.

This solution will cost you $ `0.03` per `5000` token requests.

## Best solution use KeyVault key directly

The client assertion needs a `kid` in the [unsigned assertion](https://github.com/Smartersoft/identity-client-assertion/blob/683892632686d4aeea04b2adf7fdf3051f3bcaaf/src/Smartersoft.Identity.Client.Assertion/ClientAssertionGenerator.cs#L66-L95). This is the Base64Url encoded SHA256 hash of the certificate. This value is static for the certificate version (default lifetime 12 months), we only need to query it once and store it in a config file.

You also store the `KeyId` (url to the certificate' key in KeyVault) instead of the certificate name and the Vault url.

```csharp
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Smartersoft.Identity.Client.Assertion;

public async Task<string> GetTokenEfficiently(CancellationToken cancellationToken)
{
    // Create a token credential that suits your needs, used to access the KeyVault
    var tokenCredential = new DefaultAzureCredential();

    // Save these values in a config file
    Uri keyId = new Uri("https://{kv-domain}.vault.azure.net/keys/{some-certificate-name}/{cert-version}");
    string kid = "60shQoCU....Fi0";

    const string clientId = "d294e746-425b-44fa-896c-dacf2c7938b8";
    const string tenantId = "42a26c5d-b8ed-4f1b-8760-655f98154373";

    // Use the ConfidentialClientApplicationBuilder as usual
    // but call `.WithKeyVaultKey(...)` instead of `.WithCertificate(...)`
    var app = ConfidentialClientApplicationBuilder
        .Create(clientId)
        .WithKeyVaultKey(tenantId, clientId, keyId, kid, tokenCredential)
        .Build();

    // Use the app, just like before
    var tokenResult = await app
      .AcquireTokenForClient(new[] { "https://graph.microsoft.com/.default" })
      .ExecuteAsync(cancellationToken);

    return tokenResult.AccessToken;
}
```

This solution will cost you $ `0.03` per `10000` token requests.

## Configure certificate to be NOT EXPORTABLE

As an Azure admin, you will still be able to export the certificate from the KeyVault, if you didn't configure the Advanced Policy Configuration. 

The solution described here is only more secure if the certificate **CANNOT** be exported from the KeyVault. Follow the [documentation](https://github.com/Smartersoft/identity-client-assertion/blob/main/docs/Smartersoft.Identity.Client.Assertion.md#creating-a-certificate-in-keyvault) on how to create the certificate, in such a way that it can never be exported.

Configure the **Advanced Policy Configuration** with these settings:

- **Private key exportable** to `No`
-  **X.509 Key Usage Flags** to only allow `Digital signature`

## Conclusions

In the process of creating this package and this post, I discovered that the [Client assertion sample code](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-net-client-assertions) has some issues, so I created a [PR](https://github.com/MicrosoftDocs/azure-docs/pull/86636) to fix those.

> While it is possible to use the `WithClientAssertion()` API to acquire tokens for the confidential client, we do not recommend using it by default as it is more advanced and is designed to handle very specific scenarios which are not common.
>
> [Confidential client assertions](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-net-client-assertions)

And I think I found one specific scenario where manually creating a client assertion is actually useful. You can never be too carefull about leaking secrets that might lead to persistent access (to client' data) after a breach. This way the leak can be discovered easier and it will only result in temporary access to data (since they cannot export the key for re-use later).

Similar code might some day appear in [MSAL.net](https://github.com/AzureAD/microsoft-authentication-library-for-dotnet), who knows. Until then, use my extension or roll your own.

Keep your loved ones close and your secrets securely hidden away!
