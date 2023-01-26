---
title: "I disconnected our smart oven, and maybe you should as well"
published: true
categories:
  - Security
tags:
  - Smart Appliance
  - Home Automation
twitter_image: /assets/images/2023/01/ping-aeg.png
---

**Arstechnica** published an [article](https://arstechnica.com/gadgets/2023/01/half-of-smart-appliances-remain-disconnected-from-internet-makers-lament/) yesterday, called **"Appliance makers sad that 50% of customers won’t connect smart appliances"**. Let me tell you, I'm glad people don't connect their oven to the internet. We own two of these smart appliances from AEG and I disconnected them as soon as I discovered what they do.

![Pinging aeg](/assets/images/2023/01/ping-aeg.png)

<!--more-->

## When would I use the smart part of these appliances?

We did not explicitly bought "smart" appliances. We noticed they had wifi after we installed them. Here are some use cases of the "smart" functionality.

- I'm was working late, on the way back in the grocery store, thinking I'll just take some pizza and pre-heat my oven while still in the store.
- While waking up deciding we want fresh baked buns in the morning, and we want to pre-heat the oven.
- Maybe receiving notifications on the phone when the pre-set timer finishes

These three use cases are probably the only reason why people even consider buying a "smart" oven.

## Devices check for internet access

Every smart devices (laptop/phone/appliance) wants to know if the wifi they are connected to is actually providing access to internet. [Microsoft](https://devblogs.microsoft.com/oldnewthing/20221115-00/?p=107399) created a special endpoint that is used by your Windows device to check for internet connectivity. Apple and Google follow a similar strategy, I cannot find the exact documentation on it.

If a company doesn't want to setup an external api for this, or you have an api that is not really stable, you can always use public websites to check if you have an internet connection. In my opinion your should always setup your own api to do the checking, because you don't want to report to the user that the device does not have internet access because some external website is down.

And if you already have an api, just make sure your api is stable!

## How AEG smart appliances check internet connectivity?

AEG choose the easy route, and checks three public websites every 5 minutes when connected to your wifi. The AEG smart appliances also have this hidden cloud api which is used for controlling the devices, so there should not be a reason to connect to these websites:

- `google.com` no shock there, that is the number one website I personally use if I have to check internet connectivity.
- `baidu.cn` yes, every 5 minutes your oven sends a message to the **Chinese** google alternative.
- `yandex.ru` yes, not even just China, also the **Russian** google alternative.

I really don't like the fact that my oven connects to **China and Russia** just to check if it has an internet connection. If that is the only thing it's doing.

The support department isn't very helpful as well, they have no clue what I'm talking about and refuse any help. Probably because there isn't a hardware malfunction.

> **NOTE!**
>
> We only have two smart appliances from AEG, so I'm not sure if they all do this, but at least the two appliances we have (`BSK798280B` and `KMK768080B`) do this. And I haven't done any package inspection I just watched the DNS requests all my IOT devices make.

## Why you should disconnect your AEG smart ovens?

If this internet connectivity check is not enough to disconnect it, here is another reason, the mandatory smartphone app is one big mess. And even if you get it to work they implemented something that renders the app completely useless. Most reasons to want a "smart" oven are spontaneous, as in not planned ahead of time.

Sadly the oven requires us to plan ahead, because for us to be able to pre-heat the oven from our phone, we have to "activate" remote control. And as a "security measure" this is not a one time task like I would expect.

Every time we close the damn thing it asks: **"Do you want to activate remote connectivity?"** If you don't respond, it does nothing, as in it's disabled again. After three of these questions upon closing the oven you start hating that message and don't press it again. Resulting in your "smart" appliance becoming a "smartass" appliance. The app will show the oven as connected, great, but as soon as you try to pre-heat the oven, if says "You did not activate remote connectivity".

The first time I was faced with this message I thought, wait a minute, it's still connected. I did not change the wifi settings. And then I remembered the question of activating remote connectivity.

![Play store review](/assets/images/2023/01/aeg-review-my.png)

I left a review on the Play store that the app is quite useless because of this question all the time. The replied with "it's because of security" so I changed my review to go further on the topic.

Eventually I emailed with someone from the support department and they "explained" that it's all because of security. Some people might lend their phone to their kids and you don't want to allow your kids to turn on the oven when you don't know about it.

1. It is my device, so it should be my choice. If that would make you liable, please just show a one-time warning explaining the possible issue.
2. I don't care about this, we don't have kids. If this is even an issue, just add a pin code protection to the app itself.
3. I'm more worried on the security of the cloud api then on someone getting my phone to turn on the oven.
4. What happens when I (or some malicious actor/kid) turn on the oven for like forever (24h), apart from me wasting a lot of energy? It's not going to set the house on fire because of extended use, right? I expect that the device will shutdown in case of a malfunction or after 12 hours being on?

I'm considered "lucky", most 1-star [play store reviews](https://play.google.com/store/apps/details?id=com.aeg.myaeg.taste) are by people who cannot connect or say it just doesn't work. The app scores a 2.7 on 1000+ reviews.

![Play store review](/assets/images/2023/01/aeg-review-01.png)

![Play store review](/assets/images/2023/01/aeg-review-02.png)

### Microwave with identity crisis

The last reason why you should disconnect your AEG smart appliance is that their "firmware" rollout sometimes go wrong. By default when you connect it to the internet, automatic firmware upgrades are turned on. And in March 2022 they rolled out a new firmware for their **microwave** `KMK968000T`, the updated firmware was for another device (a steam oven). The menu items changed to being a steam oven, and the thing just stopped working. Because of the wrong firmware (probably not matching the hardware) it would no longer connect to the internet and people where left with a faulty device.

The AEG solution, we just send a mechanic to all these people to manually flash the firmware.

- [AEG oven branwash](https://thenextweb.com/news/update-brainwashes-microwaves-thinking-theyre-steam-ovens) The next web
- [AEG combimagnetron denkt stoomoven te zijn](https://tweakers.net/nieuws/193950/aeg-combimagnetron-denkt-stoomoven-te-zijn-en-werkt-niet-meer-na-foute.html) Tweakers (Dutch)

This issue just shows incompetence on the application side of things. It should not be too hard to embed the model number in the firmware and only accept firmware updates for the same model number. Such a big company should even have a physical model standby in some warehouse, where the new version is tested and only released once it's tested on a physical device.

## Smarthome appliances need local control api

You have this smarthome device, which is working great for you. Since you own the device it might be worth checking how controlling the device works. If most features stop working when you disconnect the internet, they are probably relaying on some external service, hosted by the company or a third party.

What happens with the device if the manufacturer decides it's no longer worth it supporting this x year old device. Or if the company goes bust.

I would like more manufacturers to develop their app with optional cloud features, for instance for (unrestricted) remote control. It's way more important to start with local communication between the app and the device. Not having to build the cloud component in the first place is even easier, since you don't have to deal with yet another component in the mix.

For our oven I would settle with a local (rest or websockets) api that:

- Allows monitoring the device, door open/closed, current temperature, set temperature, timer running/time left, and maybe some other stats.
- Allows controlling MY device, pre-heat and picking the program.
- Is documented properly

Having a local api would allow limiting the control to users on the same wifi. Which might not only be more secure, but is probably much faster as well. It would cut the roundtrip over to their servers in some data center. You can use sound alerts emitted from the oven if something goes wrong, because the people using the thing must be on the same wifi. The local api would allow users to use the app even if they don't have internet at that place.

## Conclusion: The roast of AEG

While AEG (or Electrolux) might be a company producing solid hardware appliances their applications are not very good. Their My Kitchen app has (in my opinion) a fake security measure, rendering it completely useless. If you got the app to work in the first place.

Their appliances should not use external websites (in foreign countries) to check for internet connectivity.
And while we are at the topic, if you insist on security why does it even need a cloud? How good is the "security" on that side? Is that validated by a third party or just by the developers who also designed it?

If you ask me, the cloud should be optional that only gets enabled if the user enables remote connectivity. So no data in the cloud until then. If the data is in the cloud it should have a public api, so others can create better apps. Or maybe integrate it with some cool recipe app to pre-heat the oven at the right temperature.

This article is mainly focused on AEG, they are however not the only appliance manufacturer that decided they want to smartify their appliances. If you then decided to just copy the interface of the appliance to an app and then enable remote control, your application might not be very good. If your washing machine has 5 buttons to set some program, please don't make an app with those exact 5 buttons. That is not a very good user experience. Our oven has a slider for setting the temperature, this is somewhat ok on the device itself. That same slider in the app makes no sense.

### Working for AEG/Electrolux?

If you don't agree with these statements or would like advise? Contact me on one of the channels below, I really tried contacting you, but the support department is stonewalling me.

## Connect with me

[![LinkedIn Profile][badge_linkedin]][link_linkedin]
[![Link Mastodon][badge_mastodon]][link_mastodon]
[![Follow on Twitter][badge_twitter]][link_twitter]
[![My MVP profile][badge_mvp]][link_mvp-profile]
[![Check my blog][badge_blog]][link_blog]

[badge_blog]: https://img.shields.io/badge/blog-svrooij.io-blue?style=for-the-badge
[badge_linkedin]: https://img.shields.io/badge/LinkedIn-stephanvanrooij-blue?style=for-the-badge&logo=linkedin
[badge_mastodon]: https://img.shields.io/mastodon/follow/109502876771613420?domain=https%3A%2F%2Fdotnet.social&label=%40svrooij%40dotnet.social&logo=mastodon&logoColor=white&style=for-the-badge
[badge_mvp]: https://img.shields.io/badge/MVP-Security-blue?style=for-the-badge&logo=microsoft
[badge_twitter]: https://img.shields.io/badge/follow-%40svrooij-1DA1F2?logo=twitter&style=for-the-badge&logoColor=white
[link_blog]: https://svrooij.io/
[link_linkedin]: https://www.linkedin.com/in/stephanvanrooij
[link_mastodon]: https://dotnet.social/@svrooij
[link_mvp-profile]: https://mvp.microsoft.com/en-us/PublicProfile/5004985
[link_twitter]: https://twitter.com/svrooij
