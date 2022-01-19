---
title: "Microsoft Teams Desktop with multiple accounts"
published: true
categories:
  - Lifehack
tags:
  - Microsoft Teams
  - Multi-tenant
image: /assets/images/two-teams.png
---

We use Microsoft Teams a lot for communication, but once you start using it with multiple accounts you continuously have to switch accounts. That means logging out and signin back in with the other account.

<!--more-->

## Using multiple Microsoft Teams instances

Microsoft has build **fast user switching** right into Windows. Normally you use this functionallity to fast switch between multiple users accounts (great feature name). But you can also use this to run an application in a different user context (with a different credential store and app data folder).

### Create second local windows account

It's important to create a second windows account for the local computer. Open **Settings** app and go to **Accounts > Other Users** and click **Add someone else to this PC**.

Follow the wizard, it's important to create a **LOCAL** account, this doesn't work well with a second corperate account.

### Setup teams client

Use fast user switching to switch to your new user. And ga ahead and install Microsoft Teams (it's installed per user, in the AppData folder).

## Run the second Teams Client

Once you have setup your second user, it's time to use this nice Windows Hack.

### Shortcut with other user context

Go ahead and create a new Shortcut on a location you like (eg. desktop),
point it to (replace `your_second_user` (2x) with the used username for your second user):

```txt
C:\Windows\System32\runas.exe /user:localhost\your_second_user
/savecred "C:\Users\your_second_user\AppData\Local\Microsoft\Teams\current\Teams.exe"
```

Give it a good name, and optionally change the Icon (anyone wants to create Teams Icons in 10 colors?)

Clicking the new shortcut, will try to start the application in the context of the new user.
The password is only asked to first time.

### Runas explained

The command above will use the build-in windows functionallity to start an application in the context of a different user.

The command is `C:\Windows\System32\runas.exe /user:[host\]username {options} "{program_to_start}"`

The `/savecred` option means it will ask you for the password of the second user only once.

## Ceveats

The new instance cannot find your first account (or its data) because Windows makes sure of that. Just login to your second team instance with the account you like. Sadly the account in the second teams instance isn't saved (at least in my setup).

This might also work with a thirtd and a fourth account, just try it out. And it isn't limited to just Teams, use your imagination.

I'm not sure if this is actually supported by Microsoft, so if you face issues with this setup, don't start calling the Microsoft support desk.

I heared rumors that the Teams Client will start supporting multiple accounts at the same time, but until then, this is a good solution.

## Other solutions

There are other solutions for this problem, but in my opinion the browser version of Teams just isn't as good as the desktop client.

### Edge profiles

I see others loving the Edge browser in combination with Profiles for separate tenants/accounts.

### Portals app

Some MVP build a [portals](https://github.com/jamescussen/PortalsReleases) application, I have no experience with it and it isn't open-source. So use at your own risk.
