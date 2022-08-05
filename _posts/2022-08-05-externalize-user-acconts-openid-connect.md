---
title: "Externalize user accounts: OpenID Connect"
categories:
  - Identity
tags:
  - OpenID Connect
  - Security
  - Microservice
  - "Series: Externalize Users"
twitter_image: /assets/images/2022/07/externalize-applications.png
---

Externalizing user accounts, what is he thinking? The [previous post](/2022/07/28/externalize-user-acconts-intro/) should give you a clear view what this means and why you should consider it. This post will go a into details of "delegating login" to a separate application.

<!--more-->

{% include block-series.html tag="Series: Externalize Users" %}

## Introducing OpenID Connect and OAuth2

Let's say you agree with the idea that user management should not be in the application, what if I tell you some clever people already designed [specifications](https://openid.net/developers/specs/) on how that login application should function. And how you can then delegate the actual login to this separate application.

Wow, hold-on why are you throwing all these pages of boring specifications at me? The OpenID Connect specification allows for various flows to validate users and **applications**. It also allows for login delegation. Your application just has to trust the login application to provide you with a immutable id for that specific user. How to setup the trust and how the login protocol works is all specified in the OpenID connect specification and the OAuth2 specification, where OpenID Connect specs are build upon.

The reason for me pointing at these specifications is because of all the scenarios (or flows) they support.

Most common user involved flows:

- Login a user unto a server-side web application (.net core / PHP / JSP) (authentication code flow). This is the flow most server side applications should start with.
- Login a user into a client-side or mobile application (hybrid flow with PKCE). Since client side applications can't hold secrets they need another flow.
- Login a user on a device with limited input capabilities, like TV's (device code flow).
- Validating a user (and the application) by it's actual credentials (the resource owner password flow), only use this in migrations! It should not be used for new developments, and you will be missing out some [easy authentication](#easy-authentication) features.

Flows without a user:

- Login in as an application (think service principals) to use another api.

<div class="mermaid">
sequenceDiagram
    participant u as User
    participant app as ToDo app
    participant api as ToDo API
    participant oid as OpenID Connect service
    u->>app:I want to use the app
    app->>u:I trust this site to handle login
    u->>oid: Can I login?
    oid->>oid: Validate user
    oid->>u: Here is a temporary token
    u->>app: I'm user x, load todos
    app->>api: Request todo items
    api->>api: Valid token present?
    note over api,oid: Optional back channel validation
    api-->>oid: Token valid?
    oid-->>api: Yes
    api->>app: ToDo items for the user
    app->>u: ToDo items for you
</div>

## Language independent

Since OpenID connect is a specification that has been around for many years, you can probably find how you can utilize it in your preferred language/application/os using your favorite search engine, just search for `openid connect x` (replace x with your language/os/application).

