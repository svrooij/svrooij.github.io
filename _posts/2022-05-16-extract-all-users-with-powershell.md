---
title: "Extract all users with powershell and what you should do about it"
published: true
categories:
  - Security
tags:
  - Powershell
  - AzureAD
twitter_image: /assets/images/2022/05/extract-azure-ad-users.png
---

Powershell is pretty powerful for all kind of administrative tasks, especially if you load some extra modules. We use the [AzureAD](https://docs.microsoft.com/en-us/powershell/module/azuread/) module for a lot of tasks that can be (semi-)automated with the use of some script.

<!--more-->

## Install AzureAD module

Installing a module should be a breeze, for completeness, here is the command:

```powershell
Install-Module AzureAD
# or just importing if previously installed
# Import-Module AzureAD
```

## All available users to CSV

Let's say you want all the available users in your tenant "safely" stored in a CSV file on your local machine.

```powershell
# This will open a Microsoft login screen and save the resulting session
$adSession = Connect-AzureAD

# Create temp file
$filename = $(New-TemporaryFile).FullName # or "C:\temp\user.csv"

# This command will load the top 5 users, but you can modify this accordingly
# see https://docs.microsoft.com/en-us/powershell/module/azuread/get-azureaduser
#
# it selects some properties (adjust accordingly)
# and exports to the filename
Get-AzureADUser -Top 5 `
  | Select-Object -Property ObjectId,AccountEnabled,UserPrincipalName,Mail,GivenName,Surname,DisplayName `
  | Export-Csv -Path $filename

Write-Host "Users exported to $filename"
```

That was easy, 6 lines of "code" and you have a CSV file with all the users in your organization.

## Is this a problem?

Not exactly, but it might be a problem if you have a lot of users. Such a csv file with hundreds/thousands users might be considered a data leak.
Still no problem, because powershell is only for administrative accounts, right? **RIGHT??** Wrong... By default **EVERY** user in your Azure AD is able to do this read action with powershell.

## Restrict access to AzureAD powershell

Let's see if we can find a way to prevent access for most users. As says this command `Connect-AzureAD` triggers a login screen, since I know which user logged-in to this powershell module at what exact time, I could directly find an entry in the Sign-in logs for this user, pointing me in the right direction.

![Azure AD Powershell - Sign-in log](/assets/images/2022/05/powershell-azure-ad-signin.png)

I found a login for application **Azure Active Directory PowerShell** with ID: `1b730954-1685-4b74-9bfd-dac224a7b894`.
This application did request access to **Windows Azure Active Directory** with ID: `00000002-0000-0000-c000-000000000000` which shows the AzureAD powershell module isn't using the GRAPH API just yet, but that might be a next post.

At first I opened **Enterprise Applications**, switched to Microsoft Applications and looked for `Azure Active`. The idea was, if I find the Azure Active Directory Powershell application there, I'll just turn on **User assignment required** and only allow the few users I want.

![Azure AD Powershell - Not found](/assets/images/2022/05/powershell-azure-ad-application.png)

No luck there. It shows the resource application though, but I don't want to mess with the Azure AD internals.

### Adding the service principal (to block access)

For the application to appear in the list of **Enterprise applications** it needs to have a service principal in your tenant. You can see this service principal as a tenant specific configuration for some application. If you have the correct Azure AD access, you can create such a service principal by executing the following script.

```powershell
# $adSession = Connect-AzureAD
$appId = "1b730954-1685-4b74-9bfd-dac224a7b894" # Azure Active Directory Powershell
# Get or create service principal
$sp = Get-AzureADServicePrincipal -Filter "appId eq '$appId'"
if (-not $sp) {
    $sp = New-AzureADServicePrincipal -AppId $appId
}
```

### No luck on the portal

The script above enabled the **Azure Active Directory PowerShell** entry in the **Enterprise Applications** as expected, but it doesn't allow me set **User assignment required** since that option is hidden for first party (Microsoft) applications.

## Block AzureAD module with powershell

By design not all options are shown on the Azure AD portal, and messing with options that are hidden by design might lead to unrecoverable results.
Check the script below, careful, before executing (as with any script from a remote source).

This script uses powershell to change the service principal of the AzureAD application that is used to get tokens.

```powershell
$adSession = Connect-AzureAD

$appId = "1b730954-1685-4b74-9bfd-dac224a7b894" # Azure Active Directory Powershell

# Get or create service principal
$sp = Get-AzureADServicePrincipal -Filter "appId eq '$appId'"
if (-not $sp) {
  $sp = New-AzureADServicePrincipal -AppId $appId
}

# Get information about the current user
$me = Get-AzureADUser -ObjectId $session.Account.Id

# Assign the application to the current user, VERY IMPORTANT!
# since the change below cannot be undone on the Azure Portal
New-AzureADServiceAppRoleAssignment -ObjectId $sp.ObjectId -ResourceId $sp.ObjectId -Id ([Guid]::Empty.ToString()) -PrincipalId $me.ObjectId

# Switch 'User assignment required' to On
Set-AzureADServicePrincipal -ObjectId $sp.ObjectId -AppRoleAssignmentRequired $true
```

or you can assign the app to all Global Admins

```powershell
$adSession = Connect-AzureAD

$appId = "1b730954-1685-4b74-9bfd-dac224a7b894" # Azure Active Directory Powershell

$sp = Get-AzureADServicePrincipal -Filter "appId eq '$appId'"
if (-not $sp) {
  $sp = New-AzureADServicePrincipal -AppId $appId
}

$role = get-azureaddirectoryrole -Filter "DisplayName eq 'Global Administrator'"
$admins = Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId
foreach ($admin in $admins) {
  New-AzureADServiceAppRoleAssignment -ObjectId $sp.ObjectId -ResourceId $sp.ObjectId -Id ([Guid]::Empty.ToString()) -PrincipalId $admin.ObjectId
}

Set-AzureADServicePrincipal -ObjectId $sp.ObjectId -AppRoleAssignmentRequired $true
```

## Unblock access to AzureAD module

It's very important to assign the powershell module application to at least one user, since you're going to need powershell to revert the change above.

```powershell
$adSession = Connect-AzureAD

$appId = "1b730954-1685-4b74-9bfd-dac224a7b894" # Azure Active Directory Powershell

# Get or create service principal
$sp = Get-AzureADServicePrincipal -Filter "appId eq '$appId'"
if (-not $sp) {
  $sp = New-AzureADServicePrincipal -AppId $appId
}

# Switch 'User assignment required' to Off
Set-AzureADServicePrincipal -ObjectId $sp.ObjectId -AppRoleAssignmentRequired $false
```
