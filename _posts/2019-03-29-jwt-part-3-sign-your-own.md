---
id: 240
title: 'JWT: Part 3 &#8211; Sign your own'
date: 2019-03-29T17:26:29+01:00


guid: https://svrooij.nl/?p=240
old_permalink: /2019/03/jwt-part-3-sign-your-own/
categories:
  - Coding
tags:
  - jwt
---
This is part of my JSON Web Token series. This time to show you how to create your own JWTs in dotnet core. Small note, creating your own token server isn't something I would recommend! If you need your own token (identity/login/openid connect) server, have a look at <a rel="noreferrer noopener" aria-label="Identity Server (opens in a new tab)" href="http://docs.identityserver.io/en/latest/index.html" target="_blank">Identity Server</a> and the Identity server with Asp.net Identity <a rel="noreferrer noopener" aria-label="quickstart (opens in a new tab)" href="http://docs.identityserver.io/en/latest/quickstarts/8_aspnet_identity.html" target="_blank">quickstart</a>. 

<!--more-->

It is however handy to know how the creation of JWTs works, just for your understanding.

## Create a JWT

Each JWT consist of some data in the form of claims about the application and/or the user. You can add all the claims about the user you think you might need. Getting these values from some source is something you need to figure out yourself. Think database, userstore, eg.

```csharp
using System.Security.Claims;
// .....

var identity = new ClaimsIdentity(new Claim[] {
                    new Claim(ClaimTypes.Name, "user-id-of-user"),
                    new Claim(ClaimTypes.Email, "user@domain.com")
                });
```

## Signing credentials

To create a JWT you'll need some sort of SigningCredentials, Microsoft defined a few so lets try it out. Check out the [JWT Introduction](https://svrooij.nl/2019/03/jwt-introduction/) for all the ways of signing a token.

```csharp
using Microsoft.IdentityModel.Tokens;
// For using certificate authentication
using System.Security.Cryptography.X509Certificates;
// ....

// We will start with the SymmetricSigningCredentials, so that is a shared key.
// This is nice for proof of concept, but you shouldn't use it in production!
var key = Encoding.ASCII.GetBytes("Very long secret, replace with your own! And never store in the code!");
var symmetricSigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature);

// Next the preferred way, signing credentials from a RSA Certificate.
// First load the certificate from somewhere secure. User certificate store or something.
var certificate = new X509Certificate2(); // Replace this line to load it from somewhere secure!
var x509SigningCredentials = new X509SigningCredentials(certificate);
```

## Creating the actual token

We now have the two required ingredients to create a token. The user identity we want to sign and signing credentials. Lets create a token, you're of course free to choose your own credentials.

```csharp
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
// ...

var identity = new ClaimsIdentity();
var x509SigningCredentials = new X509SigningCredentials(certificate); 

var tokenHandler = new JwtSecurityTokenHandler();
var tokenDescriptor = new SecurityTokenDescriptor
{
    Subject = identity,
    Expires = DateTime.UtcNow.AddSeconds(3600), // 1 hour
    SigningCredentials = x509SigningCredentials
};
var unsignedToken = tokenHandler.CreateToken(tokenDescriptor);
var token = tokenHandler.WriteToken(unsignedToken);
```

## Your first tokens

Congratulations you just created your first JSON Web Token! In real life applications you should first decide which claims you're probably going to need on the side where you will be accepting them. Start with as less as possible to keep your token small. You can always add needed claims as you see fit.
