---
title: "Extract all users with powershell and what to do about it part two"
published: true
categories:
  - Security
tags:
  - Powershell
  - Microsoft Graph
  - Data Extraction
twitter_image: /assets/images/2022/05/extract-azure-ad-users.png
---

In a [previous post](/2022/05/16/extract-all-users-with-powershell/) I showed how to extract all users from a Microsoft 365 tenant, and what you should do about that. If you followed along that leak got restricted. The Azure AD module isn't the only way to extract user information from a tenant. This post will show you how to do the same (extract all users to csv file) with the Graph PowerShell modules and what you should do about that.

<!--more-->

## Install Graph PowerShell modules

First you need to install some PowerShell modules:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser
Install-Module Microsoft.Graph.Users -Scope CurrentUser
# or just importing if previously installed
# Import-Module Microsoft.Graph.Authentication
# Import-Module Microsoft.Graph.Users
```

## All available users to CSV

Let's say you want all the available users in your tenant "safely" stored in a CSV file on your local machine.

```powershell
# This will open a Microsoft login screen and save the resulting session
$graphSession = Connect-MgGraph -Scopes "User.Read.All"

# Create temp file
$filename = $(New-TemporaryFile).FullName + ".csv" # or "C:\temp\user.csv"

# This command will load the top 5 users, but you can modify this accordingly. It's just a demonstration....
# see https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.users/get-mguser?view=graph-powershell-1.0
#
# it selects some properties (adjust accordingly)
# and exports to the filename
Get-MgUser -Top 5 `
  | Select-Object -Property Id,AccountEnabled,UserPrincipalName,Mail,GivenName,Surname,DisplayName,JobTitle `
  | Export-Csv -Path $filename

Write-Host "Users exported to $filename"
```

That was easy, 6 lines of "code" and you have a CSV file with all the users in your organization.

## Is this a problem?

Not exactly, but it might be a problem if you have a lot of users. Such a csv file with hundreds/thousands users might be considered a data leak.
Still no problem, because powershell is only for administrative accounts, right? **RIGHT??** Wrong... By default **EVERY** user in your Microsoft 365 tenant is able to do this read action with powershell.

## Restrict access to Graph powershell

Let's see if we can find a way to prevent access for most users. As said this command `Connect-MgGraph` triggers a login screen, since I know which user logged-in to this PowerShell module at what exact time, I could directly find an entry in the Sign-in logs for this user, pointing me in the right direction.

![Microsoft Graph PowerShell - Sign-in log](/assets/images/2023/01/graph-powershell-login.png)

I found a login for application **Microsoft Graph PowerShell** with ID: `14d82eec-204b-4c2f-b7e8-296a70dab67e`.
This application did request access to **Microsoft Graph** with ID: `00000003-0000-0000-c000-000000000000` so the sign-in logs prove the Microsoft Graph PowerShell module is actually using the Graph API.

At first I opened **Enterprise Applications**, switched to Microsoft Applications and looked for `Microsoft Graph`. The idea was, if I find the Microsoft Graph PowerShell application there, I'll just turn on **User assignment required** and only allow the few users I want.

![Microsoft Graph Powershell - Not found](/assets/images/2023/01/graph-application-not-found.png)

No luck there. It shows the resource application though, but I don't want to mess with the Azure AD internals. The resource application `Microsoft Graph` **SHOULD NOT BE TOUCHED**. You will mess up a lot!

If you switch to **All Applications** the Microsoft Graph PowerShell application shows up. Just flip the switch Assignment required to `Yes` and press save. Go to Users and Groups and assign the application to the users who require it.

![Microsoft Graph Powershell - Assignemnt required](/assets/images/2023/01/microsoft-graph-assignment-required.png)

## Block Microsoft Graph module with PowerShell

By design not all options are shown on the Azure AD portal, and messing with options that are hidden by design might lead to unrecoverable results.
Check the script below, careful, before executing (as with any script from a remote source).

This script uses powershell to change the service principal of the AzureAD application that is used to get tokens.

```powershell
Connect-MgGraph -Scopes 'Application.ReadWrite.All'

$appId = "14d82eec-204b-4c2f-b7e8-296a70dab67e" # Microsoft Graph Powershell

# Get or create service principal
$sp = Get-MgServicePrincipal -Filter "appId eq '$appId'"
if (-not $sp) {
  $sp = New-MgServicePrincipal -AppId $appId
}

$ServicePrincipalUpdate =@{
    "appRoleAssignmentRequired" = "true"
    }

Update-MgServicePrincipal -ServicePrincipalId $sp.Id -BodyParameter $ServicePrincipalUpdate
```

## No more user access to this module

If some other user tries to use the Graph PowerShell modules, they are greeted with an `AADSTS50105` error meaning you successfully blocked the application for other users. The error is descriptive enough for users who actually need this module to know what to do (ask the admin to grant access).

![Microsoft Graph Powershell - Blocked](/assets/images/2023/01/graph-powershell-no-access.png)

## Unblock access to Graph PowerShell module

```powershell
Connect-MgGraph -Scopes 'Application.ReadWrite.All'

$appId = "14d82eec-204b-4c2f-b7e8-296a70dab67e" # Microsoft Graph Powershell

# Get or create service principal
$sp = Get-MgServicePrincipal -Filter "appId eq '$appId'"
if (-not $sp) {
  $sp = New-MgServicePrincipal -AppId $appId
}

$ServicePrincipalUpdate =@{
    "appRoleAssignmentRequired" = "false"
    }

Update-MgServicePrincipal -ServicePrincipalId $sp.Id -BodyParameter $ServicePrincipalUpdate
```

## Conclusion

In my opinion this module and the one from the [previous post](/2022/05/16/extract-all-users-with-powershell/) should be blocked by default (maybe by the security defaults?) Be sure to share this post with all other system administrators you know. It will take them less then 5 minutes to block these modules and that makes their organization just a little more secure.

[![LinkedIn Profile][badge_linkedin]][link_linkedin]
[![Link Mastodon][badge_mastodon]][link_mastodon]
[![Follow on Twitter][badge_twitter]][link_twitter]
[![Check my blog][badge_blog]][link_blog]

<a href="https://mvp.microsoft.com/en-us/PublicProfile/5004985" target="_blank"><img src="/assets/images/MVP_Badge_Horizontal_Preferred_Blue3005_RGB.png" width=300 /></a>

[badge_blog]: https://img.shields.io/badge/blog-svrooij.io-blue?style=for-the-badge
[badge_linkedin]: https://img.shields.io/badge/LinkedIn-stephanvanrooij-blue?style=for-the-badge&logo=linkedin
[badge_mastodon]: https://img.shields.io/mastodon/follow/109502876771613420?domain=https%3A%2F%2Fdotnet.social&label=%40svrooij%40dotnet.social&logo=mastodon&logoColor=white&style=for-the-badge
[badge_twitter]: https://img.shields.io/twitter/follow/svrooij?logo=twitter&style=for-the-badge&logo-color=white
[link_blog]: https://svrooij.io/
[link_linkedin]: https://www.linkedin.com/in/stephanvanrooij
[link_mastodon]: https://dotnet.social/@svrooij
[link_twitter]: https://twitter.com/svrooij
