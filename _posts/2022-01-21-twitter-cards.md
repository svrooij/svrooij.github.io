---
title: "Twitter cards for static web page"
published: true
categories:
  - Development
tags:
  - Twitter
  - Content
twitter_image: /assets/images/2022/01/twitter-cards.png
---

My personal page is a static website hosted on [Github pages](https://pages.github.com/). Posts are written in [markdown](https://en.wikipedia.org/wiki/Markdown) and the source of all the posts is in my [public repository](https://github.com/svrooij/svrooij.github.io/tree/master/_posts). I tweet about most posts at least once, and it just shows the link, that's not what I want.

All tweets to my blog should at least show the title and a short description. Maybe even a large image related to the post.

<!--more-->

## Twitter cards

Making sure Twitter generates this nice [Summary card with large image](https://developer.twitter.com/en/docs/twitter-for-websites/cards/overview/summary-card-with-large-image) is actually really easy, that is if you have an image describing the post. You just need to add the following tags to the `<head>` section of your page. Off course you'll have to fill in the correct values.

```html
{% raw %}
  <meta property="og:title" content="{Page title here}" />
  <meta property="og:description" content="{Page description here}" />
  <meta property="og:image" content="{ABSOLUTE_url_to_page_image_here}" />
  <meta name="twitter:card"  content="summary_large_image" />
  <meta name="twitter:site" content="@{own_twitter_account}" />
{% endraw %}
```

## Twitter cards in Jekyll

This website uses [Jekyll](https://jekyllrb.com/) to generate static html files based on templates. I already had a [header.html](https://github.com/svrooij/svrooij.github.io/blob/master/_includes/header.html) file that is included on each page, so that was the best place to add this new information, based on the variables I already had.

```html
{% raw %}
  <meta property="og:title" content="{{ page_title }}" />
  <meta property="og:description" content="{{ meta_description }}" />
  {% if page.twitter_image %}
  <meta property="og:image" content="{{ page.twitter_image | absolute_url }}" />
  <meta name="twitter:card"  content="summary_large_image" />
  {% else %}
  <meta property="og:image" content="{{ site.avatar_url | absolute_url }}" />
  <meta name="twitter:card"  content="summary" />
  {% endif %}
  <meta name="twitter:site" content="@{{ site.social_media.twitter }}" />
  <meta name="twitter:creator" content="@{{ page.author | default: site.social_media.twitter }}" />
{% endraw %}
```

The parts in `{% raw %}{{ variable_name }}{% endraw %}` are liquid variables that are automatically filled in when it's generating the page.

## Code image

I blog a lot about code snippets, so how do you get those nice images you ask? I found this awesome **VS Code** extension called [Code snapshot](https://marketplace.visualstudio.com/items?itemName=robertz.code-snapshot) that does exactly what the name implies. You select some code, open the extension and **BAM** awesome looking image of the code you selected.

![Sample Code snapshop](/assets/images/2022/01/twitter-cards.png)
