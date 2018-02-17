###
@function {yml_renader} Render a form in yaml format and commit changes on GitHub
###
yml_render = (container) ->
  # Define elements
  message = ''
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
  # get file SHA
  get_sha = (e) ->
    e.preventDefault()
    render() # Get focused fields
    if !storage.get('token')? then return $('.login-form').modal 'show'
    form_loading commit, 1
    # GET /repos/:owner/:repo/contents/:path
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
  ###  
  Create new file
  @param message {string}
  @param content {string}
  ###
  create_file = () ->
    item_new = YAML.parse(yml.html())[0] # Parse new item from yaml widget area
    message = "Created file with #{item_new.title} by #{item_new.author}"
    # PUT /repos/:owner/:repo/contents/:path
    $.ajax commit_url,
      method: 'PUT'
      headers: "Authorization": "token #{storage.get('token')}"
      data: JSON.stringify {
        message: message
        content: Base64.encode yml.html()
      }
      success: file_created
      error: error
    true
  error = (request, status, error) ->
    form_loading commit, 0
    modal_message "create_file(): #{status} #{error}", 'danger'
    true
  update_file = (data, status) ->
    item_new = YAML.parse(yml.html())[0] # Parse new item from yaml widget area
    message = "#{item_new.title} by #{item_new.author}"
    arr = []
    found = false
    # Loop items to replace if one has same ID
    for item in YAML.parse Base64.decode(data.content)
      if item.id == +item_new.id
        found = true
        arr.push item_new
        message = "Modifyed #{message}"
      else arr.push item
    # If ID not found, append new item
    if !found
      arr.push item_new
      message = "Added #{message}"
    # Commit
    $.ajax commit_url,
      method: 'PUT'
      headers: "Authorization": "token #{storage.get('token')}"
      data: JSON.stringify {
        message: message
        sha: data.sha
        content: Base64.encode(YAML.stringify(arr, null, 2))
      }
      success: file_updated
      error: error
    true
  file_updated = (data, status) ->
    check_commit data
    done message
    true
  file_created = (data, status) ->
    check_commit data
    done message
    true
  check_commit = (data) ->
    # Check commit
    storage.set 'update_sha', data.sha
    console.log data.sha
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
      $(input).blur()
      label = $(input).attr 'aria-label'
      if $(input).val() != '' and label
        value = $(input).val()
        if $(input).data 'numeric' then value = Number value
        obj[label] = value
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
