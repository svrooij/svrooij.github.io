---
id: 238
title: 'JWT: Part 2 &#8211; In the wild'
date: 2019-03-26T10:00:28+01:00


guid: https://svrooij.nl/?p=238
old_permalink: /2019/03/jwt-part-2-in-the-wild/
categories:
  - Security
tags:
  - authentication
  - jwt
---
JSON Web Tokens are used everywhere. Microsoft uses them as access tokens for their entire Authentication platform and their Graph API. Google uses them in their applications both in the Login with Google system and in their apis.

<!--more-->

## Use existing tokens or generate own?

If you start with a new application you should decide if you want to invest in setting up your own token server or use an existing token service. This is an important decision to be made, but both sides have their own advantages.  
  
This choice gets easier if you're sure that everybody that will use your application is using the same identity provider. But remember that it's much easier to start with the right solution for your application because swithing later on will be some what difficult.  


### Microsoft Azure AD

If you're sure everyone that is going to use your application is in some Azure AD tenant, then the choice is easy. Just use the Azure Identity platform for your application. You'll enjoy all the nice features they build, like web api to web api user impersonation.

### Microsoft Azure AD B2C

If you need a little bit more control but you don't want to setup your own token/identity server, you can have a look at <a rel="noreferrer noopener" aria-label="Azure AD B2C (opens in a new tab)" href="https://azure.microsoft.com/en-us/services/active-directory-b2c/" target="_blank">Azure AD B2C</a>, it is a Microsoft hosted identity server that can serve all your applications. You'll pay a certain amount for each active user and each login attempt.

### Auth0

<a rel="noreferrer noopener" aria-label="Auth0 (opens in a new tab)" href="https://auth0.com/" target="_blank">Auth0</a> is a company that specialized in providing a one-stop-shop for all your authentication needs. They can be a great token provider for your next application.

### Roll your own

Instead of using (and paying) a pre-configured identity provider you can always set-up your own token provider. Be sure to not see this as a `cheap` way, because maintaining it will still cost you money (or time).