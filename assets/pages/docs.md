---
title: Docs
description: Track and Share your readings 📚
permalink: /docs
---

Varsion: `{{ site.github.build_revision | slice: 0, 7 }}`

* toc
{:toc}

# Add book

```liquid
{% raw %}{% include simulibros/form.html data_file='libros.yml' %}{% endraw %}
```

{% include simulibros/form.html data_file='libros.yml' %}

# Remove book

```liquid
{% raw %}{% include simulibros/list.html list=site.data.libros %}{% endraw %}
```

{% include simulibros/list.html list=site.data.libros %}
