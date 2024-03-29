---
title: "KeyVault proxy demo"
published: true
categories:
  - Development
tags:
  - Azure AD
  - Client credentials
  - Dotnet tool
twitter_image: /assets/images/2022/02/token-proxy.png
---

Today I'll demo my new [KeyVault proxy](https://svrooij.io/2022/02/04/token-proxy/) in the [425show](https://www.twitch.tv/425show).
This page will allow you to follow along.

Check out the [recording][link_twitch] and if you have any questions, contact me on [twitter @svrooij](https://twitter.com/svrooij).
<!--more-->
<div class="video_wrapper">
<iframe width="100%" height="100%" src="https://www.youtube.com/embed/HD5JiRrfRzE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Badges

[![Github source][badge_source]][link_source]
[![Nuget package][badge_nuget_proxy]][link_nuget_proxy]
[![GitHub License][badge_license]][link_license]
[![GitHub issues][badge_issues]][link_issues]
[![GitHub Sponsors][badge_sponsor]][link_sponsor]

## Resources

- [What's a JWT](https://jwt.io/introduction)
- [JWT.ms](https://jwt.ms), Microsoft build JWT inspection website
- [Azure AD client credentials](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-certificate-credentials)
- [MSAL.net Client assertions](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-net-client-assertions)
- [Source][link_source] on Github
- [Nuget][link_nuget_proxy] package proxy
- [Nuget][link_nuget] package **ConfidentialClientApplicationBuilderExtensions**

## What problem are you solving?

If you don't protect the certificate that is used as a client credential, it's just a complicated password. I wish that I have tight control over those certificates and making sure they **cannot** be exported. Client credentials should only be used if [managed identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) aren't an option.

- Using client credentials in [Insomnia](https://insomnia.rest/) or [postman](https://www.postman.com/downloads/) seems impossible.
- Having the certificate locally makes it vulnerable for stealing.
- **Managed Identities** [cannot](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/managed-identities-faq#can-i-use-a-managed-identity-to-access-a-resource-in-a-different-directorytenant) be used in multi-tenant applications.

## Requirements

1. Setup a KeyVault and generate a [certificate](https://github.com/Smartersoft/identity-client-assertion/blob/main/docs/Smartersoft.Identity.Client.Assertion.md#creating-a-certificate-in-keyvault) in the KeyVault.
2. Grant your user account access to `Sign` under `Key permissions` > `Cryptographic Operations` to the KeyVault
3. Create application registration, grant access to some application permission like `User.Read.All`, do admin consent and add the certificate under secrets.

## Get started with KeyVault proxy (dev mode)

```bash
git checkout https://github.com/Smartersoft/identity-client-assertion.git
.\identity-client-assertion\Smartersoft.Identity.Client.Assertion.sln
```

Start the proxy (press F5) and try to open the swagger documentation of the proxy at `/swagger/index.html`.

## Get started with KeyVault proxy

```bash
dotnet tool install --global Smartersoft.Identity.Client.Assertion.Proxy
az-kv-proxy
```

Start the proxy and try to open the swagger documentation of the proxy at `http://localhost:{port}/swagger/index.html`.

## Demo

In the [stream][link_twitch] I showed the `/api/Token/kv-certificate` endpoint. For this endpoint, you'll need the following information:

- `clientId` You application id from Azure
- `tenantId` The tenant ID
- `scopes` Which scopes do you want a token for, it's an array, but when using the client credentials, you should be specifying only one!
- `keyVaultUri` The uri of the keyvault
- `certificateName` The name of the certificate

This endpoint actually does two calls to the KeyVault, one to get the public part of the certificate (to generate the base64 url encoded hash and to get the keyUri), and one to the sign endpoint to actually sign the token. If you're using this proxy more often use the `api/Token/kv-key-info` endpoint to get the hash and the keyId once (they change only when you regenerate the certificate). And then use the `api/Token/kv-key` endpoint to get your token faster.

In the demo I quickly mentioned the other endpoints. Just check-out the automatic openapi documentation on those endpoints at `/swagger/index.html`.

## How about production

As said in the demo (and the documentation), this proxy **only** suitable for use during development! If you want to use the same principal in production, you can check-out our [ConfidentialClientApplicationBuilderExtensions][link_nuget]. This small package provides a few extensions to the [**ConfidentialClientApplicationBuilder**](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-net-initializing-client-applications#initializing-a-confidential-client-application-from-code).
You can then use the same goodies while using the Managed Identity in Azure to connect to the KeyVault.

Check-out [this post](/2022/01/20/secure-multi-tenant-app/) for more details.

[![Nuget package][badge_nuget]][link_nuget]
[![Github source][badge_source]][link_source]

```csharp
var tenantId = "28de03b2-dd2e-4c77-b76d-ac7aaebec43e";
var clientId = "20f8d4a4-f795-43c1-80fb-781a848f665f";
Uri keyId = new Uri("...."); // Fetch from KeyVault
var hash = "..."; // Use KeyVault proxy to find base64url encoded hash.
TokenCredential cred =  new ManagedIdentityCredential(); // or 'new DefaultAzureCredential();' as in the proxy 
IConfidentialClientApplication app = ConfidentialClientApplicationBuilder
  .Create(clientId)
  .WithAuthority(AzureCloudInstance.AzurePublic, tenantId)
  //.WithCertificate(certificate)
  .WithKeyVaultKey(tenantId, clientId, keyId, hash, cred)
  //.WithRedirectUri(redirectUri )
  .Build();

var tokenResult = await app
  .AcquireTokenForClient(new[] { "https://graph.microsoft.com/.default" })
  .ExecuteAsync();

return tokenResult.AccessToken;
```

**Look** no secrets in the code!
You should however make all those variables configurable, in a way you like. I'm not sure if the **KeyId** is supposed to be kept secret, but you can lockdown your KeyVault to be only accessible from specific IP's or virtual networks so you'll probably be fine.

[badge_issues]: https://img.shields.io/github/issues/Smartersoft/identity-client-assertion?style=for-the-badge
[badge_license]: https://img.shields.io/github/license/Smartersoft/identity-client-assertion?style=for-the-badge
[badge_nuget_proxy]: https://img.shields.io/nuget/v/Smartersoft.Identity.Client.Assertion.Proxy?logoColor=00a880&style=for-the-badge
[badge_nuget]: https://img.shields.io/nuget/v/Smartersoft.Identity.Client.Assertion?logoColor=00a880&style=for-the-badge
[badge_source]: https://img.shields.io/badge/Source-Github-green?style=for-the-badge
[badge_sponsor]: https://img.shields.io/github/sponsors/svrooij?label=Github%20Sponsors&style=for-the-badge

[link_issues]: https://github.com/Smartersoft/identity-client-assertion/issues
[link_license]: https://github.com/Smartersoft/identity-client-assertion/blob/main/LICENSE.txt
[link_nuget_proxy]: https://www.nuget.org/packages/Smartersoft.Identity.Client.Assertion.Proxy/
[link_nuget]: https://www.nuget.org/packages/Smartersoft.Identity.Client.Assertion/
[link_source]: https://github.com/Smartersoft/identity-client-assertion/
[link_sponsor]: https://github.com/sponsors/svrooij/
[link_twitch]: https://www.twitch.tv/videos/1414084395
