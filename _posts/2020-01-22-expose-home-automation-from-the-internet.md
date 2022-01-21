---
id: 301
title: Expose home automation from the internet
date: 2020-01-22T19:28:09+01:00


guid: http://svrooij.nl/?p=301
old_permalink: /2020/01/expose-home-automation-from-the-internet/
spay_email:
  - ""
twitter_image: /assets/images/2020/01/holding_tablet.jpg
categories:
  - Coding
  - Security
tags:
  - coding
  - home automation
---
I've got a lot of home automation devices in my house, most of them are controllable while I'm on my local (wifi) network. The web interfaces are in various security levels, ranging from no security to password security.

<!--more-->

## No direct port forwarding

I don't feel comfortable to setup port forwarding for all those devices, with the risk of have a security breach because some closed source vendor make some bad decisions in their device design/software. So I started to other ways to secure my home automation devices while still having access to them from everywhere.

## Requirements

* Real HTTPS certificates
* Every web interface his own subdomain (like something.domain.com and device2.domain.com)
* A (or higher) score on <a rel="noreferrer noopener" href="https://www.ssllabs.com/ssltest" target="_blank">SSL Labs</a>
* Work in my local network and from the internet
* Logging every request (including the path and the remote ip)
* Secure and verifiable login
* Browser access (allow login forms)
* Application access (able to login with OAuth2 or something like that)

## Nginx to the rescue

Nginx is a versatile webserver, it's great for setting up a secure website with an A+ score on SSL Labs. It also has the option to host multiple hostnames on a single IP. And last but not least, it has the option to act as a <a rel="noreferrer noopener" aria-label="reverse proxy (opens in a new tab)" href="https://en.wikipedia.org/wiki/Reverse_proxy" target="_blank">reverse proxy</a>. Nginx looks like a perfect candidate for my new project, it can check the first 5 requirements out-of-the-box!  
I got myself a wildcard certificate from Let's Encrypt and setup nginx to host multiple subdomains under my main domain. All exposing a different web interfaces through the same nginx server.  
Result: I can reach all my devices by their name (subdomain), from home and from the internet, everything is HTTPS (which can be managed on a single rasberry pi) and all requests are logged.

## How about login?

![login](/assets/images/2020/01/locked-door.jpg)

I can now securely access the devices, but how do I make sure others can't? Nginx is also has an <a rel="noreferrer noopener" aria-label="auth_request (opens in a new tab)" href="http://nginx.org/en/docs/http/ngx_http_auth_request_module.html" target="_blank">auth_request</a> module, in a nutshell it allows to transfer the `can I let this request through` responsibility to some other application. This two step process makes nginx act as a doormen with the help of a security guard. For every http request nginx will ask the security guard `can I let this request through`, and if the security guard says `Yeah, sure` (by responding with a HTTP status code 200), nginx will allow the request to pass through.  
This looks to suit my needs, and as it happens to be someone created a great security guard for nginx. It's called <a rel="noreferrer noopener" aria-label="vouch-proxy (opens in a new tab)" href="https://github.com/vouch/vouch-proxy" target="_blank">vouch-proxy</a>. Vouch Proxy, once setup, allows me to force every user to login with some openid connect provider. For home I created an account with <a rel="noreferrer noopener" aria-label="Auth0 (opens in a new tab)" href="https://auth0.com/" target="_blank">Auth0</a>, the free plan is more then enough to host a few users and a single login application.  
Every request that comes in to nginx is now checked by vouch-proxy and if the user isn't logged-in they are redirected to the Auth0 loginscreen.

1. Requests arrives at nginx
2. Nginx asks vouch proxy, `can I let this through?`
    1. No, redirect to user to the login screen so they can authenticate
    2. Yes, the user did login correctly!
3. At this point the user is logged-in (else they start again at 1)
4. Nginx `forwards` the request the to home automation device.

## Conclusion

I'm quite happy with the current configuration, you'll need to login for every device that you want to expose to the internet. HTTPS is configured on one server (raspberry pi). If you're logged-in to one website you won't notice the login screen.  
I can recommend this solution for every user that wants more security, but be aware of the steep learning curve.  
Only my last requirement OAuth access for apps isn't solved. And while configuring this solution I thought up an extra requirement. I want the `back-end` application to disable their own propitiatory login or use the login from the vouch proxy. This is a challenges to fix in every backend application.