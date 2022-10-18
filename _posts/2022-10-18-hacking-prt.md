---
title: "Hacking Primary refresh tokens, oops created a virus"
published: true
categories:
  - Identity
tags:
  - Azure AD
  - Security
  - Research
twitter_image: /assets/images/2022/10/oops-virus-i-created.png
---

Windows has some cleaver ways to handle SSO in combination with Azure AD. They use this so called [Primary Refresh Token](https://learn.microsoft.com/en-us/azure/active-directory/devices/concept-primary-refresh-token). These highly sensitive key materials, are usually stored in the systems TPM (trusted platform module), a hardware device that can protect keys. And are "unlocked" when the user logs in.

[A post](https://posts.specterops.io/requesting-azure-ad-request-tokens-on-azure-ad-joined-machines-for-browser-sso-2b0409caad30), by [Lee Christensen](https://twitter.com/tifkin_) and the accompanying [RequestAADRefreshToken source](https://github.com/leechristensen/RequestAADRefreshToken), inspired me to check out what he had found.

<!--more-->

## Getting the token

I recommend you reading [this post](https://posts.specterops.io/requesting-azure-ad-request-tokens-on-azure-ad-joined-machines-for-browser-sso-2b0409caad30), where Lee explained the research to get these token in great detail. To summarize, here is what happening:

1. Chrome extension talks to **BrowserCore.exe** executable
2. BrowserCore calls **MicrosoftAccountTokenProvider.dll** COM object
3. The MicrosoftAccountTokenProvider uses data from the TPM to call the Azure AD endpoint
4. Chrome extension set the `x-ms-RefreshTokenCredential` cookie for the `login.microsoftonline.com` domain to the value got from the Token Provider.

If you then reload the page (at the login domain) if sees the cookie and won't ask you for your account details.

Without actual details on how this works, Microsoft [described](https://learn.microsoft.com/en-us/azure/active-directory/devices/concept-primary-refresh-token#prt-usage-during-app-token-requests) the process on their documentation page.

## Check if computer is allowed to get SSO tokens

Start a command prompt and run `dsregcmd.exe /status`, check for the SSO section, it should display `AzureAdPrt : YES`

```plain
+----------------------------------------------------------------------+
| SSO State                                                            |
+----------------------------------------------------------------------+

                AzureAdPrt : YES
      AzureAdPrtUpdateTime : 2022-10-18 07:44:27.000 UTC
      AzureAdPrtExpiryTime : 2022-11-01 07:44:26.000 UTC
       AzureAdPrtAuthority : https://login.microsoftonline.com/***
             EnterprisePrt : NO
    EnterprisePrtAuthority :
                 OnPremTgt : NO
                  CloudTgt : YES
         KerbTopLevelNames : .windows.net,.windows.net:1433,.windows.net:3342,.azure.net,.azure.net:1433,.azure.net:3342

```

## Get a token for our own app

I [forked](https://github.com/svrooij/RequestAADRefreshToken) Lee' code. To try if I got it to work. I converted the code to `NET6.0` because I did not have the original target framework installed.

And then this happened:

![Virus warning](/assets/images/2022/10/oops-virus.png)

When clicking the details, it showed me the following error:

![Virus warning](/assets/images/2022/10/oops-virus-i-created.png)

I had created a virus with the description `VirTool:MSIL/Radkt.B!MTB`. I guess Microsoft Defender doesn't like unsigned applications requesting tokens from the `MicrosoftAccountTokenProvider.dll`. Google could not enlighten me either.

## Conclusion

It is possible to get these tokens by calling a common dll on your windows device, if it's enrolled for SSO and if you disable Microsoft Defender. These tokens can also be put in an incognito browser window and work without issue.

I've not tested what happens if you extract such a token and use it on a different machine, possibly from a different IP.

Thinks that need further investigation:

- Are PRT tokens revoked if a new PRT is requested?
- What is the lifetime of the PRT?
- Will it work from a different IP-address?
- Why does Microsoft Defender thinks my program is a virus? And how can we circumvent this, signing the app, white listing it?
