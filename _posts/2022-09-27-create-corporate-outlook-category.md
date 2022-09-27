---
title: Replace an owner in all their Teams
categories:
  - Scripting
tags:
  - Outlook
  - Administration
  - PowerShell
  - "Series: MSGraph PowerShell"
twitter_image: /assets/images/2022/09/create-outlook-category.png
---

Did you know you can categorize items in your Outlook calendar to give them a different color (in most official Outlook clients)? You can help your users by pre-configuring some default categories. You can also create categories for your users if you have some automation to create items in their calendar by some automated way.

<!--more-->

## Using Graph PowerShell

These scripts use the new [Graph PowerShell Modules](https://docs.microsoft.com/en-us/powershell/microsoftgraph/get-started?view=graph-powershell-1.0), if you don't have them already, be sure to install them prior to using any of these scripts.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser 
Install-Module Microsoft.Graph.Users -Scope CurrentUser
Install-Module Microsoft.Graph.Groups -Scope CurrentUser
```

## Create category for single user

Use this script to [create some category](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.users/new-mguseroutlookmastercategory?view=graph-powershell-1.0) for a single user. We will use this to test it out, and build from there.

The color is set with a preset between 1 and 20 (I believe), and I cannot find the list at the moment.

```powershell
# Change accordingly
$tenantId = "21009bcd-06df-4cdf-b114-e6a326ef3368";
# you can use either the user ID or the UPN.
$userId = "613f5b2e-4360-4665-956b-ffeaa0f3014b";

# Connect to Graph with correct scopes
Connect-MgGraph -TenantId $tenantId -Scopes "MailboxSettings.ReadWrite"

$category = @{
	DisplayName = "Schedule"
	Color = "preset9"
}

New-MgUserOutlookMasterCategory -UserId $userId -BodyParameter $category;
```

## Create category for all users in a group

This script will create this new category for all users in a certain group, but that might result in duplicates. Use careful.

```powershell
# Change accordingly
$tenantId = "21009bcd-06df-4cdf-b114-e6a326ef3368";
$groupId = "613f5b2e-4360-4665-956b-ffeaa0f3014b";

# Connect to Graph with correct scopes
Connect-MgGraph -TenantId $tenantId -Scopes "MailboxSettings.ReadWrite","GroupMember.Read.All"

$category = @{
	DisplayName = "Schedule"
	Color = "preset9"
}

$members = Get-MgGroupMember -GroupId $groupId;

foreach ($member in $members) {
  New-MgUserOutlookMasterCategory -UserId $member.Id -BodyParameter $category -ErrorAction SilentlyContinue;
}
```

{% include block-series.html tag="Series: MSGraph PowerShell" %}
