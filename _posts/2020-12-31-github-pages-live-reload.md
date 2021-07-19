---
title: "Github pages (Jekyll) live reload with docker"
published: true
tags:
  - Github
  - Github Pages
  - Jekyll
image: /assets/images/jekyll-docker-love.png
---

I really like [Github Pages](https://pages.github.com/) to host static webpages. Static in this case means the files are generated at build time (so once when you publish a new version), instead of every time like with a wordpress website. One of the main benefits is that it results in a blazing fast website.

## Jekyll

A lot of websites that are running on Github Pages are actually just a [bunch](https://github.com/svrooij/svrooij.github.io/tree/master/_posts) of markdown files that get converted to html by [Jekyll](https://jekyllrb.com/). Jekyll is run on every repository that uses Github Pages, unless you explicitly disable it.

### Jekyll = ruby

Jekyll is build in ruby, and if you have ruby installed you can also use your local ruby installation to start live reload.

## Use docker to live reload

I'm not a ruby expert, nor do I want to install any tools that I don't know how they work. I already had docker installed, so I figured out it was the most convenient way to enable live reload for my blog. This will probably work for most jekyll projects but you might have to tweak some things.

### Gemfile

A Gemfile described the needed dependencies, I use [this](https://github.com/svrooij/svrooij.github.io/blob/master/Gemfile) file for the current blog. You need to add this file to your repository to be able to run Jekyll "locally".

```ruby
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
gem "jekyll-github-metadata"
gem "jekyll-octicons"
gem "jemoji"
```

### docker-compose.yml

Next is to create a `docker-compose.yml` file in your repository. I'm using [this](https://github.com/svrooij/svrooij.github.io/blob/master/docker-compose.yml) one:

```yml
version: '3.3'
services:
  jekyll:
    volumes:
        - './:/srv/jekyll'
    ports:
        - '4000:4000'
        - '35729:35729'
    image: jekyll/jekyll
    command: jekyll serve --incremental --livereload --force_polling
```

### Live reload

Once you added the above files to your repository, you can just run `docker-compose up` to get started. It will first load all needed Gems, then start the server and then do the first compilation.

If you save a file, it will automatically recompile and refresh your webpage.

## Demo time

1. Just clone this blog somewhere `git clone https://github.com/svrooij/svrooij.github.io.git`
2. Open the folder `cd svrooij.github.io`
3. Run `docker-compose up` (you can stop the container once you're done, with `CTRL+C`)
4. Open `http://localhost:4000` in the browser
5. Open a specific page, edit that page in code and see it reload in the browser automatically.
