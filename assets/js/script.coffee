---
---
console.log 'jQuery:', try $().jquery catch e then 'none'

{% include_relative any_theme/storage.coffee %}
{% include_relative any_theme/form_loading.coffee %}
{% include_relative any_theme/login.coffee %}
{% include_relative any_theme/simulibros.coffee %}
{% include_relative any_theme/yml_render.coffee %}
{% include_relative any_theme/remove.coffee %}

# Enable tooltips
$ '[data-toggle*=tooltip]'
	.tooltip()
