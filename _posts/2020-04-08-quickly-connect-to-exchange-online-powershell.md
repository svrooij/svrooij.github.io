---
id: 322
title: Quickly connect to Exchange online powershell
date: 2020-04-08T09:51:06+01:00


guid: http://svrooij.nl/?p=322
old_permalink: /2020/04/quickly-connect-to-exchange-online-powershell/
spay_email:
  - ""
twitter_image: /assets/images/2020/04/azure_shell_exchange.png
categories:
  - Coding
tags:
  - exchange
  - Office 365
  - powershell
---
 
Microsoft is making it really easy to manage your Exchange Online environment from every device. You'll need an active Azure subscription and be an Exchange Online admin though.  
1. Open the online shell <a rel="noreferrer noopener" aria-label="https://shell.azure.com (opens in a new tab)" href="https://shell.azure.com" target="_blank">https://shell.azure.com</a> and pick powershell.  
2. Typ **Connect-EXOPSSession** and press enter  
3. Wait a little bit for it to connect  
4. Use all the <a rel="noreferrer noopener" aria-label="supported (opens in a new tab)" href="https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/exchange-online-powershell-v2/exchange-online-powershell-v2?view=exchange-ps" target="_blank">supported</a> commands.

<!--more-->

![Cloudshell](/assets/images/2020/04/azure_shell_exchange-1024x458.png)

## `Connect-EXOPSSession`

This magic command, will load to correct modules, and authenticate as the current user. Before you can access the shell you'll be required to do MFA (if that is configured for your organisation). So this is completely secured by Microsoft.