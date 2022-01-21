---
id: 232
title: 'JWT: Part 1 &#8211; Introduction'
date: 2019-03-25T22:03:28+01:00


guid: https://svrooij.nl/?p=232
old_permalink: /2019/03/jwt-introduction/
categories:
  - Security
tags:
  - api
  - authentication
  - jwt
---
What exactly is a **Json Web Token?** I like to describe them as an easy way to digitally sign some json data about a user, that can then be used as an access token for some kind of api. Check out <a rel="noreferrer noopener" aria-label="JSON Web Token (opens in a new tab)" href="https://en.wikipedia.org/wiki/JSON_Web_Token" target="_blank">JSON Web Token</a> on wikepedia for an exact description.  
  
I really like JWTs because they are verifiable without an additional call to some identity server. They are short-lived by default (at least should be). And it is the best option for access tokens at the moment.

<!--more-->

## Sample token  


This is a sample token (whitespace added for readability), it consists out of three parts, separated by a dot. Each part is base64 encoded.  
The first part is the header, this describes the token type (JWT) and the algorithm (HS256) used for signing.  
The second part (or the payload) holds all the data of the user in key-value pairs. Some keys are required some are optional (but recommended).  
The thirth part is de signature of both the header and body in combination with some kind of secret.

```text
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IlN0ZXBoYW4gdmFuIFJvb2lqIiwiZW1haWwiOiJzdGVwaGFuQHN2cm9vaWoubmwiLCJpc3MiOiJodHRwczovL2p3dC5pbyIsImF1ZCI6Imh0dHBzOi8vc3Zyb29pai5ubCIsImlhdCI6MTUxNjIzOTAyMn0
.
2AKMJtgllysoQkSi5b4jE8VuPpuKZ4cJSi5U0ClM74I
```

```jsonc
// The header
{
  "alg": "HS256", // Shared secret, sha256 hash
  "typ": "JWT" // This is in fact a JWT
}

// The payload
{
  "sub": "1234567890",
  "name": "Stephan van Rooij",
  "email":"fake@svrooij.io",
  "iss":"https://jwt.io",
  "aud":"https://svrooij.nl",
  "iat": 1516239022
}
```

## Claims

Each JSON Web Token consists of some claims (key-value pairs) that describe the user, the application that created the token or the expected audience. For a complete list of pre-registered claims check this <a rel="noreferrer noopener" aria-label="list (opens in a new tab)" href="https://www.iana.org/assignments/jwt/jwt.xhtml" target="_blank">list</a>.  
  
You can add other data to the payload as long as you follow the rules. If the data you're sending is representing data as specified in the registered list please use the same claim. You can also add other claims, make sure they don't collide by adding a prefix or something like that.

| Claim | Name | Description |
|-------|------|-------------|
| aud | Audience | The application this token is for. |
| iss | Issuer | The application that created the token. |
| sub | Subject | An unique identifier for that specific user. It should always be the same for the same user. |
| name | Full name | The fullname of the user. |
| jti | JWT Id | An ID to identify that specific token. (use a guid). Can be used to prevent replay attacks. |
| email | Email | The email address of that specific user |
| preferred_username | Preferred username|The username the user preferres |
| iat | Issued at|The json timestamp when this token was created. |
| exp | Expiration time | The json timestamp until this token is valid.If present it should be checked. |
| nbf | Not before | The json timestamp the states from when this token is valid. Should be checked if present |

## Signature

The JWT <a rel="noreferrer noopener" aria-label="specification (opens in a new tab)" href="https://tools.ietf.org/html/rfc7519" target="_blank">specification</a> describes three different algorithms to use for the signature of the token (and the plain algorithm, which should never be used).  
  
HMAC-SHA256 (alg parameter, `HS256`), this means there is a shared secret that is used to compute the signature with the SHA256 algorithm. The application that wants to verify the signature will need the same secret. This algorithm is very usefull for testing, but it isn't the most secure way, because the application using the token can also issue new tokens because it knows the secret.  
  
**RSASSA-PKCS1-v1_5** (alg parameter, `RS256`), this means the tokens is signed with the private key of a certificate using the SHA256 hashing algorithm. The application that wants to verify the signature will only need the public key of the certificate. And this is for that reason a secure algorithm to use in production. The public key can easily be shared and the applications using the token cannot create new tokens because they don't have the private key of the certificate.  
  
ESDSA (Elliptic Curve Digital Signature Algorithm, alg parameter `ES256`), this means the token is signed with the ESDSA private key using the SHA256 algorithm. It gives you a smaller signature compared to RS256 (and should be faster to compute), but isn't supported by a lot of providers/clients.  
  
No signature (alg parameter, none) means no signature (e.g. no security at all) you should never use this in any way!
