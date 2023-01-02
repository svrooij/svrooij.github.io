---
title: "Every project needs a badge"
published: true
categories:
  - Open-source
tags:
  - Badges
twitter_image: /assets/images/MVP_Badge_Horizontal_Preferred_Blue3005_RGB.png
---

You just created a new open-source project. Great, you rock! A lot of repositories have these nice images showing dynamic details of the repository. How does that work? By using these dynamic badges you can really make your repository stand out.

[![LinkedIn Profile][badge_linkedin]][link_linkedin]
[![Twitter follow][badge_twitter]][link_twitter]
[![Link Mastodon][badge_mastodon]][link_mastodon]
[![Blog][badge_blog]][link_blog]

<!--more-->

## Github Readme in Markdown

Styling the readme of your repository, will require a `README.md` file to exist in your repository. If you created a new repository on [Github.com](https://github.com) on of the questions is, `Add a README file`. If you select this option you get a somewhat empty README file created for you.

![Create github repository](/assets/images/2023/01/create-repository.png)

[Markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) is a way to quickly format text without the need to write html. This post is not on how to create a Readme, there are [other resources](https://github.com/matiassingers/awesome-readme) available for that.

## Badges please

<a href="https://shields.io" target="blank"><svg xmlns="http://www.w3.org/2000/svg" width="198" height="58"><rect rx="8" x="140" width="55" height="58"></rect><g stroke="#000" stroke-width="8"><path d="M135.5 54a8 8 0 0 0 8.5 -8.5"></path><rect x="4" y="4" rx="8" width="190" height="50" fill="none"></rect></g><path d="m23.906 33.641c.953-.083 1.906-.167 2.859-.25.108 2.099 1.511 4.139 3.578 4.722 2.438.895 5.357.799 7.559-.658 1.49-1.129 1.861-3.674.324-4.925-1.557-1.322-3.685-1.504-5.576-2.057-2.343-.565-4.912-1.133-6.611-2.979-1.805-2.088-1.627-5.485.292-7.443 2.041-2.113 5.222-2.55 8.02-2.274 2.46.244 5.058 1.343 6.252 3.635.426.908 1.095 2.241.656 3.108-.888.173-1.81.148-2.715.245-.077-2.084-1.727-4.073-3.863-4.234-1.902-.317-4.02-.252-5.691.802-1.398.989-1.849 3.363-.381 4.494 1.281 1.01 2.962 1.199 4.482 1.642 2.66.627 5.602 1.118 7.596 3.158 2 2.188 1.893 5.84-.088 8.01-2.01 2.32-5.304 2.972-8.237 2.713-2.585-.147-5.319-1.024-6.916-3.184-.987-1.288-1.517-2.905-1.542-4.523"></path><path d="m45.953 41c0-7.635 0-15.271 0-22.906.938 0 1.875 0 2.813 0 0 2.74 0 5.479 0 8.219 1.391-1.721 3.69-2.523 5.86-2.236 1.975.154 4.03 1.371 4.513 3.402.504 1.973.278 4.02.33 6.04 0 2.495 0 4.989 0 7.484-.938 0-1.875 0-2.813 0-.009-3.675.018-7.351-.014-11.03-.026-1.342-.627-2.835-2-3.282-2.187-.802-5.077.393-5.609 2.773-.417 1.764-.216 3.586-.264 5.381 0 2.051 0 4.102 0 6.153-.938 0-1.875 0-2.813 0"></path><path d="m63.781 21.328v-3.234h2.813v3.234zm0 19.672v-16.594h2.813v16.594z"></path><path d="m82.25 35.656c.969.12 1.938.24 2.906.359-.702 3.464-4.348 5.767-7.781 5.386-3.235-.066-6.43-2.328-7.06-5.598-.843-3.307-.404-7.285 2.101-9.784 3.082-3 8.699-2.618 11.235.892 1.374 1.85 1.676 4.267 1.578 6.51-4.125 0-8.25 0-12.375 0-.142 2.889 2.267 6 5.346 5.658 1.881-.162 3.613-1.566 4.045-3.423m-9.234-4.547c3.089 0 6.177 0 9.266 0 .129-2.774-2.616-5.422-5.419-4.713-2.174.427-3.912 2.474-3.846 4.713"></path><path d="m88.64 41v-22.906h2.813v22.906z"></path><path d="m106.59 41c0-.698 0-1.396 0-2.094-1.412 2.442-4.776 3.067-7.233 1.949-2.378-1.02-3.971-3.403-4.345-5.924-.507-2.761-.123-5.768 1.389-8.167 1.863-2.705 5.968-3.642 8.711-1.741.422.228 1.028 1.144 1.294 1.018-.006-2.649-.0001-5.298-.003-7.948.932 0 1.865 0 2.797 0 0 7.635 0 15.271 0 22.906-.87 0-1.74 0-2.61 0m-8.89-8.281c-.075 2.246.637 4.861 2.79 5.952 2 1.023 4.682-.047 5.488-2.134.897-1.996.746-4.278.388-6.382-.425-1.95-2.046-3.804-4.158-3.805-1.903-.065-3.633 1.363-4.099 3.181-.327 1.028-.394 2.116-.408 3.188"></path><path d="m112.52 36.05c.927-.146 1.854-.292 2.781-.438.126 1.69 1.513 3.244 3.239 3.365 1.398.212 3.01.12 4.12-.851.807-.749 1.1-2.243.159-3.01-.908-.723-2.115-.812-3.182-1.172-1.797-.485-3.713-.848-5.243-1.97-1.83-1.551-1.868-4.679-.099-6.293 1.577-1.507 3.918-1.784 6-1.594 1.685.176 3.54.749 4.535 2.217.464.715.708 1.549.844 2.384-.917.125-1.833.25-2.75.375-.121-1.569-1.653-2.762-3.19-2.695-1.246-.082-2.702.012-3.608.982-.624.724-.543 1.971.314 2.481.998.706 2.269.757 3.389 1.173 1.754.512 3.647.848 5.141 1.965 1.686 1.476 1.728 4.244.396 5.966-1.298 1.788-3.597 2.417-5.709 2.448-1.466-.007-2.984-.214-4.299-.893-1.599-.909-2.585-2.655-2.84-4.444"></path><g fill="#fff"><path d="m151.11 41v-22.906h3.03v22.906z"></path><path d="m158.55 29.844c-.277-4.765 2.335-9.977 7.05-11.551 4.902-1.757 11.226.197 13.477 5.098 2.266 4.706 1.89 10.92-1.767 14.833-4.554 4.948-13.81 3.976-17.08-1.954-1.111-1.946-1.679-4.188-1.68-6.426m3.125.047c-.377 4.273 2.892 8.844 7.375 8.951 3.791.221 7.557-2.653 7.997-6.497.794-3.731.139-8.292-3.107-10.696-3.788-2.814-10.05-1.104-11.591 3.444-.54 1.539-.642 3.181-.675 4.798"></path></g></svg>
</a>

I'm no designer, luckily there is [Shields.io](https://shields.io) they have badges that show (almost) realtime statistics or information on a repository. They have a lot so I suggest you to browse through them.

### Github Issues

[![GitHub issues](https://img.shields.io/github/issues/svrooij/sonos2mqtt?style=for-the-badge)](https://github.com//svrooij/sonos2mqtt)

A lot of repositories show the number of open [issues](https://shields.io/category/issue-tracking). To show a badge with the number of open issues you just add the following code to your repository:

```md
![GitHub issues](https://img.shields.io/github/issues/svrooij/sonos2mqtt?style=for-the-badge)
```

or this code if you want it to be a link to the repository (in case the README is also shown in some package manager for instance.):

```md
[![GitHub issues](https://img.shields.io/github/issues/svrooij/sonos2mqtt?style=for-the-badge)](https://github.com//svrooij/sonos2mqtt)
```

### Custom Badge

You can also use shields.io to [create custom badges](https://shields.io/#your-badge), it's a matter of changing some text in the url.

![custom badge](https://img.shields.io/badge/custom-badge-yellow?style=for-the-badge)

```md
![custom badge](https://img.shields.io/badge/custom-badge-yellow?style=for-the-badge)
![custom badge](https://img.shields.io/badge/{textInGray}-{textInColor}-{color}?style=for-the-badge)
```

### Custom badge with logo

In my [year review](https://svrooij.io/2023/01/02/this-was-2022/#event-concierge) I used a badge for some Power Automate flow I shared with my followers. It just makes a readme look cool. Check the `&logo=...` part of the url.

![custom badge with logo](https://img.shields.io/badge/Power%20Automate-event--concierge-orange?style=for-the-badge&logo=powerautomate)

```md
![custom badge with logo](https://img.shields.io/badge/Power%20Automate-event--concierge-orange?style=for-the-badge&logo=powerautomate)
```

They just integrated with [SimpleIcons](https://simpleicons.org/) to immediately support almost all the logos you can imagine. That extra logo in the badge really makes it shine.

### Re-using badges

Personally I always use reference links of badges with their links that makes it easy to change all the links at once if you use a single badge multiple times on the same page.

[![LinkedIn Profile][badge_linkedin]][link_linkedin]
[![Link Mastodon][badge_mastodon]][link_mastodon]
[![Follow on Twitter][badge_twitter]][link_twitter]
[![Check my blog][badge_blog]][link_blog]

Use this code everywhere you want to use the badges:

```md
[![LinkedIn Profile][badge_linkedin]][link_linkedin]
[![Link Mastodon][badge_mastodon]][link_mastodon]
[![Follow on Twitter][badge_twitter]][link_twitter]
[![Check my blog][badge_blog]][link_blog]
```

And add the required reference links all the way to the bottom of the markdown file.

```md
[badge_blog]: https://img.shields.io/badge/blog-svrooij.io-blue?style=for-the-badge
[badge_linkedin]: https://img.shields.io/badge/LinkedIn-stephanvanrooij-blue?style=for-the-badge&logo=linkedin
[badge_mastodon]: https://img.shields.io/mastodon/follow/109502876771613420?domain=https%3A%2F%2Fdotnet.social&label=%40svrooij%40dotnet.social&logo=mastodon&logoColor=white&style=for-the-badge
[badge_twitter]: https://img.shields.io/twitter/follow/svrooij?logo=twitter&style=for-the-badge
[link_blog]: https://svrooij.io/
[link_linkedin]: https://www.linkedin.com/in/stephanvanrooij
[link_mastodon]: https://dotnet.social/@svrooij
[link_twitter]: https://twitter.com/svrooij
```

Getting the mastodon id for the badge requires using [this tool](https://prouser123.me/misc/mastodon-userid-lookup.html).

### Styling the badges

Shields.io has five [styles](https://shields.io/#styles) available for you to use. I just prefer the `for-the-badge` style, so that is in all the sample badges.

If you prefer one of the other styles, just change the `style` parameter in the badge url to the preferred one.

## Final notes

The dynamic badges (those with data inside) are always loaded from the external server. Some users might have privacy concerns with this.
The same counts for the static images, but you could download those and serve them directly from your repository.

Also if shields.io is down, your readme might look strange. Be sure to add `alt` texts to all the badges, which is a great idea from an accessibility point of view anyway.

Please go ahead and make your README look awesome with these small badges.

[badge_blog]: https://img.shields.io/badge/blog-svrooij.io-blue?style=for-the-badge
[badge_linkedin]: https://img.shields.io/badge/LinkedIn-stephanvanrooij-blue?style=for-the-badge&logo=linkedin
[badge_mastodon]: https://img.shields.io/mastodon/follow/109502876771613420?domain=https%3A%2F%2Fdotnet.social&label=%40svrooij%40dotnet.social&logo=mastodon&logoColor=white&style=for-the-badge
[badge_twitter]: https://img.shields.io/twitter/follow/svrooij?logo=twitter&style=for-the-badge&logoColor=white
[link_blog]: https://svrooij.io/
[link_linkedin]: https://www.linkedin.com/in/stephanvanrooij
[link_mastodon]: https://dotnet.social/@svrooij
[link_mvp-profile]: https://mvp.microsoft.com/PublicProfile/5004985
[link_twitter]: https://twitter.com/svrooij
