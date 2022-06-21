---
title: "Using a managed identity as a client credential"
published: true
categories:
  - Identity
tags:
  - Azure AD
  - Managed identity
twitter_image: /assets/images/2022/06/add-federated-credential.png
---

Ever since Microsoft created [managed identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview), people are asking how/if they work for multi-tenant applications. They even spend a [faq](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/managed-identities-faq#can-i-use-a-managed-identity-to-access-a-resource-in-a-different-directorytenant) on it.

Previously you had to go through [some hoops](/2022/01/20/secure-multi-tenant-app/) to use managed identities with your multi tenant app.

Let's have a look if we can solve this with in combination with [federated credentials](/2022/06/20/federated-credentials/).

<!--more-->

## Going Password-less for multi tenant applications

Secrets are hard to keep secret. Microsoft wants all users to go [passwordless](https://www.microsoft.com/security/blog/2021/09/15/the-passwordless-future-is-here-for-your-microsoft-account/), which is a great way to prevent being hacked by password stealing/guessing. If there is no password there is nothing to guess.

Microsoft created [managed identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) so apps running in your own tenant would get a managed credential, being able to request tokens for services in your tenant. These are great but, you cannot (yet?) use them in multi tenant applications. In our case the application runs in our own tenant, but we wish to modify resources in an other tenant. We have recently migrated all our applications to use a [managed identity and a certificate in the KeyVault](/2022/05/27/certificate-extraction-client-credentials/#signed-client-assertion-without-certificate-access).

This is about to get even easier. I discovered that you can register your managed identity as a federated credential which is currently in preview. This takes away the need for the KeyVault, which should make this solution faster.

## What are federated credentials

Federated credentials are a way to tell Azure AD, "I trust this (external) IDP, to issue tokens and if the token matches these requirements (`aud`, `iss` and `sub` claim), you can go ahead and grant a token for this app". Check out [federated credentials](/2022/06/20/federated-credentials/) for more details.

## Prerequisites

Before you can get started using federated credentials, make sure you have the following already setup.

1. Azure AD application with Application ID URI defined (needed to get a token) and the access token version set to 2 [see app manifest](https://docs.microsoft.com/en-us/azure/active-directory/develop/reference-app-manifest#accesstokenacceptedversion-attribute). This app has to be in the same tenant as the managed identity or has to have a service principal in that tenant.
2. Access to an Azure AD application where you're going to configure a federated credential.
3. Your tenant ID

## Federated credentials are in preview

Currently (May 21th 2022) federated credentials are in **preview** and the documentation explicitly states using Azure AD as federated credentials isn't supported. This is just an **experiment**, to see how far we can take this. Use with caution!

## Required configuration

We need some information to configure a federated credential on an application. The portal asks us for the following information:

![Add federated credential on Azure portal](/assets/images/2022/06/add-federated-credential.png)

| What | Description | Sample |
|======|=============|========|
| `Issuer` | Issuer of the token, `iss` claim and metadata download | `https://login.microsoftonline.com/{managed-identity-tenant-id}/v2.0` |
| `Subject Identifier` | Subject of the token, `sub` claim. Guid in case of Azure AD | `c135c981-5d8e-4b80-84ea-d616a6a8167c` (fake, replace with own) |
| `Name` | Name of the federated credential (cannot be changed). For your reference | |
| `Description` | Description of the federated credential (cannot be changed). For your reference | |
| `Audience` | Audience of the token, `aud` claim in token! Change to Application ID URI of your resource app |`api://d788405b-c575-41d1-83a9-83e8cbab062e` (fake, replace with your own)|

### Get token with managed identity

Most tokens issued by Azure AD are Json Web Tokens (JWT for short). And these tokens can be crafted to match the requirements for a federated credential. Seeing the required fields when configuring a federated credential, made me wonder if I could combine this information with [request token with managed identity](/2022/04/21/access-api-with-managed-identity/#request-a-token-for-an-api) from an earlier post.

With a managed identity you can request a token for any api (or to serve as a federated credential) with a few lines of code.

```csharp
using Azure.Core;
using Azure.Identity;
...
// To request a token using managed identity, the scope has to be the "give me a token with all granted permissions" default. (App URI ID + .default)
var scope = "api://d788405b-c575-41d1-83a9-83e8cbab062e/.default";
var tokenCredential = new ManagedIdentityCredential();
var tokenResponse = await tokenCredential.GetTokenAsync(
  new TokenRequestContext(new[] { scope }),
  cancellationToken
);
```

If you followed along [this post](/2022/04/21/access-api-with-managed-identity/) you should have a lot already figured out. The code above is telling Azure AD to give you an access token for the api you specified. Your managed identity probably doesn't have access to this api, but it will get a token without any app roles anyway, (which is why your application should always validate roles or explicit subjects).

Your decoded token will look something like this:

```jsonc
// header is skipped for readability
{
  "iss": "https://login.microsoftonline.com/480ec605-0c1d-4a95-a88b-83a50f18152b/v2.0", // Includes tenant ID of managed identity
  "aud":"api://d788405b-c575-41d1-83a9-83e8cbab062e", // The Application ID Uri of the app in the request above
  "sub": "c135c981-5d8e-4b80-84ea-d616a6a8167c", // this will be the object id of the managed identity
  "oid": "c135c981-5d8e-4b80-84ea-d616a6a8167c", // this will be the object id of the managed identity as well
  // more irrelevant claims
}
```

Try this yourself, get a token for one of your own api's using the code above, and inspect the token at [jwt.ms](https://jwt.ms).

### Putting it all together

Inspecting the token you got with your managed identity, and comparing it to the details of your managed identity you have probably figured out that the subject claim (`sub`) in the token is the Object ID of the service principal.

With the details of the managed identity or the inspected token, we can go ahead an enter all the needed details in the add federated credential screen in the portal. Azure AD -> App registrations -> Your multi-tenant app -> Certificates & Secrets -> Federated credentials -> Add credential

| What | Description |
|======|=============|
| `Issuer` | `https://login.microsoftonline.com/{managed-identity-tenant-id}/v2.0` |
| `Subject Identifier` | Object ID of managed identity |
| `Name` | Suggestion: `mi-{appName}-{tenant}` |
| `Description` | Suggestion: `Managed identity {name of managed identity} in {tenantId}` |
| `Audience` | `api://d788405b-c575-41d1-83a9-83e8cbab062e` |

## Managed identity as federated credential?

<div class="mermaid">
sequenceDiagram;
    participant c as Client application
    participant aad as Azure AD Resource
    participant idp as Azure AD managed identity
    participant r as Resource protected by Azure AD
    note right of c: Managed identity
    c->>idp: Give me a token for scope api://d788405b-c575-41d1-83a9-83e8cbab062e/.default
    idp->>c: Access token for api://d788405b-c575-41d1-83a9-83e8cbab062e
    note right of c: External token (from Azure AD)
    c->>aad: Give me a token for resource y
    aad-->>aad: Issuer configured?
    aad->>idp: Download IDP metadata (OpenID Connect)
    idp->>aad: External metadata
    aad->>aad: Validate signature
    aad->>aad: Subject and audience matching registration?
    note right of c: Azure AD token
    aad->>c: Issue access token
    c->>r: Here is the access token from Azure AD
</div>

<script src="{{ "/assets/mermaid-8.9.2/mermaid.min.js" | relative_url }}"></script>

### Managed identity as client assertion

The token that we got with the managed identity (or other means), needs to be send to Azure as `client_assertion` in the client credentials flow. That is where normally the custom jwt signed with a certificate goes. See [documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow#third-case-access-token-request-with-a-federated-credential) for more details.

## Managed identities unsupported?

I cannot state enough that this scenario IS NOT SUPPORTED at the moment. I heard rumors about using managed identities as application credentials, and this might just be how they are going to do that. Once officially released, you'll probably have an extra tab next to federated credentials with a wizard to set all the required properties of the federated credential for you.

My guess it that on the identity side they will just re-use the federated credential part, since all the parts seem to be there.

What do you think? Is this a hack or just a cleaver way of looking at things?
