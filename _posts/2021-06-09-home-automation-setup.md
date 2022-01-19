---
title: "Home automation setup"
published: true
categories:
  - Home Automation
tags:
  - Home automation
  - mqtt
image: /assets/images/header-home-automation.png
---

I'm big fan of smart homes, almost everything in our home is controlable over the network. And I've build [some awesome apps](#my-smarthome-apps) for it. This post will describe all the components used in my home, and how they connect to each other.

<!--more-->

## Components

My current setup, which runs on a raspberry pi consists of the following components:

- Mqtt server as a central message bus for realtime events, [emqx](#emqx) currently.
- Several [apps](#x2mqtt) which connect a specific device to mqtt.
- Nginx to securely allow access to the webinterface of several apps.
- Rules, Rules and more Rules. All the rules are managed in [node-red](#node-red)

### Components overview

<div class="mermaid">
flowchart LR;
    sonos([Sonos speakers])<--SOAP and HTTP notifications-->Sonos2mqtt;
    Sonos2mqtt<-->mqtt;
    sm([Smartmeter])--P1 serial-->Smartmeter2mqtt;
    solar([SolarEdge invertor])--MODBUS TCP-->Smartmeter2mqtt;
    Smartmeter2mqtt-->mqtt;
    zbl([Zigbee lights])<--Zigbee to usb-->z2m;
    z2m[Zigbee2mqtt]<-->mqtt;
    mqtt((MQTT server));
    mqtt--mqtt-->nr{Node-red flows};
    nr--mqtt-->mqtt;
    web>Nginx webserver]--Incoming webhooks-->nr;
</div>

### Node-red

[Node-RED](https://nodered.org/) is truly amazing. If you haven't used it, go watch a [getting started with node red](https://www.youtube.com/watch?v=ksGeUD26Mw0). Node-red allows you to edit "flows" in the browser.

Each flow has a **trigger**, which in my case most of the time is a mqtt message at a specific topic with the `mqtt in` block. After the trigger, you can connect one or more functions or outputs. I usually just use the `functions` block, but there are several basic functions available like the `switch`, `delay` and `trigger` blocks. And after each block with an output, you can connect one or more outputs or other functions. My most used output is the `mqtt out`.

Node-red allows me to quickly change what happens if you where to press one of the buttons around the house. We have several smartlight switches around the house. And the one in the livingroom also turns of the music.

These two flows are a small sample of what you can accomplish with node-red, manage my sonos playbar.

![Node red sonos flows](/assets/images/2021/06/node-red-sonos.png)

My sonos playbar mounted at the tv is configured to "leave" the group if the tv is switched on. This is great until you want it to play music in the entire room. You would then need to open the app and re-add the tv to the correct group.

This first flow listens for the **state changes** from the speaker in the kitchen. The function then checks if the playback status changed to **playing**. If so, it sends a [join group](https://svrooij.io/sonos2mqtt/control/commands.html) command to the mqtt server.

The second flow listens for **coordinator changes** from the playbar. And if it "leaves" the regular group (as in the TV is turned on), the music in the kitchen is automatically paused.

### x2mqtt

To be able to control all the devices over a single communication protocol (mqtt in my case), they all have to speak the same protocol. Not many existing smarthome devices implement mqtt from the start, that is where these x2mqtt apps come from. I've build a [few](#my-smarthome-apps) and [here](https://github.com/mqtt-smarthome/mqtt-smarthome/blob/master/Software.md) is a list of even more.

### EMQX

While [EMQX](https://www.emqx.io/products/broker) is in the middle of all of this. It's the least interesting part. What it does it allow all apps to communicate on the [mqtt](https://mqtt.org/) protocol. All my devices send messages to the mqtt server, where you can hoopup actions to (in node-red). And some devices can also be controlled by sending specific messages to it.

## My smarthome apps

In the past few years I've build a lot off really small apps, that mostly run in docker and are responsible to connect a certain device to mqtt. Check out all my projects over at [github](https://github.com/svrooij).

- [Sonos2mqtt](https://svrooij.io/sonos2mqtt) Control and monitor your Sonos speakers on your mqtt server.
- [Smartmeter2mqtt](https://svrooij.io/smartmeter2mqtt) Monitor your smart energy meter on your mqtt server.
- [IPcam2mqtt](https://github.com/svrooij/ipcam2mqtt) A small ftp server, where your ip camera should upload the image if it detects movement or sound. These uploads are then converted to you've guessed it a message to your mqtt server.

## Whats missing

A lot of stuff works really well, I'm however still looking for some way to visualize all of these devices and their data. We are moving to a new house soon, and at that point I will be creating a 3D model of the house, where all the virtual devices can be used to control the actual devices and display the current state of the actual device.

So a virtual lightbulb will be on, if the actual light is on as well. And if you press it, you can turn it off or switch color.

<script src="{{ "/assets/mermaid-8.9.2/mermaid.min.js" | relative_url }}"></script>