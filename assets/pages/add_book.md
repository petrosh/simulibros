---
title: Add book
description: Track and Share your readings 📚
permalink: /add_book
---

# Add book

Version: `{{ site.github.build_revision | slice: 0, 7 }}`

```liquid
{% raw %}{% include simulibros/form.html data_file='libros.yml' %}{% endraw %}
```

{% include simulibros/form.html data_file='libros.yml' %}
