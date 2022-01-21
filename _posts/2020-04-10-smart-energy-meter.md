---
id: 326
title: Smart energy meter
date: 2020-04-10T11:33:12+01:00


guid: http://svrooij.nl/?p=326
old_permalink: /2020/04/smart-energy-meter/
spay_email:
  - ""
twitter_image: /assets/images/2020/04/smartmeter_dashboard.png
categories:
  - Home automation
tags:
  - home automation
  - P1
  - slimme meter
  - smartmeter
---
A lot of people in the Netherlands have a smartenergy meter. They send the total usage to the power network provider on a regular interval. But is also has a port that can be used to monitor the usage yourself, and this can be really interesting.

<!--more-->

## Hardware needed

* A P1 cable to read the data, I'm using [this one](https://www.sossolutions.nl/slimme-meter-kabel?referal=svrooij).
* A Raspberry Pi (or similar) device
* SD card with some OS for your pi

## Software

You can use whatever software you want to read the data from the meter. The cable above just creates a serial device (over USB). So you should be able to read in from the console.  
I'm however using [Smartmeter2mqtt](https://github.com/svrooij/smartmeter2mqtt) (build myself). It gives you a nice dashboard for checking the actual status and provides a lot of other outputs, like a tcp socket (with parsed or unparsed data), a json endpoint on the webserver and allows you to http post the data to some other system for futher save keeping. It also has a mqtt output that will post the data to your MQTT server.

## Dashboard

![plaatje](/assets/images/2020/04/smartmeter_dashboard.png)

The dashboard used websockets to automatically update the data the moment it arrives. The image will change depending on if you're send electricity to the grid or using electricity from the grid.  
The switch will change depending on the current tarrif. Switched automatically by the grid provider.

## Notifications

Currently I'm just using the dashboard to check the current usage. This allows me to see wether the fryer has finished heating up. I'm planning to make notifications based on changes in current usages. For instance if I turn on the fryer, the usage goes up with 1786 Watt, it is done heating if it goes down by that amount.  
Anyone got any ideas on what you could build with that knowlage?  
I was thinking about notifications when the washmachine is finished washing, or something like that.  
Or maybe notify us we left some device on when we are leaving the house (like curling-iron, fryer or something like that).

## Solar panels, turn on devices

I'm even planning on turning on devices if we produce a lot of energy. In the screenshot you can see we are currently delivering 1081 watt to the grid. So we could also instruct the washing machine to start laundry right now, but that would require a connect washing machine. So future plans.
