---
title: "Securing credentials during development"
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

Protecting client credentials for (multi-tenant) application should be your highest priority, not only in **production** also during **development**.

We developed a small application that helps you do just that.
Use your Visual Studio credentials to sign a token request while the certificate stays in the KeyVault.
You could even only authorize developers to use the certificates in a KeyVault when they need it and de-authorize then when it's no longer needed.

<!--more-->

[![Nuget](https://img.shields.io/nuget/v/Smartersoft.Identity.Client.Assertion.Proxy?logoColor=00a880&style=for-the-badge)](https://www.nuget.org/packages/Smartersoft.Identity.Client.Assertion.Proxy/)
[![GitHub License](https://img.shields.io/github/license/Smartersoft/identity-client-assertion?style=for-the-badge)](https://github.com/Smartersoft/identity-client-assertion/blob/main/LICENSE.txt)
[![GitHub issues](https://img.shields.io/github/issues/Smartersoft/identity-client-assertion?style=for-the-badge)](https://github.com/Smartersoft/identity-client-assertion/issues)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/svrooij?label=Github%20Sponsors&style=for-the-badge)](https://github.com/sponsors/svrooij/)

## Client credentials

So you're developing an application that talks to [Microsoft Graph](https://docs.microsoft.com/en-us/graph/api/overview?view=graph-rest-1.0) or your custom api. You're probably using [postman](https://www.postman.com/downloads/) or [Insomnia](https://insomnia.rest/) to test the api.

Postman and Insomnia are great, but they doesn't support using certificates as client credentials. So you'll always need to create a client secret in the app registration. That **secret** is probably configured on the local machines of all the developers. Not really secure. Especially not if that application registration is also used in production. If all your developers already sign-in to Visual studio, the probably have **credentials** configured that might just work to access a resource in azure.

## Introducing KeyVault token proxy

We build a small [open-source](https://github.com/Smartersoft/identity-client-assertion/tree/main/src/Smartersoft.Identity.Client.Assertion.Proxy) **dotnet tool** that uses the [credentials](/2021/07/20/managed-identity-without-azure/#default-credentials-order) already available to the developer to securely connect to a KeyVault and [get a token with certificate in KeyVault](/2022/01/20/secure-multi-tenant-app/#keyvault-to-the-rescue).

1. Install token proxy `dotnet tool install --global Smartersoft.Identity.Client.Assertion.Proxy`
2. Start proxy from command line `az-kv-proxy`
3. Browse the swagger documentation at `http://localhost:{port}/swagger/index.html`

![KeyVault proxy endpoints](/assets/images/2022/02/token-proxy.png)

See [documentation](https://github.com/Smartersoft/identity-client-assertion/blob/main/docs/Smartersoft.Identity.Client.Assertion.Proxy.md#using-this-proxy)

## Request an access token

Once you have this proxy running you have several ways to get a token for some application. To use this proxy it requires you to create a [certificate](https://github.com/Smartersoft/identity-client-assertion/blob/main/docs/Smartersoft.Identity.Client.Assertion.md#creating-a-certificate-in-keyvault) in the KeyVault and adding that to an application registration.

Gather the required data:

| Parameter | Sample | Description |
|-----------|--------|-------------|
| `clientId` | `996ba276-df43-40af-8ffd-d1564b1c88a8` | The ID of the application you're trying to use |
| `tenantId` | `d198b314-13c1-4ad1-8526-92355369ec6c` | The ID of the tenant you want a certificate for |
| `scopes` | `https://graph.microsoft.com/.default` | The scope where you want to get a token for |

Depending on which method you're using you'll need some extra information.

- [Get token using KeyVault key](https://github.com/Smartersoft/identity-client-assertion/blob/main/docs/Smartersoft.Identity.Client.Assertion.Proxy.md#using-key-vault-key)
- [Get token using KeyVault certificate](https://github.com/Smartersoft/identity-client-assertion/blob/main/docs/Smartersoft.Identity.Client.Assertion.Proxy.md#using-key-vault-certificate) *less efficient**.
- And if you want to use a certificate from the [local cert store](https://github.com/Smartersoft/identity-client-assertion/blob/main/docs/Smartersoft.Identity.Client.Assertion.Proxy.md#using-certificate-from-current-user-store) that is also possible, but won't add a lot security wise.

Pick the endpoint that you like best, and use it in the description for Insomnia or Postman

## Use KeyVault token proxy with Insomnia

I personally use [Insomnia](https://insomnia.rest/) as a rest api test tool, it suits my needs and seems to work quite intuitively. To use the KeyVault token proxy in Insomnia just follow along.

1. Create a new `POST` request to your token endpoint `/api/token/kv-certificate` in this case.
2. Set the required `JSON` body, I'm using variables here, but you can also configure it statically.
3. Try the request with the Send button
4. Create a new request to the api, where you want to use the token.
5. Set the authentication to `Bearer`
6. In the token field, press `CTRL + SPACE` and select `Response => Body attribute`
7. Double click the now red configuration.
8. Select the token request, set Filter: `$.accessToken`, Trigger behavior: `When expired` and max age: `3500`. It should now show a token in the **Live Preview** window.

Everytime you try to execute this request it will automatically get a token (if it was expired) as long as the proxy is running.

![Token request in Insomnia](/assets/images/2022/02/token-proxy-insomnia.png)

![Body request settings in Insomnia](/assets/images/2022/02/token-proxy-insomnia-auth.png)

## Use KeyVault token proxy with Postman

You can also [use this proxy with postman](https://github.com/Smartersoft/identity-client-assertion/blob/main/docs/Smartersoft.Identity.Client.Assertion.Proxy.md#usage-with-postman). Someone else already made a great post on how that should work, see [this postman blog](https://blog.postman.com/extracting-data-from-responses-and-chaining-requests/).

## Like it?

If you really like this proxy or if you have a very good reason why this is a bad idea, please <a href="https://twitter.com/intent/tweet?url={{ page.url | absolute_url | url_encode }}&text={{page.title | url_encode}}&via={{ page.author | default: site.social_media.twitter }}">let me know</a>.

### Dotnet tool

I never build a [dotnet tool](https://docs.microsoft.com/en-us/dotnet/core/tools/global-tools) so this was also a nice experiment. The resulting tool is a small web api with swagger ui, packaged as a dotnet tool. This is published through [nuget](https://www.nuget.org/packages/Smartersoft.Identity.Client.Assertion.Proxy/). 

Creating a **dotnet tool** is a great way to package a small command line application. To create a dotnet tool package from an existing dotnet core application you only need to add a [few lines](https://github.com/Smartersoft/identity-client-assertion/blob/afe95c4454d7c7ece8bb3b387ffc5bd80e1f647a/src/Smartersoft.Identity.Client.Assertion.Proxy/Smartersoft.Identity.Client.Assertion.Proxy.csproj#L19-L21) to your project file and call `dotnet pack`.
