---
title: "Jekyll website to progressive web app"
published: true
categories:
  - Development
tags:
  - Jekyll
  - PWA
  - Service worker
twitter_image: /assets/images/2022/01/manifest.png
---

A PWA (or Progressive web application) is a website which can be installed on a desktop and acts like an app. It has an icon and a title. And it can even receive messages from the server if the app isn't running. It can also show notification messages to the users.

So in short it's a website acting like an app. This post shows you how to turn a Github Pages website into a pwa in three easy steps.

<!--more-->

## Add a manifest

You'll need to inform the browser that your website is installable as an app. You'll do that by creating a [Web manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest), named `manifest.json`.

```json
{
  "$schema": "https://json.schemastore.org/web-manifest-combined.json",
  "name": "Developer blog",
  "background_color": "#000",
  "theme_color": "#00a880",
  "start_url": "/",
  "display": "standalone",
  "description": "Developer blog sharing ideas and smart solutions to others",
  "icons": [{
    "src": "/icon.svg",
    "sizes":"any",
    "type": "image/svg+xml"
  }]
}
```

And linking to in in the `head` of your page:

```html
<link rel="manifest" href="manifest.json">
```

## Add a service worker

For a website to act like an app, it needs a [Service Worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API). This is a small javascript file that is loaded by your browser and can handle the notifications and in this case the **offline** mode for this website.

A service worker file **needs** to be placed in the root of your website! This is important because it can only handle stuff that is below that url. So you cannot put it in a subfolder.

In this website I use [Workbox](https://developers.google.com/web/tools/workbox) which is a Google made library for setting up a service worker in no time. I use [this](https://github.com/svrooij/svrooij.github.io/blob/master/sw.js) service worker file. It uses **Jekyll** with `layout: none` so the file is processed at build (to add the posts it should pre-load). The resulting file looks like [this]({{ '/sw.js' | relative_url }}) is case you're wondering.

Just copy [my template](https://github.com/svrooij/svrooij.github.io/blob/master/sw.js) and adjust to your needs. You should customize the routes in the bottom to match your sites config.

## Register the service worker

For your page to actually use the service worker, you should **register** it to the page.

Add this script to the footer of your page, like I did [here](https://github.com/svrooij/svrooij.github.io/blob/8afa2b0c2b40d30f70753c33432f84edea62e5f5/_includes/footer.html#L1-L7):

```html
<script>
  if('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
      navigator.serviceWorker.register('/sw.js')
    })
  }
</script>
```

## Done

If you followed these three steps, your website should now show this little icon in the address bar, allowing you to **install** it as an actual app. With icon, and theme colors. The address bar will disappear (since it's now an app) and the icon will be visible in your taskbar (or start menu, depending on your choices).

Because we use **Workbox** to do some pre loading and caching, your website will also be a bit faster and **available offline** for all the pre-loaded posts and pages, and all the posts and pages you visited will being online.
