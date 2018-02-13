---
title: About
permalink: /about
---

* toc
{:toc}

## Apis

Add this snippet at the top of files in any `/_includes` file and fill it in with the api.

```md{% raw %}
{% capture api %}
Description

**Usage**

{% include api/example.html param1=1 param2=2 %}

**Return**

<!-- Result -->

{% endcapture %}
{% capture param %}
param1|type|description|default value
param2|type|description|default value
{% endcapture %}
{% include api/save.html %}{% endraw %}
```

To render an api, include `api/get.html` along with the target include file path as a `file` parameter, witch default to `/_includes/api/example.html`.

```liquid
{% raw %}{% include api/get.html %}{% endraw %}
```

{% include api/get.html %}

**Example**

```liquid
{% raw %}{% include api/get.html file="simulibros/progress.html" %}{% endraw %}
```

{% include api/get.html file="simulibros/progress.html" %}

**Example**

```liquid
{% raw %}{% include simulibros/progress.html %}{% endraw %}
```

{% include simulibros/progress.html %}

{% include api/get.html file="filters/unslug.html" %}

## Storage

- `{% include filters/github_link.html file="assets/js/any_theme/storage.coffee" %}`
- <a href="#" id="storage_log">Storage log</a>

## Login

- `{% include filters/github_link.html file="_includes/login.html" %}`
- `{% include filters/github_link.html file="assets/js/any_theme/login.coffee" %}`

## Simulibros

- `{% include filters/github_link.html file="_includes/simulibros/form.html" %}`
- `{% include filters/github_link.html file="_includes/simulibros/search.html" %}`
- `{% include filters/github_link.html file="_includes/simulibros/results.html" %}`
- `{% include filters/github_link.html file="assets/js/any_theme/simulibros.coffee" %}`

{% include api/get.html file="components/assets.html" %}

**Example**

```liquid
{% raw %}{% include components/assets.html %}{% endraw %}
```

{% include components/assets.html %}
