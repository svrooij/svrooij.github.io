---
id: 293
title: Developing a typescript library
date: 2019-12-28T21:56:08+01:00


guid: http://svrooij.nl/?p=293
old_permalink: /2019/12/developing-a-typescript-library/
twitter_image: /assets/images/2019/12/typescript.jpg
categories:
  - Coding
tags:
  - open-source
  - sonos
  - typescript
---
I've been building node libraries for home automation purposes for a while now, see my [repositories](https://github.com/svrooij/). I decided that it was time to try out the strong-type goodness you get when using [Typescript](https://www.typescriptlang.org/).

<!--more-->

[Node-sonos](https://github.com/bencevans/node-sonos) (a library to control your sonos device, from you guessed it, node) was a good candidate. I'm one of the main contributors at this point. In the last two months I spend a lot of hours developing a comparable library in typescript. The result [node-sonos-ts](https://github.com/svrooij/node-sonos-ts) is now at version **1.1.1** so it's a good moment to look back on the bumps in the road.

## Setup project

Setting up the project correctly is important. Before you can run (or debug) your typescript code it has to be compiled to JavaScript by `tsc`. You'll need to do some setup stuff, someone make a great [tutorial](https://michalzalecki.com/creating-typescript-library-with-a-minimal-setup/). You can also have a look at the [package.json](https://github.com/svrooij/node-sonos-ts/blob/master/package.json) and the [tsconfig.json](https://github.com/svrooij/node-sonos-ts/blob/master/tsconfig.json) files in my new repository. In node-sonos-ts the files live in the **src** folder, and the get compiled (and released) from the lib folder. 

## Debugging

Getting your library to compile automatically is one thing, but debugging is might be as important! In node-sonos-ts is a special VSCode [launch.json](https://github.com/svrooij/node-sonos-ts/blob/master/.vscode/launch.json) file. What it does is compiling the library to javascript (with source maps). And that way you can debug the typescript files really easy. You can set breakpoints and they are hit. You can even inspect all the current values.