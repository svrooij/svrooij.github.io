---
id: 45
title: 'Why most C# apps lack https security'
date: 2015-04-04T13:10:35+01:00


guid: http://svrooij.nl/?p=45
old_permalink: /2015/04/c-sharp-apps-lack-https-security/
twitter_image: /assets/images/2015/04/source_code1.png
categories:
  - Coding
tags:
  - security
---
A lot of apps build in C# (or probably any other language) lack the basic protection against **<a title="Wikipedia Man-in-the-middle attack" href="http://en.wikipedia.org/wiki/Man-in-the-middle_attack" target="_blank">Man-in-the-middle-attacks</a>**. One of the reasons I could find for this is because of the following.  
<!--more-->

If you're searching the web on how to communicate with your development server (probably not hosted with a correct SSL certificate), most sites tell you to include the following code to your project.

```csharp
ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => {
	Console.WriteLine("Certificaat: {0}",certificate.Subject);
	Console.WriteLine("SslPolicy: {0}",sslPolicyErrors);
	return true; //This row is the problem. If you don't know why, I wouldn't use apps from your company!
};
```

While this is perfectly fine during the development phase, you should make sure this part is **NEVER** included in your project that will be deployed somewhere!