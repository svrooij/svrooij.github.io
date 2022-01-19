---
title: "Clone a BIG git repository"
published: true
categories:
  - Development
tags:
  - Github
card_image: /assets/images/header-development.png
---

Wanted to clone a repository to do a quick text fix and create a pull request. Created the [fork](https://github.com/svrooij/azure-docs), and tried to clone.
Cloning the repository took way longer than I'm used to.

![Slow git clone](/assets/images/2022/01/slow-git-clone.png)

<!--more-->

## Shallow clone

I heard about **shallow clone** that supposed to only clone a single branch, and thus keep the clone fast.

```bash
git clone [remote-url] --branch [name] --single-branch [folder]
```

This didn't work, cloning still took forever.

## Clone with filter

Apparently the repository I was cloning, had a lot of large files in it. So I tried using a blob filter, set for 20Kb. Meaning the following command would skip downloading all files larger then 20Kb.

```bash
git clone --filter=blob:limit=20k https://github.com/svrooij/azure-docs.git
```

This seemed to be the work-around for this problem.

## Large files in git (the right way)

The above repository just has all the large files in the repository. Which obviously results in extreme long clone times. In [2015](https://github.com/git-lfs/git-lfs/blob/main/CHANGELOG.md#v050-10-april-2015) they release [git-lfs](https://git-lfs.github.com/). This allows you to keep using git, but the large files (that you configured) will no longer be saved in the repository. The git history will just contain a reference to the large file that is saved outside of the repository.
