---
title: About
permalink: /about
input_types:
  - color
  - date
  - datetime-local
  - search
  - email
  - month
  - number
  - range
  - tel
  - text
  - textarea
  - time
  - url
  - week
  - submit
  - checkbox
  - radio
---

* toc
{:toc}

## Entry

[`_data/libros.yml`]({% include filters/github_link.html file="_data/libros.yml" %})

```yml
-
  title: 'Binti (Binti, #1)'
  author: 'Nnedi Okorafor'
  image_url: 'https://images.gr-assets.com/books/1433804020l/25667918.jpg'
  year: 2015
  link: 'https://www.goodreads.com/book/show/25667918'
  rating: 4.02
  start_reading: '2017-11-23'
  end_reading: '2017-11-26'
  id: 1518025725
```

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

## Unslug

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

## Input types

- `tel` fallback to `text` but on mobile presents custom keypad
- `datetime` is **obsolete**
- `datetime-local` you can set `min="2017-06-01T08:30" max="2017-06-30T16:30"`
- `email` is validated at submit
- Validity:
  ```css
  input:invalid+span:after {
    position: absolute; content: '✖';
    padding-left: 5px;
  }

  input:valid+span:after {
    position: absolute;
    content: '✓';
    padding-left: 5px;
  }
  ```
  ```html
  <input name="myURL" type="url" required pattern=".*\.myco\..*" title="The URL must be in a Myco domain">
  <span class="validity"></span>
  ```

| Type | Markup | Render |
|--|--|--|{% for t in page.input_types %}
| {{ t }} | <code>&lt;input type=&quot;{{ t }}&quot; value=&quot;{{ t }}&quot; name=&quot;input_type_{{ t }}&quot;&gt;</code> | <input type="{{ t }}" value="{{ t }}" name="input_type_{{ t }}"> |{% endfor %}

<form>
  <input type="url">
  <input type="submit" value="ok">
</form>

## Progress

```liquid
{% raw %}{% include simulibros/progress.html %}{% endraw %}
```

{% include simulibros/progress.html %}

{% include api/get.html file="simulibros/progress.html" %}
