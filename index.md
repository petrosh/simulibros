---
title: Simulibros
description: Track and Share your readings 📚
---

# Add book `{{ site.github.build_revision | slice: 0, 7 }}`

```liquid
{% raw %}{% include simulibros/form.html data_file='libros.yml' %}{% endraw %}
```

{% include simulibros/form.html data_file='libros.yml' %}
