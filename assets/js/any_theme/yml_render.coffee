for container in $ '.yml-render'
  div = $ container
  yml = div.find 'code'
  copy = div.find '.copy-button'
  commit = div.find '.commit-button'
  obj = {}
  form = div.parents 'form:first'
  form.change () -> update()
  # form.on 'reset', () ->
  #   form.find('.form-control').val('').change()
  #   true
  new Clipboard copy[0], { target: () -> yml[0] }
  commit.on 'click', (e) ->
    e.preventDefault()
    console.log commit.data 'file'
    true
  update = () ->
    for input in form.find '.form-control'
      key = $(input).attr 'aria-label'
      if $(input).val() and key then obj[key] = $(input).val()
    yml.html YAML.stringify [ obj ]
  true
