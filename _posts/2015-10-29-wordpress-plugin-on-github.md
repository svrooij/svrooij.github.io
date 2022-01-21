---
id: 83
title: Hosting a wordpress plugin on Github
date: 2015-10-29T13:04:59+01:00
guid: http://svrooij.nl/?p=83
old_permalink: /2015/10/wordpress-plugin-on-github/
twitter_image: /assets/images/2015/10/github-banner.png
categories:
  - Coding
tags:
  - github
  - grunt
  - plugin
  - wordpress
---
Someone at <a href="http://wordpress.org" target="_blank">WordPress</a> decided that if you want to create a plugin for WordPress, you'll have to host it at their SVN server. Personally I'm not a big fan of SVN, I'm more a GIT person.

Lucky for me, it appears I'm not the only one. So for my latest WordPress plugin (<a href="https://wordpress.org/plugins/rest-api-filter-fields/" target="_blank">REST API &#8211; Filter Fields</a>) I used <a href="https://github.com/svrooij/rest-api-filter-fields/" target="_blank">Github</a>. Then I came to a few problems that had to be solved.

<!--more-->

#### Small problems

* Github wants a README.md (markdown) file and WordPress wants a readme.txt file with some required options
* How do I deploy a new version of my plugin to the WordPress SVN server?
* And how can I make this proces as easy as possible?


## Grunt to the rescue

<a href="http://gruntjs.com" target="_blank">Grunt</a> is a Javascript Task Runner build in node.  
You can instruct it to do some tasks for you. These steps I created to make my life as a WordPress Plugin developer easier:

  * Use &#8216;<a href="https://github.com/stephenharris/wp-readme-to-markdown" target="_blank">wp_readme_to_markdown</a>&#8216; to create a **README.md** file right from the required **README.txt**
  * Use &#8216;<a href="https://github.com/gruntjs/grunt-contrib-copy" target="_blank">grunt-contrib-copy</a>&#8216; to create a &#8216;build' folder with all the files required for the plugin
  * Use &#8216;<a href="https://github.com/stephenharris/grunt-wp-deploy" target="_blank">grunt-wp-deploy</a>&#8216; to parse the &#8216;**readme.txt**&#8216; and the &#8216;**rest-api-filter-fields.php**&#8216;, to verify their version tags match (required) and to deploy this new version to the wordpress svn

This way when I edit my readme.txt, I run &#8216;_grunt build_&#8216; to create the readme.md file (for Github). This takes about 1 second. And it makes sure they both have the same text (only formatted slightly different).  
If I edited the plugin (and the version number / changelog), I enter the command &#8216;_grunt deploy_&#8216;. It then copies all the files to the &#8216;build' directory, asks me if I want to deploy the version x. And then it prompts for my wordpress svn password.

### Sounds good, how do I use it?

Before you get started you'll have to make sure that you install `node`, `npm` and `grunt-cli`.  
The first two should be easy, the last one can be installed by using `npm install -g grunt-cli`  
Getting started with Grunt is described at their site, see <a href="http://gruntjs.com/getting-started" target="_blank">Getting Started</a>. Using the modules to create the readme.md and to publish the plugin, are also not that hard. Just check-out their repositories.

If you cannot get this setup (for publishing your wordpress plugin) working, you can always have a look at the <a href="https://github.com/svrooij/rest-api-filter-fields/blob/master/Gruntfile.js" target="_blank">Gruntfile.js</a> file in the repository.
