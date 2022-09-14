---
title: Protect against SSO for Graph PowerShell
categories:
  - Security
tags:
  - Administration
  - PowerShell
  - "Series: MSGraph PowerShell"
twitter_image: /assets/images/2022/09/graph-powershell-conditional-access.png
---

Why would you want to disable SSO for some cloud app, we love SSO, it makes our life easier? I agree, single-sign-on is great, until it is used without the knowlage of a user that logged-in with his admin account (don't do that!).

<!--more-->

{% include block-series.html tag="Series: MSGraph PowerShell" %}

## Graph PowerShell

Microsoft released [Graph PowerShell Modules](https://docs.microsoft.com/en-us/powershell/microsoftgraph/get-started?view=graph-powershell-1.0), some time ago. It's really easy to manage stuff in your tenant with these new modules. You can use it to do all the requests in the [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/use-the-api).

For instance managing [team owners](/2022/09/13/replace-teams-owner/)

## Single-sign-on

If you call the code below it will open a login request in your default browser. This will query the user for consent the first time. If the user already consented the requested scopes the login prompt is closed immediately, and the script has an access token that is valid for 1 hour. In this case the script can modify all groups in our tenant.

```powershell
$tenantId = "21009bcd-06df-4cdf-b114-e6a326ef3368";
Connect-MgGraph -TenantId $tenantId -Scopes "User.Read.All","GroupMember.ReadWrite.All";
```

So if you're logged-in, in your default browser as admin and you already used this module at least once, every script that is executed will get a token without user interaction. And this token might have access to modify group memberships (depending on the requested scopes).

You should never execute scripts that you didn't check, but attackers might find a way to start a script without the user knowing. Being able to start a script as the current user is bad enough, but if that script is able to get this precious token for the Graph API, things might end badly.

## Conditional access to the rescue

Let's create a new conditional access policy to at least enforce the use to re-authenticate every hour. This limits the access surface. You can off course also force the use of MFA or a trusted device.

The trick is in the *Cloud apps or Actions part*, to target Microsoft Graph PowerShell, you'll need the App ID, since searching won't show what you're looking for.
The App ID used by the Graph PowerShell module is: `14d82eec-204b-4c2f-b7e8-296a70dab67e`.

Next set the other parameters as required, in the sample I picked Sign-in frequency 1 hour, but your millage may vary.

![Microsoft Graph conditional access](/assets/images/2022/09/graph-powershell-conditional-access.png)
