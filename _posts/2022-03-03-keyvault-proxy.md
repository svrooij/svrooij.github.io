---
title: "KeyVault proxy demo"
published: true
categories:
  - Development
tags:
  - Azure
  - Azure AD
  - Client credentials
  - Dotnet tool
twitter_image: /assets/images/2022/02/token-proxy.png
---

Today I'll demo my new [KeyVault proxy](https://svrooij.io/2022/02/04/token-proxy/) in the [425show](https://www.twitch.tv/425show).
This page will allow you to follow along.

Check out the [recording](https://www.twitch.tv/videos/1414084395) and if you have any questions, contact me on [twitter @svrooij](https://twitter.com/svrooij).

<!--more-->

[![Nuget](https://img.shields.io/nuget/v/Smartersoft.Identity.Client.Assertion.Proxy?logoColor=00a880&style=for-the-badge)](https://www.nuget.org/packages/Smartersoft.Identity.Client.Assertion.Proxy/)
[![GitHub License](https://img.shields.io/github/license/Smartersoft/identity-client-assertion?style=for-the-badge)](https://github.com/Smartersoft/identity-client-assertion/blob/main/LICENSE.txt)
[![GitHub issues](https://img.shields.io/github/issues/Smartersoft/identity-client-assertion?style=for-the-badge)](https://github.com/Smartersoft/identity-client-assertion/issues)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/svrooij?label=Github%20Sponsors&style=for-the-badge)](https://github.com/sponsors/svrooij/)

## Resources

- [What's a JWT](https://jwt.io/introduction)
- [JWT.ms](https://jwt.ms), Microsoft build JWT inspection website
- [Azure AD client credentials](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-certificate-credentials)
- [MSAL.net Client assertions](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-net-client-assertions)

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

In the [stream](https://www.twitch.tv/videos/1414084395) I showed the `/api/Token/kv-certificate` endpoint. For this endpoint, you'll need the following information:

- `client_id` You application id from Azure
- `tenant_id` The tenant ID
- `scopes` Which scopes do you want a token for, it's an array, but when using the client credentials, you should be specifying only one!
- `keyVaultUri` The uri of the keyvault
- `certificateName` The name of the certificate

This endpoint actually does two calls to the KeyVault, one to get the public part of the certificate (to generate the base64 url encoded hash and to get the keyUri), and one to the sign endpoint to actually sign the token. If you're using this proxy more often use the `api/Token/kv-key-info` endpoint to get the hash and the key once (they change only when you regenerate the certificate). And then use the `api/Token/kv-key` endpoint to get your token faster.

In the demo I quickly mentioned the other endpoints. Just check-out the automatic openapi documentation on those endpoints at `/swagger/index.html`.
