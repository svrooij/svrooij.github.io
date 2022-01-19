---
title: "Wordpress plugin REST in peace"
published: true
categories:
  - Development
tags:
  - Wordpress
---

In January 2017 I released a plugin for Wordpress called [WP REST API - filter fields](https://wordpress.org/support/plugin/rest-api-filter-fields/) it had a somewhat limited reach (2000+ active installs according to the stats),
but people where using it. It was a plugin on the wordpress rest api (which was also a plugin at that time), it allowed the user to tell the server which fields from the api they wanted back. Because I wasn't changing the api, I was only filtering the output (after everything was retrieved from the database), this didn't make it much faster, but the resulting data to transfer was smaller (which was a big thing 4 years ago).

<!--more-->

## Ten awesome reviews ⭐️

![Reviews screenshot](/assets/images/rest_in_peace.png)

Even though my plugin only got ten [reviews](https://wordpress.org/support/plugin/rest-api-filter-fields/reviews/) they where all **FIVE-STAR** ⭐️⭐️⭐️⭐️⭐️ reviews (without paying people to write a review).
So at least ten people really liked my plugin and took the time to write a review. That feels like an accomplishment! Some quotes:

> Best REST API plugin ⭐️⭐️⭐️⭐️⭐️ *Austin Passy*

> YOU ARE A GOD ⭐️⭐️⭐️⭐️⭐️ *Alex Hall*

## Got noticed

In October of 2017 a Wordpress core developer [K. Adam White](https://profiles.wordpress.org/kadamwhite/), [referrenced](https://core.trac.wordpress.org/ticket/38131#comment:37) my plugin in the core trac from Wordpress.

## Implemented in core

After some lengthy discussions they [implemented](https://core.trac.wordpress.org/changeset/43087) my functionallity in the core of wordpress and released it in the 4.9.8 release (15 dec 2018). Everybody can use this functionallity without installing my plugin. I thought that would be the end of my plugin, and everybody would just migrate over to the build-in functionallity.

## Update to kill

Today someone opened an issue on the github page of the plugin, which I though no one was using anymore. That made me release a new version that does a version check and adds a notice to the admin panel. And just disables the functionality if you're on wordpress 5 or higher.

This is probably the only way to say goodbye to users. There is no such thing as, `Supported Until version x` in Wordpress plugin land.

## Looking back

It was a fun experiance to create a plugin for wordpress that people where actually using. I don't like the fact that to publish a plugin for wordpress, you have to put the files in their SVN server. That feels so nineties.
If I would ever build myself a new plugin for wordpress, I would definitly set it up on [Github](https://github.com/svrooij/rest-api-filter-fields) again, but would then automated everything (testing/publishing, any good guides available?).

I hope I didn't disappoint the users from my plugin by actually creating an update to shut it down, but the build-in version is so much better. It filters the fields before a single post is retrieved from the database, and only retrieves the needed fields.
