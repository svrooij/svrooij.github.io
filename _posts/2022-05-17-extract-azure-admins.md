---
title: "Extract all Azure AD admin accounts"
published: true
categories:
  - Security
tags:
  - Powershell
  - Azure AD
  - Data Extraction
twitter_image: /assets/images/2022/05/extract-azure-ad-admins.png
---

Powershell is pretty powerful for all kind of administrative tasks, especially if you load some extra modules. We use the [AzureAD](https://docs.microsoft.com/en-us/powershell/module/azuread/) module for a lot of tasks that can be (semi-)automated with the use of some script. In [this post](/2022/05/16/extract-all-users-with-powershell/) I described how to extract all users from Azure AD as a regular user, and what you should do about it.

Extracting users isn't the only thing you can do with Azure AD powershell and this page shows how to export all Azure AD global admins (which can be executed by **ANY** user in your tenant unless you [take action](/2022/05/16/extract-all-users-with-powershell/#block-azuread-module-with-powershell) against that.)

<!--more-->

## Install AzureAD module

Installing a module should be a breeze, for completeness, here is the command:

```powershell
Install-Module AzureAD
# or just importing if previously installed
# Import-Module AzureAD
```

## Get all Global Admins

Let's say you want all the available users in your tenant "safely" stored in a CSV file on your local machine.

```powershell
# This will open a Microsoft login screen and save the resulting session
$session = Connect-AzureAD

# Load the correct role (change name for other role)
# or Get-AzureADDirectoryRole for all roles
$role = get-azureaddirectoryrole -Filter "DisplayName eq 'Global Administrator'"
$admins = Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId

# Show admins
$admins | Format-Table
```

That was easy, 4 lines of "code" and you know which user accounts have access to all Azure AD resources in your organization.

### Get all admins single line of code

For faster copy/pasting, here is the same code as a one-liner.

```powershell
$session = Connect-AzureAD; $role = get-azureaddirectoryrole -Filter "DisplayName eq 'Global Administrator'"; Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | Format-Table
```

## Other roles

Finding a global admin account might be really useful. If you're targeting some specific application, members of a different role might also be enough. [Azure AD built-in roles](https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference) describes all the roles that Azure AD has built-in.

The **Application Administrator** is interesting since it can add additional applications which might grant access to other parts of the directory.