There also is a [list of certified libraries](https://openid.net/developers/certified/). On this list you can find both sides, (so the service providing OpenID connect and libraries to use OpenID Connect in your language/os/application).

In the next post I'll tell you more about the options you have for hosting your own OpenID Connect application.

As long as your login application follows the OpenID Connect specification, there are tons of libraries that you can use to help implement logging in without having to invent the wheel every time you develop/roll-out a new application.

## Token based

OpenID connect relies on tokens, a token is a digitally signed piece of information which the user can use to prove his identity. With OpenID connect you allow applications to get tokens for any user (or himself if no user is involved). These signed tokens can then be used to validate the that the application is being used by a user that has been successfully validated.

You can see this token as a visitors card when you visit some company. You go through reception, show your ID, or just sign a form and you get a visitors card. The automated doors, don't need to know how you got the visitors card (token), they only need to verify that it's valid. It doesn't even matter if it's a visitors card or an employee card, as long as the doors trust the system the issued it and have a secure way of validating that it's actually issued by the trusted system.

Maybe you can also get a visitors card with a longer lifetime if you're a contractor, and you get it by mail.

## Easy authentication

OpenID Connect is great, and every (wep/app) developer should at least know about it. You don't have to know all the inner workings (but you can, if you want to read through all the specs). What you do need to know is that it provides an easy way for your app to authenticate a user without worrying on how the validation of the user is going to be executed.

Maybe you require the user to validate his identity with an official country issued ID card. Or you require in-person validation. You don't want to build this in every application. Your application just wants to know the immutable ID of the user, and should not care about how that is validated.

When using OpenID Connect, you don't have to worry how the user is validated or even by who does the eventual validation, as long as you're using a trusted OpenID connect service. How the user is validated is managed in that application and you just trust it (using OpenID connect) to provide you with the immutable ID for that user.

### Login to mobile app with 10 lines of code

Wouldn't it be great if you could just add authentication to your mobile app, with just a few lines of code? With OpenID Connect you can.

MAUI [sample][maui-sample]:

```csharp
// Add to your MauiProgram.cs
builder.Services.AddSingleton(new OidcClient(new()
{
    Authority = "https://demo.duendesoftware.com",
    ClientId = "interactive.public",
    Scope = "openid profile api",
    RedirectUri = "myapp://callback",
    Browser = new MauiAuthenticationBrowser()
}));
```

Create a [MauiAuthenticationBrowser](https://github.com/IdentityModel/IdentityModel.OidcClient.Samples/blob/c636a3c97867d70cad5712641bdc86c8979de759/Maui/MauiApp2/MauiApp2/MauiAuthenticationBrowser.cs) and login.

```csharp
public partial class MainPage
{
    private readonly OidcClient _client;
    private string _currentAccessToken;

    public MainPage(OidcClient client)
    {
        InitializeComponent();
        _client = client;
    }

    private async void OnLoginClicked(object sender, EventArgs e)
    {
        var result = await _client.LoginAsync();

        if (result.IsError)
        {
            editor.Text = result.Error;
            return;
        }

        _currentAccessToken = result.AccessToken;
        // Do something with the token
    }
}
```

This is not meant as a complete sample on how this works in MAUI, check the [provided sample][maui-sample] for more details. Or follow the [documentation](https://docs.microsoft.com/en-us/azure/developer/mobile-apps/azure-mobile-apps/quickstarts/maui/authentication#configure-a-native-client-application) is you're using Azure AD.

[maui-sample]: https://github.com/IdentityModel/IdentityModel.OidcClient.Samples/tree/main/Maui/MauiApp2/MauiApp2

### Require login in you ASP.NET Core application

Add the following code to your ASP.NET Core website to enable external authentication. Follow the complete example at [dotnet core docs](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/secure-net-microservices-web-applications/#authenticate-with-an-openid-connect-or-oauth-20-identity-provider)

```csharp
public void Configure(IApplicationBuilder app, IHostingEnvironment env)
{
    //…
    app.UseAuthentication();
    //…
    app.UseEndpoints(endpoints =>
    {
        //...
    });
}

public void ConfigureServices(IServiceCollection services)
{
    var identityUrl = Configuration.GetValue<string>("IdentityUrl");
    var callBackUrl = Configuration.GetValue<string>("CallBackUrl");
    var sessionCookieLifetime = Configuration.GetValue("SessionCookieLifetimeMinutes", 60);

    // Add Authentication services

    services.AddAuthentication(options =>
    {
        options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddCookie(setup => setup.ExpireTimeSpan = TimeSpan.FromMinutes(sessionCookieLifetime))
    .AddOpenIdConnect(options =>
    {
        options.SignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.Authority = identityUrl.ToString();
        options.SignedOutRedirectUri = callBackUrl.ToString();
        // Don't do this, save them in configuration. Just for simplicity
        options.ClientId = "your_client_id";
        options.ClientSecret = "your_secret";
        options.ResponseType = "code id_token";
        options.SaveTokens = true;
        options.GetClaimsFromUserInfoEndpoint = true;
        options.RequireHttpsMetadata = true;
        options.Scope.Add("openid");
        options.Scope.Add("profile");
        // Add extra scopes if required.
    });
}
```

## Summary

In the [previous post](/2022/07/28/externalize-user-acconts-intro/) I wrote about what I mean with externalizing user accounts. This post gave an overview of OpenID Connect, and the next posts of this series will be about your options for self-hosting an OpenID connect application.

Still as enthusiastic about externalizing your user accounts as me? Have any other thoughts? Let me know on <a href="https://twitter.com/intent/tweet?url={{ page.url | absolute_url | url_encode }}&text={{page.title | url_encode}}&via={{ page.author | default: site.social_media.twitter }}">Twitter</a>

<script src="{{ "/assets/mermaid-8.9.2/mermaid.min.js" | relative_url }}"></script>
