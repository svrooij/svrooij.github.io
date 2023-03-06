---
title: "Betatalks, I was their guest"
published: true
categories:
  - Podcast
tags:
  - Security
  - Home Automation
twitter_image: /assets/images/2023/03/betatalks-episode-52.png
---

I was asked to be a guest in [Betatalks the Podcast](https://podcast.betatalks.nl/1622272/12352945-52-home-automation-and-security-done-right-and-wrong-with-stephan-van-rooij), and I like sharing knowledge on security and home automation, so I taught why not.

[![Betatalks podcast banner](/assets/images/2023/03/betatalks-episode-52.png)](https://podcast.betatalks.nl/1622272/12352945-52-home-automation-and-security-done-right-and-wrong-with-stephan-van-rooij)

Beware, spoilers ahead. First listen to the episode then read this post.

<!--more-->

## Betatalks the Podcast

[Betatalks](https://podcast.betatalks.nl/) is a nice podcast where they talk all thinks Azure, .NET and open-source. Oscar and Rick, the hosts, are both very highly skilled in their field of work. I already subscribed to the podcast (because of their excellent marketing at various conferences), and here are some of my favorite episodes:

- [Using Azure Container Apps, KEDA, Infrastructure as Code and ARM - with Eduard Keilholz](https://podcast.betatalks.nl/1622272/12068895-49-using-azure-container-apps-keda-infrastructure-as-code-and-arm-with-eduard-keilholz)
- [End-to-End Testing with Playwright and the use of codegen - with Debbie O'Brien](https://podcast.betatalks.nl/1622272/11830271-45-end-to-end-testing-with-playwright-and-the-use-of-codegen-with-debbie-o-brien)
- [Serverless and Azure Functions, SaaS product Ably & creating Pixel art and retro games - with Marc Duiker](https://podcast.betatalks.nl/1622272/11662387-43-serverless-and-azure-functions-saas-product-ably-creating-pixel-art-and-retro-games-with-marc-duiker)
- [Open source framework MVVM Light, Azure Static Web Apps & timekeeper.cloud - with Laurent Bugnion](https://podcast.betatalks.nl/1622272/11241667-38-open-source-framework-mvvm-light-azure-static-web-apps-timekeeper-cloud-with-laurent-bugnion)

## Episode topics

They asked me to join their podcast as a guest some time ago, I was busy moving so I moved it forward. Back to february 2023 (right before carnaval), I just had found something about my oven that got kind of viral. This was a great moment to join Oscar and Rick in their podcast.

Be careful, the following includes spoilers. Listen to the [episode](https://podcast.betatalks.nl/1622272/12352945-52-home-automation-and-security-done-right-and-wrong-with-stephan-van-rooij)

- [Roasting our oven](https://svrooij.io/2023/01/25/disconnect-your-smart-appliance/)
- [Home assistant](https://home-assistant.io) Using home assistant to get started with an awesome, local controlled smart home.
- [Smart doorbell by Marcel Zuidwijk](https://www.zuidwijk.com/product/esphome-based-doorbell-v2/) Using this device to have instant door bell notifications, without waiting 40 seconds like Rick.
- [Local control for home automation](#local-control)
- [How I got awarded MVP](https://svrooij.io/2023/01/02/this-was-2022/#microsoft-security-mvp)
- [First tech challenge Netherlands](http://ftcnetherlands.eu/), worldwide initiative to promote technology for kids [First tech challenge](https://www.firstinspires.org/robotics/ftc).

### Local control

I cannot stress enough how important it is for users of home automation appliances/devices that the manufacturer builds their devices with local control first. This means that their app will continue to work when their service will go down somewhere in the future.

There are many reasons why a cloud service goes down, here is a list of the most probable reasons:

- Company goes bankrupt
- Company no longer wants to support this specific device
- Cloud service gets hacked

I'm not saying these manufacturers should not use cloud services, I'm just saying make sure the app works super fast while on the same local network, preferably with a well documented api, before building some additional cloud service. Connecting back to the device while the user is not at home can be challenging for not technical users, this is great reason to use some cloud service.

In the case of a doorbell or a light switch, no one wants to wait 40 seconds for the notification on their phone that their is someone at the door, like Rick. Or if you press a light switch, you don't want to wait a long time before the light turns on.

## Other tech/security podcasts

Betatalks is not the only podcast I'm subscribed to, here is a glance of my dog walking podcast list.

[Darknet diaries](https://darknetdiaries.com/) **EN** is a must listen to for all those interested in security. It talks about carding, crypto heists, (physical) pentesting and other "darksides of the internet".

[Security brothers](https://anchor.fm/securitybrothers) **NL** Podcast on Insider threat and Authentication (Fido2)

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
[badge_twitter]: https://img.shields.io/twitter/follow/svrooij?logo=twitter&style=for-the-badge&logoColor=white
[link_blog]: https://svrooij.io/
[link_linkedin]: https://www.linkedin.com/in/stephanvanrooij
[link_mastodon]: https://dotnet.social/@svrooij
[link_mvp-profile]: https://mvp.microsoft.com/en-us/PublicProfile/5004985
[link_twitter]: https://twitter.com/svrooij
