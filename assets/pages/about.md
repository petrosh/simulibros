---
title: About
permalink: /about
---

# Includes

**Storage:**

- `{% include filters/github_link.html file="assets/js/any_theme/storage.coffee" %}`
- <a href="#" id="storage_log">Storage log</a>

**Login:**

- `{% include filters/github_link.html file="_includes/login.html" %}`
- `{% include filters/github_link.html file="assets/js/any_theme/login.coffee" %}`

**Simulibros:**

- `{% include filters/github_link.html file="_includes/simulibros/form.html" %}`
- `{% include filters/github_link.html file="_includes/simulibros/search.html" %}`
- `{% include filters/github_link.html file="_includes/simulibros/results.html" %}`
- `{% include filters/github_link.html file="assets/js/any_theme/simulibros.coffee" %}`

**Progress:**

{% include simulibros/progress.html now="21" %}

**Apis:**

```liquid
{% raw %}{% include api/get.html file="simulibros/progress.html" %}{% endraw %}
```

{% include api/get.html file="simulibros/progress.html" %}
{% include api/get.html file="filters/unslug.html" %}
