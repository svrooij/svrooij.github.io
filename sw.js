---
layout: none
---
importScripts('https://storage.googleapis.com/workbox-cdn/releases/5.1.2/workbox-sw.js');

workbox.core.setCacheNameDetails({
  prefix: 'svrooij.io',
  suffix: '{{ site.time | date: "%Y-%m" }}'
});

workbox.precaching.precacheAndRoute([
  {% for post in site.posts limit:12 %}{ url: '{{ post.url }}', revision: '{{ post.date | date: "%Y-%m-%d"}}' },
  {% endfor -%}
  { url: '/', revision: '{{ site.time | date: "%Y%m%d%H%M" }}' },
  { url: '/page2', revision: '{{ site.time | date: "%Y%m%d%H%M" }}' },
  { url: '/page3', revision: '{{ site.time | date: "%Y%m%d%H%M" }}' },
  { url: '/assets/css/index.css', revision: '{{ site.time | date: "%Y%m%d%H%M" }}' }
])

workbox.routing.registerRoute(
  '/',
  new workbox.strategies.NetworkFirst()
);

workbox.routing.registerRoute(
  /page[0-99]/,
  new workbox.strategies.NetworkFirst()
)

workbox.routing.registerRoute(
  new RegExp('/\\d{4}/\\d{2}/\\d{2}/.+'),
  new workbox.strategies.NetworkFirst()
)

workbox.routing.registerRoute(
  /assets\/(images|icons|css)/,
  new workbox.strategies.CacheFirst()
);