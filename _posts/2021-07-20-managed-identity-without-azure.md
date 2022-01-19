---
title: "Using Managed Identity without Azure"
published: true
categories:
  - Development
tags:
  - Azure
  - Managed identity
card_image: /assets/images/header-development.png
---

Azure [managed identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) are great. You just turn it on and your Azure Resource can request a token for other resources that support it in your tenant. This way each resource in Azure can get it's own "identity" and Microsoft will manage the credentials for you. You'll no longer have to store credentials in the configuration as this is all part of the managed services.

This post will give you an in-depth view of how Azure allows several client apps to requests tokens for Azure Resources.

<!--more-->

## Using a Managed Identity in dotnet core

Using a managed identity in dotnet core, is really easy.

1. Install `Azure.Identity`
2. Use the [DefaultAzureCredential](https://docs.microsoft.com/en-us/dotnet/api/overview/azure/identity-readme#defaultazurecredential) in the resource sdk you like.

A lot for resource have [support](#services-with-support-for-managed-identities) for these managed identities.

The **Azure.Identity** package provides an instance of the [TokenCredential](https://github.com/Azure/azure-sdk-for-net/blob/d59fb44d80535838c5ecb88522582a97b79bbcff/sdk/core/Azure.Core/src/TokenCredential.cs) abstract class. This instance  can be used in all Azure SDK libraries that require authentication.

### Default Credentials order

If you use the `new DefaultAzureCredential()` you'll get the default order of authentication methods, first environment then Managed Identity and then the rest.

![Default credentials order](/assets/images/2021/07/2021-07-20-DefaultAzureCredentialAuthenticationFlow.png "Default credentials from https://docs.microsoft.com/en-us/dotnet/api/overview/azure/identity-readme#specifying-a-user-assigned-managed-identity-with-the-defaultazurecredential")

You can exclude all these methods of authentication by setting the options. Or for the advanced users, you can create your own [ChainedTokenCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.chainedtokencredential?view=azure-dotnet).

## Use cases for EnvironmentCredential

Some use-cases for not using managed identities, but using the environment variables are:

- **During development in containers**
- Using managed identity in resources that don't support managed identity just yet
- Running tests that require some sort of access token
- Pipeline access to Key Vault
- SQL migrations from pipeline
- Running a copy of you code on a non-azure resource

The `EnvironmentCredential` is loaded first *by default*. You can use then to (temporary) override the `ManagedIdentityCredential`. By setting the 3 required environment variables to something else you can trigger a Failed authentication error.

We mainly use these environment variables during development, most of our applications run in containers. And we could not find an easy way to use the managed identities during development. So for now we just set the required environment variables in the containers. This way we didn't have to change any code to test our application.

### EnvironmentCredential explained

As said the `DefaultAzureCredential` first checks if it can request a token with the [EnvironmentCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.environmentcredential?view=azure-dotnet), this will check the existence of some environment variables and tries to used those to get an access token.

- `AZURE_TENANT_ID` Always needed for the EnvironmentCredential
- `AZURE_CLIENT_ID` Always needed for the EnvironmentCredential
- `AZURE_CLIENT_SECRET` or `AZURE_CLIENT_CERTIFICATE_PATH` needed for Client Credentials Flow
- `AZURE_USERNAME` and `AZURE_PASSWORD` for old fashioned resource-owner flow with User/Password authentication, MFA is **not supported**.

### ManagedIdentityCredential explained

The [ManagedIdentityCredential](https://github.com/Azure/azure-sdk-for-net/blob/d59fb44d80535838c5ecb88522582a97b79bbcff/sdk/identity/Azure.Identity/src/ManagedIdentityCredential.cs) tries to create a [ManagedIdentityClient](https://github.com/Azure/azure-sdk-for-net/blob/d59fb44d80535838c5ecb88522582a97b79bbcff/sdk/identity/Azure.Identity/src/ManagedIdentityClient.cs) which in turn tries to create several [ManagedIdentitySources](https://github.com/Azure/azure-sdk-for-net/blob/d59fb44d80535838c5ecb88522582a97b79bbcff/sdk/identity/Azure.Identity/src/ManagedIdentitySource.cs)

They all work slightly different but in the end they all have a **http** endpoint where they send a request.

For the [CloudShellManagedIdentitySource](https://github.com/Azure/azure-sdk-for-net/blob/d59fb44d80535838c5ecb88522582a97b79bbcff/sdk/identity/Azure.Identity/src/CloudShellManagedIdentitySource.cs#L48-L73) 
the endpoint is stored in the `MSI_ENDPOINT` environment variable .

Display all environment variables in powershell `Get-ChildItem -Path Env:\` and take the endpoint which was `http://localhost:50xxx/oauth2/token` in that cloud shell session. Once you have this endpoint, you can request an access token for any resource by specifying the `resource` parameter with the resource uri you want a token for.

To get an access token for the Azure Key Vault (resource uri `https://vault.azure.net`), you just run the following code in your cloud shell session:

```powershell
$token_uri = $env:MSI_ENDPOINT + '?resource=https%3A%2F%2Fvault.azure.net'
$token_response = Invoke-RestMethod -Uri $token_uri -Method GET -Headers @{Metadata="true"}
write-output $token_response
```

The last source checked is the [ImdsManagedIdentitySource](https://github.com/Azure/azure-sdk-for-net/blob/d59fb44d80535838c5ecb88522582a97b79bbcff/sdk/identity/Azure.Identity/src/ImdsManagedIdentitySource.cs) which doesn't depend on any environment variables, but just tries to get a token from a constant token endpoint. Any resource that supports managed identities has access to the endpoint at `169.254.169.254`. This last ManagedIdentitySource just tries to see if it can create a TCP connection to this IP at port 80, within 1 second.

As you can see there is no additional information about the client or user requesting the token being send to this endpoint. That is all managed in the background.

## Performance improvements

Since the **DefaultAzureCredential** tries several methods to get a token, it might help to disable the once you will not be using (during development). The **ManagedIdentityCredential** adds at least a second during initialization of the DefaultIdentityCredential, if none of the previous methods resulted in valid credentials.

## Services with support for managed identities

- [Azure Key Vault](https://docs.microsoft.com/en-us/dotnet/api/overview/azure/identity-readme#authenticating-with-the-defaultazurecredential)
- [Azure Event Hub](https://docs.microsoft.com/en-us/dotnet/api/overview/azure/identity-readme#enabling-the-interactive-authentication-with-the-defaultazurecredential)
- [Azure Blob storage](https://docs.microsoft.com/en-us/dotnet/api/overview/azure/identity-readme#specifying-a-user-assigned-managed-identity-with-the-defaultazurecredential)

Just to name a few.
