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

<div class="mermaid">
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
</div>

## Use Mermaid-js in Github Pages

To use it in Github Pages (or Jekyll), you'll need to do some extra config.

### Download the latest release

Go to [mermaid-js release page](https://github.com/mermaid-js/mermaid/releases) and download the latest release.

### Add javascript files to project

I downloaded [Mermaid-js 8.9.2](https://github.com/mermaid-js/mermaid/releases/tag/8.9.2) release, and just took the `dist\mermaid.min.js` and `dist\mermaid.min.js.map` and copied them to `assets\mermaid-8.9.2` (new) folder in my Jekyll project.

## Code your graphs

To see the result, you'll need to add some [flow code](https://mermaid-js.github.io/mermaid/#/n00b-syntaxReference) to your page, like

```Markdown
{% raw %}
<div class="mermaid">
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
</div>
{% endraw %}
```

### Add the javascript file to your page

You're then left to add the javascript to your page, you'll only have to do this once. And you can do it anywhere. Add it to your main template if you draw a lot of flows or just to the pages where you want a flow.

```Markdown
{% raw %}
<script src="/assets/mermaid-8.9.2/mermaid.min.js"></script>
{% endraw %}
```

<script src="{{ "/assets/mermaid-8.9.2/mermaid.min.js" | relative_url }}"></script>
