---
title: "Git extra author"
published: true
categories:
  - Development
tags:
  - Git
  - Github
---

If someone else created some sourcecode, but for whatever reason they aren't the one adding it to the repository. You can still have their name/photo in the git commit.

<!--more-->

## Add an extra author

Just add the following to the commit message.

```plain

Co-authored-by: Name <email@domain.com>
```

## Add an extra author (no public email)

If the extra author doesn't want his/her email to become public. Or you don't know their emailaddress. You can use a special emailaddress. That way github will still connect the right user, but their email stays protected (or unknown).

1. Get the correct username
2. Get the Github user ID [try this page](https://caius.github.io/github_id/)
3. format the email like `[userID]+[github_username]@users.noreply.github.com`

Or generate the Co-Authored text [here](/github-info.html).

## Contribute code to me

So you want to commit code to me? You the following in your commit message (yes the empty line is required).

```plain

Co-authored-by: Stephan van Rooij <1292510+svrooij@users.noreply.github.com>
```
