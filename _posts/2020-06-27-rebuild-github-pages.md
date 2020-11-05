---
title: "Daily rebuild github pages"
published: true
tags:
  - Github
  - Github Actions
  - Github Pages
---

Today I switched to [personal website](https://github.com/github/personal-website) for my new [personal page](https://static.svrooij.nl) on Github.
It's a pretty nice template to generate a **static page** with the use of [Jekyll](https://jekyllrb.com/), at build time it loads some details from github (like my repositories).
This means that the page will only show the data of the last time it was build.

## Github actions to the rescue

You can however trigger a Github Page build by calling some [github endpoint](https://developer.github.com/v3/repos/pages/#request-a-github-pages-build).
So let's do that on a regular interval.

1. Setup a [personal access token](https://github.com/settings/tokens) with `public_repo`.
2. Save the token as secret in the repository as `GH_TOKEN`.
3. Add a [workflow file](https://github.com/svrooij/svrooij.github.io/tree/master/.github/workflows/rebuild.yml) to trigger the build.

```yml
{% raw %}# File: .github/workflows/rebuild.yml
name: Rebuild

on:
  schedule:
    - cron:  '0 6 * * *' # Runs every day at 6am

jobs:
  refresh:
    runs-on: ubuntu-latest
    steps:
      - name: Call GitHub pages build endpoint
        run: |
          curl --fail --request POST \
            --url https://api.github.com/repos/${{ github.repository }}/pages/builds \
            --header "Authorization: Bearer $GH_TOKEN"
        env:
          # Create a token at https://github.com/settings/tokens
          # since you cannot trigger a new build with the regular token.
          GH_TOKEN: ${{ secrets.GH_TOKEN }}{% endraw %}
```

You'll need an extra personal access token because you cannot trigger an action from an action, this could potentially lead to an endless loop. In all other cases you shouldn't need to create a new personal access token, since you already get the `{% raw %}${{ secrets.GITHUB_TOKEN }}{% endraw %}` inside each Github actions run.
