---
title: "Azure Functions with multi tenant authentication"
published: true
tags:
  - Azure Functions
  - Authentication
  - Multi tenant
image: /assets/images/azure-functions-json.png
---

Azure Functions (and Azure App Service) support authentication out of the box. They even made a wizard to get you started quickly. This is really useful if you just want users from your tenant (or a specific other tenant) to login.

Check-out the [documentation](https://docs.microsoft.com/en-us/azure/app-service/overview-authentication-authorization) to get started.

## Allow multiple tenants

The wizard configures authentication for users from a single tenant, but you can change that really easy.

1. Open your Functions app (or app service) in the Azure portal
2. Click Authentication
3. Click the pencil after the (pre) configured Microsoft provider.

![Azure Functions change provider](/assets/images/2021/05/azure-functions-change-provider.png)

## Issuer url

![Azure Functions Issuer URL](/assets/images/2021/05/azure-functions-issuer.png)

The **Issuer URL** set by the wizard is in the format `https://login.microsoftonline.com/<your-tenant-id>/v2.0`.

This issuer URL does several things:

1. Signal the authentication [middleware](#easy-auth) to use the OpenID Connect configuration from `<issuer-url>/.well-known/openid-configuration`.
2. Set the expected issuer in the identity token to the issuer url.

To allow users from multiple tenants, you would normally just use another [endpoint](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols#endpoints). Just change the `<tenant-id>` to `organizations` was my first thought.

This does allow the [middleware](#easy-auth) to download the correct OpenID configuration (and show a login screen with only organization accounts), but the issuer in the identity token contains the `<tenant-id>` and not `organizations`. This means your login request will be denied by the middleware.

### Magic issuer URL

In this really long thread on [twitter](https://twitter.com/svrooij/status/1387696995331158016?s=20) I finally got in contact with Connor from Microsoft. Who told me that to allow access from multiple tenants, you've to set the issuer URL to `https://login.microsoftonline.com/common/v2.0`

This url is also in the [endpoints](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols#endpoints) list (and allows any user with a personal or business account to login).

They build a special case when using this **exact** issuer url, in that it disables issuer validation. So to support multiple tenants (and personal accounts) just change the **Issuer URL** to `https://login.microsoftonline.com/common/v2.0`.

### Filter tenants and personal accounts

The [authentication middleware](#easy-auth) currently doesn't support setting a list of allowed issuers. So if you only want users from some tenants to access your application, you'll have to build something yourself.

If you're using C# to develop your functions, you have access to the user info in every request.

```csharp
// Disallow unauthenticated users (if you allow Unauthenticated requests in the config)
if (req.HttpContext.User.Identity.IsAuthenticated) {
  return new UnauthorizedResult();
}

// get the issuer
string issuer = req.HttpContext.User.FindFirst("iss")?.Value;

// Get a list of allowed issuers from somewhere, I recommend putting this in a easy changeable configuration setting.
string[] issuers = new string[]{"https://login.microsoftonline.com/d6e38211-3aab-45b8-9786-f26a8d2a6b52/v2.0", "https://login.microsoftonline.com/f3c6fd84-ba70-4cef-8c8f-0fd131a23b8e/v2.0"};

if (!issuers.Contains(issuer)) {
  return new UnauthorizedResult();
}

// Filter personal accounts
// The issuer for personal accounts is always the same, according to jwt.ms
if (issuer == "https://login.microsoftonline.com/9188040d-6c67-4c5b-b112-36a304b66dad/v2.0") {

}
```

### Access graph api with user token

The [authentication middleware](#easy-auth) can also manage access tokens for your application, that is if you turned on the **Token Store**.

Microsoft will forward an access token for the user that is valid for the Graph api in the `X-MS-TOKEN-AAD-ACCESS-TOKEN` header. It also disallows some malicious user to add this header to a request. So if you're getting this header in your request, it is coming from Microsoft!

```csharp
var token = req.Headers["X-MS-TOKEN-AAD-ACCESS-TOKEN"]?.ToString();
```

## Easy Auth

The library handling the authentication is called "EasyAuth" internally. You can check out how it roughly works [here](https://docs.microsoft.com/en-us/azure/app-service/overview-authentication-authorization#feature-architecture-on-windows-non-container-deployment).

I think you can just see it as a gate in front of your web application. And you can configure it to always require a key `Require authentication` or to check the ID if the user has one but still allow users who didn't login `Allow unauthenticated requests`.

## Possible improvements

While the wizard to configure authentication is quite good to get started, I would like to see some improvements:

1. Support for the issuer `https://login.microsoftonline.com/organizations/v2.0`.
2. If you pick `Any Azure AD directory - Multi-tenant` in the wizard, it should automatically set the Issuer URL to this newly implemented special issuer.
3. If you pick `Any Azure AD directory & personal Microsoft accounts` it should set the Issuer URL to `https://login.microsoftonline.com/common/v2.0` because that is what you're asking for.
4. And lastly, it would be great if you can **configure a list of allowed issuers** in combination with either the `common` or the `organizations` issuer.
  That would make it a lot easier to support multi tenancy while still being able to control which tenants you allow to your application.

### Multi tenant applications require partner ID

If you got this far, you probably implemented your multi tenant authentication. Since November 9th of 2020 Microsoft requires a partner ID to be set on the application registration for users from other tenants to be able to consent to your application.

You can do this in at the [Azure AD portal](https://aad.portal.azure.com). `App registrations` -> `your app` -> `Branding`. Where you off course need a Microsoft Partner ID. You can get one by registering your company for the [Microsoft Action Pack](https://partner.microsoft.com/en-us/membership/action-pack) ($400/year).
