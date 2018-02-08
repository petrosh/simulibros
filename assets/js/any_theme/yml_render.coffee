###
@function {yml_renader} Render a form in yaml format and commit changes on GitHub
###
yml_render = (container) ->
  # Define elements
  div = $ container
  yml = div.find 'code'
  copy = div.find '.copy-button'
  commit = div.find '.commit-button'
  commit_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{commit.data('file')}"
  form = div.parents 'form:first'
  # Form events
  form.change () -> render()
  form.on 'reset', () -> reset()
  form.on 'click', '.commit-button', (e) -> get_sha e
  # Clipboard init
  new Clipboard copy[0], { target: () -> yml[0] }
  # Events
  get_sha = (e) ->
    e.preventDefault()
    if !storage.get('token')? then return $('.login-form').modal 'show'
    form_loading commit, 1
    # GET /repos/:owner/:repo/contents/:path
    # get file SHA
    $.ajax commit_url,
      method: 'GET'
      headers:
        authorization: "token #{storage.get('token')}"
        accept: "application/vnd.github.v3.full+json"
      success: update_file
      error: error_sha
    true
  error_sha = (request, status, error) ->
    form_loading commit, 0
    if error == 'Not Found'
      create_file()
    else
      modal_message "get_sha(): #{status} #{error}", 'danger'
    true
  create_file = () ->
    # PUT /repos/:owner/:repo/contents/:path
    # message, content
    $.ajax commit_url,
      method: 'PUT'
      headers: "Authorization": "token #{storage.get('token')}"
      data: JSON.stringify {
        message: "Create /_data/#{commit.data('file')}"
        content: Base64.encode yml.html()
      }
      success: done 'File created'
      error: error
    true
  error = (request, status, error) ->
    form_loading commit, 0
    modal_message "create_file(): #{status} #{error}", 'danger'
    true
  update_file = (data, status) ->
    item_new = YAML.parse(yml.html())[0]
    arr = []
    found = false
    for item in YAML.parse Base64.decode(data.content)
      if item.id == +item_new.id
        found = true
        arr.push item_new
      else arr.push item
    if !found then arr.push item_new
    $.ajax commit_url,
      method: 'PUT'
      headers: "Authorization": "token #{storage.get('token')}"
      data: JSON.stringify {
        message: "Update /_data/#{commit.data('file')}"
        sha: data.sha
        content: Base64.encode(YAML.stringify(arr, null, 2))
      }
      success: done 'File updated'
      error: error
    true
  done = (message) ->
    form_loading commit, 0
    reset()
    modal_message message, 'success'
    true
  reset = () ->
    $(input).val '' for input in form.find '.form-control'
    render()
    true
  get_input = () ->
    obj = {}
    for input in form.find '.form-control'
      key = $(input).attr 'aria-label'
      if $(input).val() != '' and key
        value = $(input).val()
        if $(input).data 'numeric' then value = Number value
        obj[key] = value
    return obj
  render = () ->
    obj = get_input()
    if Object.keys(obj).length
      if !obj.id?
        obj['id'] = Math.round(new Date().getTime() / 1000)
      yml.html YAML.stringify [obj], null, 2
    else yml.html ''
    true

yml_render container for container in $ '.yml-render'
