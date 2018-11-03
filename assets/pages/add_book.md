---
title: Add book
description: Track and Share your readings 📚
permalink: /add_book
---

# Add book

```liquid
{% raw %}{% include simulibros/form.html data_file='libros.yml' %}{% endraw %}
```

{% include simulibros/form.html data_file='libros.yml' %}

# List

```liquid
{% raw %}{% include simulibros/list.html list=site.data.libros %}{% endraw %}
```

{% include simulibros/list.html list=site.data.libros %}
