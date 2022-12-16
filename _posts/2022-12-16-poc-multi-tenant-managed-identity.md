---
title: "Proof of concept: Multi tenant managed identity"
published: true
categories:
  - Identity
tags:
  - Azure AD
  - Managed identity
twitter_image: /assets/images/2022/06/add-federated-credential.png
---

Ever since Microsoft created [managed identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview), people are asking how/if they work for multi-tenant applications. They even spend a [faq](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/managed-identities-faq#can-i-use-a-managed-identity-to-access-a-resource-in-a-different-directorytenant) on it.

In my [previous post](https://svrooij.io/2022/06/21/managed-identity-multi-tenant-app/) I wrote that it was possible to use a managed identity to get access tokens for some multi tenant application, if you haven't seen that post be sure to check it out since this post uses the knowlage from that post to demo the process.

## Deploy the demo app

I've build a basic Azure Functions app, so you can try out the process and request tokens using managed identities. Go to [this repo][sample-repo] and deploy the functions app to Azure in your own desired way. For this one time deploy, I would use the wizard in Visual Studio, but all options are open.

Be sure to enable a system managed identity in the azure portal, take note of the managed identity object ID.

The app has swagger (available at `https://{yourazfunctions}.azurewebsites.net/api/swagger/ui`) that documents all the endpoints.

Each function is configured to use function keys for authorization. It's a **BAD** idea to turn it off as it would allow the world to get tokens from your tenant. Requesting tokens using managed identities is rate limited, and could then trigger 429 faults in other services in your tenant.

## Create federation app

The **federation application** is used in the process of getting an access token. This app is used to request a token using the managed identity, so it has to be in the same tanent as the managed identity (or have a service principal in that tenant).

1. Create a new application in [App registrations](https://adappreg.cmd.ms/) in the Azure portal.
2. Pick any name you want, I suggest `Multi tenant Federation APP`.
3. Leave the redirect URI empty, not needed.
4. Take note of the **Application ID**
5.  Click **Expose an API** and set the **Application ID URI** to `api://{application-id}` eg. `api://db928b6c-4cb6-4f50-99af-dcafd5cda748` (with the actual ID of the application off source).
6. Click **Manifest**, update the `accessTokenAcceptedVersion` to `2` and press **Save**.

If you already deployed the [demo functions app][sample-repo], you can now try the `/GetManagedIdentityToken` endpoint, with the new application id uri suffixed with `/.default` as scope. Eg. `api://db928b6c-4cb6-4f50-99af-dcafd5cda748/.default`

## Register federation app as federated credential

Open an existing application in the Entra portal under [App registrations](https://adappreg.cmd.ms/).

1. Open **Certificates & Secrets** and click **Federated Credentials**
2. Click **Add Credential** and enter the following details.

![Add managed credential](/assets/images/2022/12/add-federated-credential.png)

- **Federated credential scenario** - `Other issuer`
- **Issuer** - `https://login.microsoftonline.com/{managed-identity-tenant-id}/v2.0` replace with tenant id where the managed identity is in.
- **Subject Identifier** - `{managed-identity-object-id}`
- **Name** - Any name will suffice, but you cannot change it afterwards. Be descriptive.
- **Description** - Any description will work, my suggestion: `Managed identity {application name} in {tenant} registered by {your username}`
- **Audience** - Change this to the Application ID URI of your federation app!

Press **Add** when you filled in all the details.

## Try it out

Go back to Azure Functions app and try either `/GetAppTokenUsingManagedIdentity` or `GetAppTokenUsingManagedIdentityWithLib`. If you want to know how it actually works, you can check out the [steps](/2022/06/21/managed-identity-multi-tenant-app/#managed-identity-as-federated-credential) or you can browse the [code](https://github.com/svrooij/MultiTenantManagedIdentity/blob/2483297f35515079703227fb6ca6fab6aa8ae8fd/MultiTenantManagedIdentity/GetAppTokenUsingManagedIdentity.cs#L48-L81) for the `/GetAppTokenUsingManagedIdentity` endpoint, which has some great explaination.

## Use this yourself

Our [Micrsoft.Identity.Client extensions](https://www.nuget.org/packages/Smartersoft.Identity.Client.Assertion/) have support for the following code, but the extension is really [small](https://github.com/Smartersoft/identity-client-assertion/blob/62e6e7c0fc00487a97f62c02aa1865f4ad9f55b4/src/Smartersoft.Identity.Client.Assertion/ConfidentialClientApplicationBuilderExtensions.cs#L138-L163) that if you're not using the KeyVault part of our extensions, I would just use the code here.

```csharp
var app = ConfidentialClientApplicationBuilder
  .Create(clientId)
  .WithAuthority(AzureCloudInstance.AzurePublic, tenantId)
  .WithManagedIdentity(federatedScope)
  .Build();
```

Code to extend **ConfidentialClientApplicationBuilder** yourself

```csharp
using Azure.Core;
using Azure.Identity;
using Microsoft.Identity.Client;
using System;
using System.Threading;
namespace YourNamespace;
public static class ConfidentialClientApplicationBuilderExtensions
{
  /// <summary>
  /// Add a client assertion using a Managed Identity, configured as Federated Credential.
  /// </summary>
  /// <param name="applicationBuilder">ConfidentialClientApplicationBuilder</param>
  /// <param name="managedIdentityScope">The scope used for the federated credential api</param>
  /// <see href="https://svrooij.io/2022/12/16/poc-multi-tenant-managed-identity/">Blog post</see>
  /// <remarks>This is experimental, since federated credentials are still in preview.</remarks>
  public static ConfidentialClientApplicationBuilder WithManagedIdentity(this ConfidentialClientApplicationBuilder applicationBuilder, string managedIdentityScope) => applicationBuilder.WithManagedIdentity(managedIdentityScope, new ManagedIdentityCredential());

  /// <summary>
  /// Add a client assertion using a Managed Identity, configured as Federated Credential.
  /// </summary>
  /// <param name="applicationBuilder">ConfidentialClientApplicationBuilder</param>
  /// <param name="managedIdentityScope">The scope used for the federated credential api, eg. `{app-uri}/.default`</param>
  /// <param name="managedIdentityCredential">Use any TokenCredential (eg. new ManagedIdentityCredential())</param>
  /// <see href="https://svrooij.io/2022/12/16/poc-multi-tenant-managed-identity/">Blog post</see>
  /// <remarks>This is experimental, since federated credentials are still in preview.</remarks>
  public static ConfidentialClientApplicationBuilder WithManagedIdentity(this ConfidentialClientApplicationBuilder applicationBuilder, string managedIdentityScope, TokenCredential managedIdentityCredential)
  {
    return applicationBuilder.WithClientAssertion(async (AssertionRequestOptions options) =>
    {
        var tokenResult = await managedIdentityCredential.GetTokenAsync(new TokenRequestContext(new[] { managedIdentityScope }), options.CancellationToken);
        return tokenResult.Token;
    });
  }
}
```

The code is only tested in the client credentials flow (eg. no user involved), but I see no reason why it should not work in a delegated flow where you normally use client credentials (secret or certificate).

- [sample-repo]: https://github.com/svrooij/MultiTenantManagedIdentity
