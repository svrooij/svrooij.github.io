---
title: "Nginx fault finding"
published: true
categories:
  - Sysadmin
tags:
  - Nginx
twitter_image: /assets/images/2023/03/grep-search-in-file.png
---

I had an issue with a NGINX server not starting after an upgrade, `sudo nginx -t` did not help.

<!--more-->

I was faced with this:

```text
> sudo nginx -t
nginx: [emerg] unknown "optin_login" variable
nginx: configuration file /etc/nginx/nginx.conf test failed
```

but `optin_login` was not in the config.

## GREP to the help

```bash
grep -rnw '/etc/nginx' -e 'optin_login'
```

And tada found the exact location where this missing variable was used.

```text
/etc/nginx/sites-available/just.kidding.not.real:31:      if ($optin_login = no) {
/etc/nginx/sites-available/also.not.real:47:      if ($optin_login = no) {
/etc/nginx/conf.d/map-country.conf:15:#map $geoip_country_code $optin_login {
```

## Connect with me

[![LinkedIn Profile][badge_linkedin]][link_linkedin]
[![Link Mastodon][badge_mastodon]][link_mastodon]
[![Follow on Twitter][badge_twitter]][link_twitter]
[![My MVP profile][badge_mvp]][link_mvp-profile]
[![Check my blog][badge_blog]][link_blog]

[badge_blog]: https://img.shields.io/badge/blog-svrooij.io-blue?style=for-the-badge
[badge_linkedin]: https://img.shields.io/badge/LinkedIn-stephanvanrooij-blue?style=for-the-badge&logo=linkedin
[badge_mastodon]: https://img.shields.io/mastodon/follow/109502876771613420?domain=https%3A%2F%2Fdotnet.social&label=%40svrooij%40dotnet.social&logo=mastodon&logoColor=white&style=for-the-badge
[badge_mvp]: https://img.shields.io/badge/MVP-Security-blue?style=for-the-badge&logo=microsoft
[badge_twitter]: https://img.shields.io/twitter/follow/svrooij?logo=twitter&style=for-the-badge&logoColor=white
[link_blog]: https://svrooij.io/
[link_linkedin]: https://www.linkedin.com/in/stephanvanrooij
[link_mastodon]: https://dotnet.social/@svrooij
[link_mvp-profile]: https://mvp.microsoft.com/en-us/PublicProfile/5004985
[link_twitter]: https://twitter.com/svrooij
