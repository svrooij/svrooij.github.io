---
title: "Open-source sonos apps"
published: true
categories:
  - Open source
tags:
  - Sonos
  - Open source
twitter_image: /assets/images/2022/03/sonos-alarms.png
---

Out of personal interest I've build several apps to have better control your Sonos speakers. This page will give you a brief overview of these apps.

<!--more-->

## Sonos2mqtt

[![Sonos2mqtt][badge_sonos-mqtt]][link_sonos-mqtt]
[![npm][badge_npm-mqtt]][link_npm-mqtt]
[![docker pulls][badge_docker]][link_docker]
[![github sponsors][badge_sponsor]][link_sponsor]

[Sonos2mqtt](https://svrooij.io/sonos2mqtt) is an application that let's you control your sonos speakers from your mqtt server. This application is mostly used by people who were already using mqtt in there home automation system.

Key features:

- Quickly respond to changes to tracks (skip some artist in a "recommended songs"-playlist)
- Group & Un-group players with a simple command
  - Players get removed from the group with your playbar in it (if you want), but they won't re-group after you stopped watching tv. With this app you can.
- Truly lock volume of players (you immediately get volume updates and can instruct the player to turn down the volume).
- [Play notifications](https://svrooij.io/sonos2mqtt/control/notifications.html) and revert to original song afterwards.
- [Play text to speak](https://svrooij.io/sonos2mqtt/control/notifications.html#text-to-speech) announce something in your house.
- All the obvious music controls off-course, like `Play`, `Pause`, `Next`, `Previous` and [a lot](https://svrooij.io/sonos2mqtt/control/commands.html) of other controls.

This is used alot, but because this is a local only app, without tracking inside, I can only see how often it's downloaded. Counting `334k` pulls on docker and `24k` [downloads](https://npm-stat.com/charts.html?package=sonos2mqtt&from=2019-01-01&to=2022-03-06) on NPM in the last 3 years. I can say there seems to be a solid user base.

## Sonos-ts

[![Sonos typescript this library][badge_sonos-typescript]][link_sonos-typescript]
[![npm][badge_npm-ts]][link_npm-ts]
[![github sponsors][badge_sponsor]][link_sponsor]

Control your sonos speaker from any node/typescript application. Some key features of this library are:

- [Basic](https://svrooij.io/node-sonos-ts/sonos-device/methods.html#added-functionality) controls of the speakers
- [Advanced](https://svrooij.io/node-sonos-ts/sonos-device/services/device-properties-service.html) device controls
- Total **local** control, no cloud needed.
- Listening to all [events](https://svrooij.io/node-sonos-ts/sonos-device/events.html) from the sonos speakers.
  - Track changes
  - Group changes
  - Volume
  - **All** other properties that emit events
- [Playing notifications](https://svrooij.io/node-sonos-ts/sonos-device/notifications-and-tts.html#notifications), play a doorbell sound and automatically revert to the original playlist.
- [Text-to-speech](https://svrooij.io/node-sonos-ts/sonos-device/notifications-and-tts.html#text-to-speech) generate an mp3 file for some text and play it as a notification. For instance to announce something or read a custom weather message
- Interact with third party music services, like Spotify.

This library is supporting 95% percent of the original sonos application. I've also build a generator to generate the code interacting with the services, see below.

This library is downloaded `61.5k` times in the last [three year](https://npm-stat.com/charts.html?package=%40svrooij%2Fsonos&from=2019-01-01&to=2022-03-06)

![Sonos alarms](/assets/images/2022/03/sonos-alarms.png)

## Sonos API documentation and generator

I've also [documented](https://svrooij.io/sonos-api-docs/) all the local endpoints of the sonos speakers. Actually the documentation is one of the products of the [documentation generator](https://github.com/svrooij/sonos-api-docs/tree/main/generator/sonos-docs).

The generator is used for the typescript library, but other could us it to generate strong typed classes for their own library.

The manual work laid in crafting [this](https://github.com/svrooij/sonos-api-docs/blob/main/docs/documentation.json) file. Containing all the documentation for a lot of services. **PR's are highly appreciated**.

## Home automation

What does your ultimate home automation system look like? I'm curious to your home automation hacks.

## Open source

[![github sponsors][badge_sponsor]][link_sponsor]

All these applications are open-source, and while I do have a [github sponsor profile][link_sponsor], it doesn't make me a lot of money. So if anybody got suggestions on how to partially monetize these libraries, please send me a message.

It seems to be a rough world for open source maintainers. People think that there issue should always be solved with top priority. Recently I've put a new perk on my Github Sponsor profile for people that want me to quickly look at some issue. I will be referring to that when people harass me to fix an issue quickly.


[badge_docker]: https://img.shields.io/docker/pulls/svrooij/sonos2mqtt?style=for-the-badge
[badge_npm-ts]: https://img.shields.io/npm/v/@svrooij/sonos?style=for-the-badge
[badge_npm-mqtt]: https://img.shields.io/npm/v/sonos2mqtt?style=for-the-badge
[badge_sonos-mqtt]: https://img.shields.io/badge/sonos-mqtt-blue?style=for-the-badge
[badge_sonos-typescript]: https://img.shields.io/badge/sonos-typescript-blue?style=for-the-badge
[badge_sponsor]: https://img.shields.io/github/sponsors/svrooij?label=Github%20Sponsors&style=for-the-badge

[link_docker]: https://hub.docker.com/r/svrooij/sonos2mqtt
[link_npm-mqtt]: https://www.npmjs.com/package/sonos2mqtt
[link_npm-ts]: https://www.npmjs.com/package/@svrooij/sonos
[link_sonos-mqtt]: https://svrooij.io/sonos2mqtt
[link_sonos-typescript]: https://svrooij.io/node-sonos-ts
[link_sponsor]: https://github.com/sponsors/svrooij/
