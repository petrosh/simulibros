for container in $ '.yml-render'
  # Define elements
  div = $ container
  yml = div.find 'code'
  copy = div.find '.copy-button'
  commit = div.find '.commit-button'
  form = div.parents 'form:first'
  # Form events
  form.change () -> update()
  form.on 'reset', () -> reset()
  # Clipboard init
  new Clipboard copy[0], { target: () -> yml[0] }
  # Events
  commit.on 'click', (e) ->
    e.preventDefault()
    # GET /repos/:owner/:repo/contents/:path
    # get file SHA
    $.ajax "{{ site.github.api_url }}/{{ site.github.repository_nwo }}/contents/_data/#{commit.data('file')}",
      method: 'GET'
      headers: {"Authorization": "token #{storage.get('token')}"}
      success: events.success
      error: events.error
    true
    # PUT /repos/:owner/:repo/contents/:path
    # post: message, content, SHA
    console.log commit.data 'file'
    true
  success = (data, status) ->
    console.log data
  error: (request, status, error) ->
    # events.warn "#{status}: #{error}"
    # submit.prop 'disabled', false
    # true
    console.log status, error
  reset = () ->
    $(input).val '' for input in form.find '.form-control'
    update()
    true
  update = () ->
    obj = {}
    for input in form.find '.form-control'
      key = $(input).attr 'aria-label'
      if $(input).val() != '' and key then obj[key] = $(input).val()
    yml.html if Object.keys(obj).length then YAML.stringify [obj] else ''
    true
  true
