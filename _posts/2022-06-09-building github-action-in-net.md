---
title: "Building a GitHub Action in .NET"
published: true
categories:
  - Development
tags:
  - GitHub
  - CI
  - .NET
twitter_image: /assets/images/github-actions-banner.png
---

GitHub Actions allow you to run some program every time an event (or trigger) happens in GitHub. You can respond to a new PR, a new issue or even periodically run some job. There are [thousands](https://github.com/marketplace?type=actions) of little actions you can use in your own workflow.

![undraw image](/assets/images/github-actions-banner.png)

<!--more-->

## Getting started with GitHub Actions

We won't go into [getting started with GitHub Actions](https://docs.github.com/en/actions/quickstart) because others are better at that.

Just to know, you'll create a workflow file, stating which event should trigger that workflow and what actions should be called.

## What is a GitHub Action

A GitHub action consists of two (or three) parts:

1. Command line script/program
2. Actions manifest (a file called `action.yml` in the root of the repo)
3. (optionally) docker container wrapping the application and dependencies to run on any platform

## What should the action do

I have this blog (your are currently reading), and I have my [GitHub user profile](https://github.com/svrooij). To get some more attention to my recent posts, I wanted a way to automatically update my user profile with my latest posts.

I also like to experiment with tools I've never used so I created a [github action](https://github.com/marketplace/actions/dotnet-feeder-feed) that takes a [json feed](https://svrooij.io/feed.json) and updates the defined files.

## Step 1 - Create console application

This action is meant to run unattended, so a desktop application is of no use. You could parse arguments yourself (they are passed to the `Main(string[] args)`), but I opted to use [CliFx](https://github.com/Tyrrrz/CliFx) which turned out a great solution to parse all the arguments.

This is not the only framework for parsing command line arguments, but I never used this one before so I though to give it a try.

At this point you should have a console application, like this one [dotnet-feeder](https://github.com/svrooij/dotnet-feeder/tree/main/src/feeder). You can modify/build/run it on your own computer (if you have .NET 6 SDK installed).

You can also follow the [Tutorial Create a GitHub Action with .NET](https://docs.microsoft.com/en-us/dotnet/devops/create-dotnet-github-action) on the Microsoft documentation website.

## Step 2 - Package the application

According to the [package list](https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-Readme.md) the .NET SDK should be available on each agent, according to the [GitHub Creating Actions](https://docs.github.com/en/actions/creating-actions) page we can only create javascript, script or docker actions.

Docker it is. That way we can pre-build the application and make sure all the dependencies are available to the runner. Let's package the application in a [Docker container](https://github.com/svrooij/dotnet-feeder/pkgs/container/dotnet-feeder) and push it to the free GitHub Container Registry. This container is pulled to every agent that is going to execute our action. For that reason we want it to be as small as possible.

This application uses [this Dockerfile](https://github.com/svrooij/dotnet-feeder/blob/main/Dockerfile) to pull the alpine image and do a multi-stage build meaning the resulting image does not contain any unnecessary files or executables (like the .NET SDK).

Manually updating the container on every change is possible, but why not use [GitHub Actions](https://github.com/svrooij/dotnet-feeder/blob/main/.github/workflows/build.yml) to automate that part? I would not like to have to do this manually every time I change something in the code.

## Step 3 - Create action.yml file

You have this application, it's packages as a docker container, pushed to a public container registry. How can others use it?

You'll need to create a [action.yml](https://github.com/svrooij/dotnet-feeder/blob/main/action.yml) file. If you put this file in the root of the repository, you have the options to publish the action to the [GitHub Actions marketplace](https://github.com/marketplace?type=actions) for others to discover. If you put the file in a subfolder, others can still use it, but you cannot publish it to the marketplace.

All the details on creating this action.yml file can be found in the [documentation](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions). This is a sample of the action file used for dotnet-feeder.

```yaml
{% raw -%}
# Pick a great name for your action (this was not a good name by the way)
name: 'dotnet-feeder - feed'
description: 'Writing posts from a json feed to a markdown file, use for automatically updating your Profile readme.'
# Some branding details
branding:
  icon: rss
  color: orange
# Inputs for this action, input values are mandatory, unless otherwise specified
inputs:
  feed:
    description:
      'The URL of the json feed'
  files:
    description:
      'File(s) you wish to update. Separate multiple by ;'
  template:
    description:
      'The post template'
    required: false
    default: '- [{title}]({url})'
# Define one or more outputs defined by your action
outputs:
  files-updated:
    description:
      'Wether or not there where files updated, to conditionally trigger a commit'
# How to run this action
runs:
  using: 'docker' # This is a docker container
  image: 'docker://ghcr.io/svrooij/dotnet-feeder:latest' # container location, prefixed with docker:// (which is very important!)
  args: # Zero or more arguments to pass, as if you would run locally.
  - 'feed'
  - ${{ inputs.feed }}
  - ${{ inputs.files }}
  - '--template'
  - ${{ inputs.template }}
{% endraw %}
```

## Seeing your action execute

For others to use your action, they need to create a [workflow file](https://github.com/svrooij/dotnet-feeder/blob/main/.github/workflows/refresh.yml) in the `./.github/workflows/` folder of the repository.

To execute dotnet-feeder, you have to add the following step to your workflow:

```yaml
# Check-out the code
  - uses: actions/checkout@v3

# Our action  
  - name: Dotnet-feeder
    uses: svrooij/dotnet-feeder@main # owner/repository@branch_or_tag
    # or if the action.yml was in subfolder feed
    # uses: svrooij/dotnet-feeder/feed@main # owner/repository/subfolder@branch_or_tag
    with: # inputs for the action
      feed: https://svrooij.io/feed.json
      files: ./README.md

# Use an action by stefanzweifel to commit the changes (if any). 
  - uses: stefanzweifel/git-auto-commit-action@v4
    with:
      commit_message: Posts refreshed
      file_pattern: README.md
```

## Conclusion

Microsoft had a great [tutorial](https://docs.microsoft.com/en-us/dotnet/devops/create-dotnet-github-action) to get you started, but it was missing something, so I created a [PR](https://github.com/dotnet/docs/pull/29769) for it.

The performance will get a great boost if you don't use the [Dockerfile](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions#runs-for-docker-container-actions) method described in the official documentation, but instead pre-package the action as a container.

Did you know that you could [schedule](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule) your GitHub Workflows? You can use it to periodically run some tasks, like updating a **README.md** file every week.

You will have to set absolute paths in the Dockerfile entrypoint, because the current working directory is set to the root of your repository when your container is run by GitHub. This part had me puzzled for a while.

`ENTRYPOINT ["/usr/bin/dotnet", "/app/Feeder.dll"]`

Building a GitHub Action was a great experience, it all starts with some good idea. What would you like to automate?
