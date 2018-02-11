---
title: About
permalink: /about
---

* toc
{:toc}

## Includes

#### Apis

```liquid
{% raw %}{% include api/get.html file="simulibros/progress.html" %}{% endraw %}
```

{% include api/get.html file="simulibros/progress.html" %}

{% include simulibros/progress.html now="21" %}

{% include api/get.html file="filters/unslug.html" %}

#### Storage

- `{% include filters/github_link.html file="assets/js/any_theme/storage.coffee" %}`
- <a href="#" id="storage_log">Storage log</a>

#### Login

- `{% include filters/github_link.html file="_includes/login.html" %}`
- `{% include filters/github_link.html file="assets/js/any_theme/login.coffee" %}`

#### Simulibros

- `{% include filters/github_link.html file="_includes/simulibros/form.html" %}`
- `{% include filters/github_link.html file="_includes/simulibros/search.html" %}`
- `{% include filters/github_link.html file="_includes/simulibros/results.html" %}`
- `{% include filters/github_link.html file="assets/js/any_theme/simulibros.coffee" %}`

## Assets

|Name|Repository|Js|Css|
|--|--|--|--|{% for asset in site.assets %}
| **{{ asset.name }}** | [{{ asset.repository | replace: 'https://github.com/', '' | replace: '/', ' / **' | append: '**' }}]({{ asset.repository }}) | `{{ asset.js | split: '/' | last }}` | `{{ asset.css | split: '/' | last }}` |{% endfor %}
