---
title: "Fork proof actions"
published: true
tags:
  - Github
  - Github Actions
---

Github actions are a great tool to setup automatic build and tests. I also use it for any of my automatic releases. See [this](https://svrooij.nl/2020/06/automate-your-release-with-github-actions/) post.
Until now there was one thing missing. If someone would fork the repository, all builds would fail because of missing secrets needed for the release.

Yesterday I released my [first github action](https://github.com/svrooij/secret-gate-action), it allows you to check if certain secrets are set, and then decide to continue yourself. Or skip specific steps, this functionallity seemed to be missing from the actions marketplace. So now yoou can check the existens of certain secrets (or other inputs), and decide to either have the actioon run fail or just continue and skip some steps.

![Screenshot action result](/assets/images/2020-07-08_github-action-result.png)

## Fail fast

If the secrets should contain credentials for a mandatory service, this action allows you to fail fast. Before even trying to send them to some external service.
It will also show a nice warning what is missing, that should make it clear to everyone why some action is failing.

## Building an action

Building this new github action was really easy. Github has some nice [documentation](https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action) about it. You can do it either as a docker container (which can run any kind of script) or as a node script.

So if you feel something is missing from the github actions. Just build it yourself! REally easy and can help a lot of people.
