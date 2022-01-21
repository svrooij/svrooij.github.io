---
id: 48
title: Resolve exchange alias to SMTP address
date: 2015-04-04T13:16:52+01:00
guid: http://svrooij.nl/?p=48
old_permalink: /2015/04/resolve-exchange-alias-to-smtp-address/
twitter_image: /assets/images/2015/04/source_code1.png
categories:
  - Coding
tags:
  - Exchange
---
When working with Exchange, you'll sometimes need the primary address and not some kind of alias. This snippet helps you with that.  
<!--more-->

You'll off course need the <a href="https://www.nuget.org/packages/Microsoft.Exchange.WebServices/" title="Nuget - EWS API" target="_blank">Microsoft Exchange Webservice dll</a>, but that is just a simple package on nuget.

```csharp
var service = new ExchangeService(ExchangeVersion.Exchange2007_SP1);
service.Url = new Uri("https://serv/EWS/exchange.asmx");
service.Credentials = new NetworkCredential("001234", "PasswordForUser001234", "Domain");

//Never use this part in production!!
//ServicePointManager.ServerCertificateValidationCallback = (object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) =>
//    {
//        return true;
//    };

var resolvedNames = service.ResolveName("001234");
foreach (var resolvedName in resolvedNames)
{
    Console.WriteLine(resolvedName.Mailbox.Address);
}

//FOUND on: http://stackoverflow.com/questions/6081243/get-logged-on-users-smtp-address-via-ews
```