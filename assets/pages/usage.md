---
title: Usage
description: Track and Share your readings 📚
permalink: /usage
---

Version: `{{ site.github.build_revision | slice: 0, 7 }}`

* toc
{:toc}

# Add book

```liquid
{% raw %}{% include simulibros/form.html data_file='libros.yml' %}{% endraw %}
```

{% include simulibros/form.html data_file='libros.yml' %}

# Remove/Edit book

### List

```liquid
{% raw %}{% include simulibros/list.html list=site.data.libros %}{% endraw %}
```

{% include simulibros/list.html list=site.data.libros %}

### Table

```liquid
{% raw %}{% include simulibros/table.html list=site.data.libros %}{% endraw %}
```

{% include simulibros/table.html list=site.data.libros %}
