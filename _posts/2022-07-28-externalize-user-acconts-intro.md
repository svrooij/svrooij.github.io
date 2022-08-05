---
title: "Externalize user accounts: An introduction"
published: true
categories:
  - Identity
tags:
  - OpenID Connect
  - Security
  - Microservice
  - "Series: Externalize Users"
twitter_image: /assets/images/2022/07/externalize-applications.png
---

Externalizing user accounts, what is he thinking? In this post I'll explain why every company should consider externalizing their user account management from their applications.

<!--more-->

{% include block-series.html tag="Series: Externalize Users" %}

## User management inside an application (common scenario)

You have this great idea for an application and the first thing you need is a way for users to login. Great lets build our own new user system. We need a table in the database, we need a login screen and all the other stuff related to user accounts. Before you know it, you have unsecure or (weakly secured) passwords in your database.

In the next iteration you figured that you also need some sort of page where users can change their details, or maybe change their passwords.

Any company in the business of build cloud applications probably has build at least one off such user management part in their application. This is time spend on building common functionality that is roughly the same every time you build a new application.

<div class="mermaid">
sequenceDiagram;
participant u as User
    participant app as Application
    participant db as Database
    u->>app:I want to login, here are my credentials
    app->>db: Do we know a user with this name and password?
    db->>app:Yes, this is user with ID x
    app->>u: You're validated
    note right of u: Cookie user id x valid for 24 hour
    u->>app:Authenticated as user with id x
</div>

### Second app, same user-base

Your first app is running for some time, and then the sales department decides they need an extra app, that users from the first app also need access to, with the same account. At this point you're faced with a problem, how do you allow users from the first app to use their existing credentials.

No problem, we just build a new login screen that connects to the existing app database from the second app. Great you just made your second app dependent of the first app. What about a mobile app that should use those credentials to connect to some api?

Does your second application need it's own profile edit screen? Are you going to redirect to the first application?

You're going to end-up with two applications that depend on the same database, which makes deployment or upgrades a nightmare.

<div class="mermaid">
sequenceDiagram
participant u as User
    participant app2 as Second app
    participant db as Database first app
    participant app as First app
    u->>app2:I want to login, here are my credentials
    app2->>db: Do we know a user with this name and password?
    db->>app2:Yes, this is user with ID x
    app2->>u: You're validated
    note right of u: Cookie user id x valid for 24 hour
    u->>app2:Authenticated as user with id x
</div>

### Second application, using api to validate users

So what about you **build** an api in the first app and just call that from every other application to validate your users?

The deployment will become a lot easier but the applications still depend upon each other.

<div class="mermaid">
sequenceDiagram
    participant u as User
    participant app2 as Second app
    participant app as First app API
    participant db as Database first app
    u->>app2:I want to login, here are my credentials
    app2->>app:Validate these credentials
    app->>db:Do we know a user with this name and password?
    db->>app:Yes, this is user with ID x
    app->>app2:We know a user with these credentials the user id is x
    app2->>u:You re validated
    note right of u: Cookie user id x valid for 24 hour
    u->>app2:Authenticated as user with id x
</div>

## Development effort

Building a user management system for each and every application you build is a tedious task. I hope to never have to do that again, but that is just my personal opinion. These development efforts are better spend in developing awesome features, and with this post I hope I can convince at least some developers that externalizing users accounts is the way forward.

## Externalizing your user accounts

What I'm suggesting is moving the user accounts to a dedicated user account service. In the next post I'll describe some of the options but for now lets just see it like this. There is one app with an api just for validating and managing users and their profiles.

This following diagram has a lot in common with the previous diagram, but the applications no longer depend on each other, they only depend on the User API.

<div class="mermaid">
sequenceDiagram
    participant u as User
    participant app as Application x
    participant uapi as User API
    participant db as User API DB
    u->>app:I want to login, here are my credentials
    app->>uapi: Validate these credentials
    uapi->>db: Do we know a user with this name and password?
    db->>uapi:Yes, this is user with ID x
    uapi->>app: We know a user with these credentials the user id is x
    app->>u: You're validated
    note right of u: Cookie user id x valid for 24 hour
    u->>app:Authenticated as user with id x
</div>

## Delegating login to other application

In these examples you still need to build a login screen and connect it the (custom build) user api. Every user should still have a username and a password stored somewhere in the user api database. Now comes the security officer stating that every user should be able to use some sort of two-factor authentication. Are you going to modify every login screen in every application to accommodate those 6-digit codes that change every 30 seconds? Are you going to build sms verification into every login screen (please stop using sms as a second factor!)?

What if there was a way to move the responsibility of the actual user validation to the "User API". The "User API" becomes a login server, a separate application with it's sole responsibility of validating users and sending the result to the application in a secure way.

<div class="mermaid">
sequenceDiagram
    participant u as User
    participant app as Application X
    participant login as Login server
    u->>app:Can I use your application?
    app->>u: You need to be logged-in
    u->>app: How do I login
    app->>u: Go here, and show me the result
    u->>login:I want to login for Application X
    login->>u:What is your username?
    u->>login: Here is my username
    Note over u,login: Exchange more details
    login->>u: Tell Application x to use this code
    Note right of u: Time limited code to prove successful login
    u->>app: I logged in
    app->>login: Is this code valide?
    login->>app: Yes, it belongs to user x
    app->>u: Hi User X, you can use the application
</div>

In a nutshell this is how all the big cloud providers are doing it. If you're opening Outlook in your browser, your browser will send you to `https://login.microsoftonline.com/.../...`. If you're opening gmail, you get redirected to `https://accounts.google.com/signin/v2/....`

They all have several applications that need user accounts, and the actual login happens at a trusted login application.

## Why should we externalize user accounts

Taking your user accounts and (possibly) passwords out your application and into a separate system has a few benefits, apart from making it a lot easier to add additional applications that should use the same user accounts.

- You can put them in another environment with tighter security.
- Monitoring malicious activity on an login server should be easier than on an entire application.
- Maybe you even want to enable api access to your applications.
- Only asking your users to login to once for any application and be logged-in in all other applications

And last but not least, this opens the road to new user verification methods that are then immediately available in all your applications. I'm talking about allowing your users to access your application while only using their Office 365 or Github account. Your login server could delegate the actual login to a third-party login server. And that third-party login server could choose the way they seem fit to validate the user.

## User management

If you think you still need user management in your application, you should just call the api of the login server to create/edit a user. Just as long as they are not in the same application, and you should definitely not be modifying the login server database directly, since then you're back to square one.

## Conclusion

Start exploring your options to move your users outside of your application. This might seem like a challenge, but it's definitely worth it. The longer you wait the more complicated it will become.

<script src="{{ "/assets/mermaid-8.9.2/mermaid.min.js" | relative_url }}"></script>
