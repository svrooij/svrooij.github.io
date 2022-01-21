---
id: 77
title: Filter the fields returned by the wordpress api
date: 2015-10-29T12:22:08+01:00


guid: http://svrooij.nl/?p=77
old_permalink: /2015/10/filter-fields-returned-by-wordpress-api/
twitter_image: /assets/images/2015/10/wp-rest-api-v2.jpg
categories:
  - Coding
tags:
  - api
  - plugin
  - rest
  - wordpress
---
<a href="http://wordpress.org" target="_blank">WordPress</a> is a great platform for running a website with a content management system behind it. Around a year ago the released a plugin called <a href="https://wordpress.org/plugins/rest-api/" target="_blank">WordPress REST API</a>. And this is a really nice addition to WordPress. This plugin enables you to retrieve all the posts/comments/terms in a really easy JSON format.

<!--more-->

## JSON vs XML

In the last few years JSON has become the default way for app developers to fetch remote data in a mobile app. A nice size comparison between XML and JSON can be found <a href="http://www.codeproject.com/Articles/604720/JSON-vs-XML-Some-hard-numbers-about-verbosity" target="_blank">here</a>.

So I wanted to use the wordpress rest api for my next project. It is going to be a mobile application. So I wanted to use JSON as it is smaller then XML (less KB = faster app). By default the api sends back a pretty big JSON file, per post. <a href="http://svrooij.nl/wp-json/wp/v2/posts?per_page=1" target="_blank">Last post in JSON</a>

## We want less data

I though that is not what I want for my new project. Because I only want the necessary data, required for my app. So I created a little plugin that extends the default rest api plugin. It is called <a href="https://wordpress.org/plugins/rest-api-filter-fields/" target="_blank">REST API &#8211; Filter Fields</a>. This plugin allows the developer to filter the returned fields based on a get parameter.

This way I can specify which fields I want returned from the API and reducing the file size of the response. <a href="http://svrooij.nl/wp-json/wp/v2/posts?per_page=1&fields=date,link,title,excerpt" target="_blank">Last post in JSON (only the required fields)</a>

### Plugin: REST API &#8211; Filter fields

This new plugin is available for free at <a href="https://wordpress.org/plugins/rest-api-filter-fields/" target="_blank">https://wordpress.org/plugins/rest-api-filter-fields/</a> and the source can be found on <a href="https://github.com/svrooij/rest-api-filter-fields/" target="_blank">Github</a>
