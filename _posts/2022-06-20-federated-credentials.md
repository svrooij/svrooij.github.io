---
title: "Federated credentials, wait what?"
published: true
categories:
  - Identity
tags:
  - Azure AD
  - Identities
  - Secrets
twitter_image: /assets/images/2022/06/federated-credentials.png
---

Workflow identity federation of "federated credentials" as they are called in the Azure Portal are brand new in the Microsoft identity suite. As of writing they are still in preview.

What are they and how does it work? This will all be explained in the post below.

![federated credentials on Azure portal](/assets/images/2022/06/federated-credentials.png)

<!--more-->

## Why would you need federated credentials?

Managing secrets is hard, as I explained several times on this blog, like [here](/2022/02/04/token-proxy/). If you can get someone else to manage the credentials for you, you should go for that options and have the other party worry about the credentials.

## What are these federated credentials?

Microsoft wrote a great [description](https://docs.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation) on Workload identity federation, but in my own words, it's trusting some pre-configured (external) identity provider to request tokens for an application in Azure AD, while using the token from the external IDP instead of a [client assertion](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-certificate-credentials). So instead of signing the token request with a certificate, you configure Azure AD to trust external tokens as if they where client assertions.

### How do federated credentials actually work?

<div class="mermaid">
sequenceDiagram;
    participant c as Client application
    participant aad as Azure AD
    participant idp as External Identity Provider
    participant r as Resource protected by Azure AD
    c->>idp: Give me a token for reource x
    idp->>c: Access token for x
    note right of c: External token
    c->>aad: Give me a token for resource y
    aad-->>aad: Issuer configured?
    aad->>idp: Download IDP metadata (OpenID Connect)
    idp->>aad: External metadata
    aad->>aad: Validate signature
    aad->>aad: Subject and audience matching app registration?
    note right of c: Azure AD token
    aad->>c: Issue access token
    c->>r: Here is the access token from Azure AD
</div>

<script src="{{ "/assets/mermaid-8.9.2/mermaid.min.js" | relative_url }}"></script>

## I like federated credentials

I really like the idea of federated credentials. This is a great example how important security management is. And using federated credentials allows you to secure stuff without knowing the secret. If you don't have/manage a secret, it can never be [extracted](/2022/05/27/certificate-extraction-client-credentials/) because there is nothing to extract.

Mind you that as of today (May 20th 2022), this is still in *preview* which means that you can try it out, but should not use it in any production workloads.
