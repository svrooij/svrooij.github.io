---
title: Automate your release with Github Actions
date: 2020-06-07T12:15:22+01:00
twitter_image: /assets/images/2020/06/github-actions.png
categories:
  - Development
tags:
  - automatic release
  - CI
  - continuous integration
  - npm package
---
I've got several node/typescript packages on my [Github page](https://github.com/svrooij/). And one of the struggles I faced when starting these, was the manual work needed to release a new version to npm and/or docker hub.

<!--more-->

## Saying goodbye to Travis CI

[Travis CI](https://travis-ci.org/) was my main tool for automating releases to npm, and checking pull-requests for that matter. It helped me getting a grasp of the automatic release process. While working pretty good, I decided to migrate all my automatic releases to Github Actions. This choice is made because of the better integration with Github and the fact that it seems to complete much faster (which is always better).

## Github Actions

You can see [Github Actions](https://github.com/features/actions) as a way to automate all the steps needed to put your package into production. It doesn't stop there you can use it to automate all sort of [stuff](https://github.com/marketplace?type=actions).

## Workflow file

You can get started with Github Actions by creating a yaml file in the **.github/workflows/** folder. See [this sample file](https://github.com/svrooij/node-sonos-ts/tree/master/.github/workflows), which I'm going to explain here.
The first part are the name and the triggers. The triggers tell Github **when** to run your workflow. In this sample I want the workflow to run on pushes to the master or beta. And on pull requests.

```yaml
name: Run tests and publish

on:
  push:
    branches:
      - master
      - beta
  pull_request:
```

## Checkout code and install node

Checkout the code, and install the node version we want to use in this workflow. The workflow chooses to install node version 12 (which is the latest long-time-support version).

```yaml
jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v1
    - name: Use node 12
      uses: actions/setup-node@v1
      with:
        node-version: 12
```

## Run npm scripts

Then the second most important part, installing dependencies, building the library and running the tests. We use **npm ci** instead of **npm install** because the first one is made specially for in continuous integration usage. 

```yaml
    - name: Install depencencies
      run: npm ci
    - name: Build library
      run: npm run build
    - name: Run tests
      run: npm run test
```

## Coveralls

[Jest](https://jestjs.io/) is the used unit test framework and is <a rel="noreferrer noopener" href="https://github.com/svrooij/node-sonos-ts/blob/master/jest.config.js" target="_blank">configured</a> to check code coverage. You can see the coverage result in the actions logs, but that doesn't do anything. There is a special [action](https://github.com/marketplace/actions/coveralls-github-action) that sends the coverage data to [coveralls.io](https://coveralls.io/github/svrooij/node-sonos-ts) for further processing. It keeps track of the code coverage per branch and might deny a pull-request if the coverage drops to much. It needs the the **GITHUB_TOKEN**, this secret is available in every workflow and has read/write access to the current repository. To allow an action the access it, you need to add is specifically in the workflow file.

```yaml
{% raw %}
    - name: Send data to Coveralls
      uses: coverallsapp/github-action@master
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}{% endraw %}
```

## Publish that package already

All the above steps where to test if the current state of the code might be ready to be released. Now the actual release, our workflow uses the <a rel="noreferrer noopener" href="https://github.com/marketplace/actions/action-for-semantic-release" target="_blank">semantic release action</a>. There isn't any extra configuration, so (for now) we use the default configuration. It will release a new version only from the master and beta branch. So you can safely run this action in the workflow that is run on push and pull-requests. It won't release pull-requests.  
To trigger a new release you need to start the commit message with `fix:` for a patch version, with `feat:` for a new minor version and with `perf:` for a major version the commit message should also include `BREAKING CHANGE` with a description of the breaking change.

```yaml
{% raw %}
    - name: Semantic Release
      uses: cycjimmy/semantic-release-action@v2
      id: semantic
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        NPM_TOKEN: ${{ secrets.NPM_TOKEN }}{% endraw %}
```

## What is next?

The semantic release action exports several variables. The next action could be <a rel="noreferrer noopener" href="https://github.com/marketplace/actions/send-tweet-action" target="_blank">sending a tweet</a> (when a new version is released). Then you would need to include a condition. The following sample only sends a tweet if there was a new release. It references the semantic release step by id.

```yaml
{% raw %}
      - uses: ethomson/send-tweet-action@v1
        if: steps.semantic.outputs.new_release_published == 'true'
        with:
          status: "I created a new release for node-sonos-ts, check it out at https://www.npmjs.com/package/@svrooij/sonos"
          consumer-key: ${{ secrets.TWITTER_CONSUMER_API_KEY }}
          consumer-secret: ${{ secrets.TWITTER_CONSUMER_API_SECRET }}
          access-token: ${{ secrets.TWITTER_ACCESS_TOKEN }}
          access-token-secret: ${{ secrets.TWITTER_ACCESS_TOKEN_SECRET }}{% endraw %}
```