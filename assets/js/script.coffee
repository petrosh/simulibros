---
---
console.log 'jQuery:', try $().jquery catch e then 'none'

OWNER_NAME = '{{site.github.owner_name}}'
PROJECT_NAME = '{{site.github.project_title}}'
BUILD_REVISION = '{{ site.github.build_revision }}'

{% include_relative any_theme/storage.coffee %}
{% include_relative any_theme/modal_message.coffee %}
{% include_relative any_theme/form_loading.coffee %}
{% include_relative any_theme/login.coffee %}
{% include_relative any_theme/simulibros.coffee %}
{% include_relative any_theme/yml_render.coffee %}
{% include_relative any_theme/remove_edit.coffee %}

# Enable tooltips
$ '[data-toggle*="tooltip"]'
	.tooltip()
