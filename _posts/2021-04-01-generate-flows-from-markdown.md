---
title: "Generate awesome flows in markdown"
published: true
tags:
  - Flows
  - Markdown
  - Charts
  - Mermaid
---

Flow diagrams can help greatly to explain some flow, it works much better the just text. To generate visual flows from text (markdown), [Knut Sveidqvist](https://github.com/knsv) created [Mermaid-js](https://mermaid-js.github.io/mermaid/#/). It's awesome, go check out the docs.

## Example

Mermaid will turn this (markdown):

```Markdown
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

Into this basic flow:

{% mermaid %}
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
{% endmermaid %}

## Use Mermaid-js in Github Pages

To use it in Github Pages (or Jekyll), you'll need to do some extra config.

### Download the latest release

Go to [mermaid-js release page](https://github.com/mermaid-js/mermaid/releases) and download the latest release.

### Add javascript files to project

I downloaded [Mermaid-js 8.9.2](https://github.com/mermaid-js/mermaid/releases/tag/8.9.2) release, and just took the `dist\mermaid.min.js` and `dist\mermaid.min.js.map` and copied them to `assets\mermaid-8.9.2` (new) folder in my Jekyll project.

### Add jekyll-mermaid to _config.yml

To use this file in Github Pages, someone made this nice jekyll plugin. Go ahead and add the following to your `_config.yml` file.

```yml
# This is my plugins section
plugins:
  - jekyll-octicons
  - jekyll-github-metadata
  - jemoji
  # Only this one is added
  - jekyll-mermaid

# And you also need to add the mermaid config (change to the correct path)
mermaid:
  src: '/assets/mermaid-8.9.2/mermaid.min.js'
```

### Add the plugin to your Gemfile

To do local [live reloading](https://svrooij.io/2020/12/31/github-pages-live-reload/) you'll need to add the following to your Gemfile.

```Ruby
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
gem "jekyll-github-metadata"
gem "jekyll-octicons"
gem "jemoji"

# This part is added
group :jekyll_plugins do
  gem "jekyll-mermaid"
end
```

## Code your graphs

To see the result, you'll need to add some [flow code](https://mermaid-js.github.io/mermaid/#/n00b-syntaxReference) to your page, like

```Markdown
{% raw %}
{% mermaid %}
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
{% endmermaid %}
{% endraw %}
```
