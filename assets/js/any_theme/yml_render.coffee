for container in $ '.yml-render'
  # Define elements
  div = $ container
  yml = div.find 'code'
  copy = div.find '.copy-button'
  commit = div.find '.commit-button'
  commit_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{commit.data('file')}"
  form = div.parents 'form:first'
  # Form events
  form.change () -> update()
  form.on 'reset', () -> reset()
  # Clipboard init
  new Clipboard copy[0], { target: () -> yml[0] }
  # Events
  error_create = (request, status, error) ->
    console.log status, error
  success_sha = (data, status) ->
    # PUT /repos/:owner/:repo/contents/:path
    # post: message, content, SHA
    console.log 'put!', data, data.sha, b64d data.content
    content = YAML.parse b64d data.content
    console.log content
    # $.ajax commit_url,
    #   method: 'PUT'
    #   headers: "Authorization": "token #{storage.get('token')}"
    #   data:
    #     message: "Update /_data/#{commit.data('file')}"
    #     sha: data.sha
    #     content: b64e ''
    #   success: success_sha
    #   error: error_create
    true
  error_sha = (request, status, error) ->
    if error == 'Not Found' then create_file()
    console.log status, error
  create_file = () ->
    # PUT /repos/:owner/:repo/contents/:path
    # message, content
    $.ajax commit_url,
      method: 'PUT'
      headers:
        "Authorization": "token #{storage.get('token')}"
        "Accept": "application/vnd.github.v3+raw"
      data:
        "message": "Create /_data/#{commit.data('file')}"
        "content": b64e 'bad request?'
        "path": "_data/#{commit.data('file')}"
      success: success_sha
      error: error_create
    true
  commit.on 'click', (e) ->
    e.preventDefault()
    # GET /repos/:owner/:repo/contents/:path
    # get file SHA
    $.ajax commit_url,
      method: 'GET'
      headers: "Authorization": "token #{storage.get('token')}"
      success: success_sha
      error: error_sha
    true
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
