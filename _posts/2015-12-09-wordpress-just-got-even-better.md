---
id: 95
title: WordPress just got even better!
date: 2015-12-09T23:47:48+01:00
guid: https://svrooij.nl/?p=95
old_permalink: /2015/12/wordpress-just-got-even-better/
twitter_image: /assets/images/2015/12/wordpress.jpg
categories:
  - Coding
tags:
  - api
  - plugin
  - rest
  - wordpress
---
Yesterday **WordPress 4.4** was released, with this version they improved this product even more.

The most notable new features are, support for **oEmbed** and an integrated **REST API**.

What is **oEmbed** and why is this a new amazing feature? oEmbed is a specification for embedding content from an other website right inside the consuming website. This enables (for instance) Twitter to display the excerpt of a post instead of just a link to your wordpress website. This specification is originally design by (members of) Flicr, but with the wordpress implementation the adoption will get even bigger.

<!--more-->

<blockquote class="wp-embedded-content" data-secret="tRX6kFC2el">
  <p>
    <a href="https://wordpress.org/news/2015/12/clifford/">WordPress 4.4 `Clifford`</a>
  </p>
</blockquote>



The REST API started as a <a href="https://wordpress.org/plugins/rest-api/" target="_blank">plugin</a> but will now be integrated into the wordpress core. This means that everyone can start using the WordPress REST API even easier. This doesn't seem to be such a big change, but it might be very useful when creating a custom wordpress theme. Loading more posts without navigating to an other page just got easier. You can even use a wordpress website as a backend for a mobile application.

This looks like a magical solution for everything, but it also has a flaw. [opinion\_ON] The rest API returns to much information [opinion\_OFF], but this can be fixed with my own <a href="https://wordpress.org/plugins/rest-api-filter-fields/" target="_blank">REST Api - Filter fields</a> plugin. Explained in [this other post](https://svrooij.nl/2015/10/filter-fields-returned-by-wordpress-api/).

Apart from this flaw I really like the REST API, and also love the fact that they are finally integrating it in the WordPress core!
