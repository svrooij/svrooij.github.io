---
title: "Adding device support to zigbee2mqtt"
published: true
tags:
  - zigbee2mqtt
  - Device support
  - Home automation
image: /assets/images/mqtt-extra-device.png
---

I've been using [zigbee2mqtt](https://zigbee2mqtt.io) for years (for the people that don't know zigbee2mqtt, it's a great way to get rid of proprietary Zigbee hubs). At the moment I have 38 zigbee devices connected.

## Calex Smart wall switch

I bought a Zigbee device that wasn't supported until I bought the [Calex Smart wall switch](https://www.kabelshop.nl/Calex-Wandschakelaar-ZigBee-Calex-Kleur-Dimmen-2-4-GHz-421782-i11400-t27571.html). That is because I always checked the [supported device list](https://www.zigbee2mqtt.io/information/supported_devices.html) before buying a new device.

I wanted to have a switch that I could mount to the wall that would allow me to control the colors of the lights in the house. So I bought these anyway, and saw it as an quest to get them working.

There even is a [special page](https://www.zigbee2mqtt.io/how_tos/how_to_support_new_devices.html) that explains how to add extra devices. I first tried to pair it without changing anything, and off-course I get a message that an unsupported devices wanted to join the network.

### Building support for the extra device

Adding support for a new device is just a matter of editting the [devices.js](https://github.com/Koenkk/zigbee-herdsman-converters/blob/master/devices.js) file with the right values. For me I just looked at the supported devices list to see if there was a device that might had some what the same functionality and found the [Iluminize 511.344](https://www.zigbee2mqtt.io/devices/511.344.html). They both have a color wheel, on/off and brightness control. The Iluminize also has 4 buttons but they are missing on my switch.

### Code to support this new device

After looking at the [configuration](https://github.com/Koenkk/zigbee-herdsman-converters/blob/aab1a4a993e4a87e554bfee105441ea05fbc28b2/devices.js#L10975-L10989) for the Iluminize 511.344 I figured out that I should first try to get it connected and then add extra options until I'm happy with it.

This is the beta code to support the **Calex Swart Wall Switch**:

```js
// Calex Wall switch
{
  zigbeeModel: ['Smart Wall Switch '], // Yes, it has a space at the end :(
  model: '421782',
  vendor: 'Calex',
  description: 'Smart Wall Switch',
  supports: 'On/Off, Brightness, Hue/Saturation',
  toZigbee: [],
  fromZigbee: [fz.command_off, fz.command_on, fz.command_step, fz.command_move_to_color_temp,
    fz.command_move, fz.command_stop, fz.command_ehanced_move_to_hue_and_saturation,
    //fz.command_color_loop_set, fz.command_move_hue, fz.command_move_to_color
  ],
  exposes: [e.action([
    'on', 'off', 'color_temperature_move', 'brightness_step_up', 'brightness_step_down',
    'brightness_move_up', 'brightness_move_down', 'brightness_stop', 
    'enhanced_move_to_hue_and_saturation',
    //'color_loop_set', 'color_move', 'hue_move', 'recall_*', 
  ])],
  meta: { configureKey: 1, disableActionGroup: true },
},
```

## Add support to zigbee2mqtt without changing code

Ok, now I have the correct device information, but how do I run this on my **production** smarthome controller (which is a simple raspberry pi)?

All the way down in the [configuration](https://www.zigbee2mqtt.io/information/configuration.html) it says that you can set **external converters**. That looks interesting since it says that you can add **extra** converters. It can be a NPM package or a file in the `data` directory. Let's try the latter.

You can just use stuff from `zigbee-herdsman-converters` to make your life easier. This file is called `wall-switch.js` and is in the regular `data` folder.

```js
// Import the regular converter package
const zigbeeHerdsmanConverters = require('zigbee-herdsman-converters');
// Set fz (also done in the original device list)
const fz = zigbeeHerdsmanConverters.fromZigbeeConverters;
// Set e (also done in the original device list)
const e = zigbeeHerdsmanConverters.exposes.presets;

// Add one or more devices to this array
const devices = [
      // Calex Wall switch
      {
        zigbeeModel: ['Smart Wall Switch '],
        model: '421782',
        vendor: 'Calex',
        description: 'Smart Wall Switch',
        supports: 'On/Off, Brightness, Hue/Saturation',
        toZigbee: [],
        fromZigbee: [fz.command_off, fz.command_on, fz.command_step, fz.command_move_to_color_temp,
          fz.command_move, fz.command_stop, fz.command_ehanced_move_to_hue_and_saturation,
        ],
        exposes: [e.action([
          'on', 'off', 'color_temperature_move', 'brightness_step_up', 'brightness_step_down',
          'brightness_move_up', 'brightness_move_down', 'brightness_stop', 
          'enhanced_move_to_hue_and_saturation',
        ])],
        meta: { configureKey: 1, disableActionGroup: true },
      },
];
// VERY IMPORTANT, export the array as default export.
module.exports = devices;
```

configuration.yml:

```yml
...
external_converters:
  - wall-switch.js
```

Just reboot and you're ready to go!

## Developer notes

Things to keep in mind.

### External converters as NPM package

I haven't explored the **npm-package** way to add extra converters, but I can imagine that distributing support for new devices might be easy to package separatly and have the user just add an extra npm package to their zigbee2mqtt installation. That way you can already enjoy support for new device while still staying on the `latest` version instead of the `development` branch.

I will spend some time figuring out the following:

- Does it auto install the package if not yet installed?
- Is it possible to override device support?
- What happens if you add a package to support some devices, and the devices get added to the official package?

### Extra zigbee coordinator

After changing something in the device list, you need to restart zigbee2mqtt. During the current pandamic I don't want to do that because then for a brief amount of time switches in our house stop working. And that isn't good for the S.A.F. (spouce acceptance factor).

I got my old CC2531 (which I replaced with the awesome [ZZH-stick](https://www.tindie.com/products/electrolama/zzh-cc2652r-multiprotocol-rf-stick/)) and fired up a second instance of Zigbee2mqtt so I can easily shut it down whenever I feel like it.
