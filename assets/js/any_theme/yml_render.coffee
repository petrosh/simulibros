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
  # Clipboard init
  new Clipboard copy[0], { target: () -> yml[0] }
  # Events
  commit.on 'click', (e) ->
    e.preventDefault()
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
    if error == 'Not Found' then create_file()
    form_loading commit, 0
    console.log status, error
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
      success: done
      error: error
    true
  error = (request, status, error) ->
    form_loading commit, 0
    console.log status, error
  update_file = (data, status) ->
    $.ajax commit_url,
      method: 'PUT'
      headers: "Authorization": "token #{storage.get('token')}"
      data: JSON.stringify {
        message: "Update /_data/#{commit.data('file')}"
        sha: data.sha
        content: Base64.encode(Base64.decode data.content + yml.html())
      }
      success: done
      error: error
    true
  done = () ->
    form_loading commit, 0
    reset()
    console.log 'done'
  reset = () ->
    $(input).val '' for input in form.find '.form-control'
    update()
    true
  render = () ->
    obj = {}
    for input in form.find '.form-control'
      key = $(input).attr 'aria-label'
      if $(input).val() != '' and key then obj[key] = $(input).val()
    if Object.keys(obj).length
      if !obj.id?
        obj['id'] = Math.round(new Date().getTime() / 1000)
      yml.html YAML.stringify [obj]
    else yml.html ''
    true

yml_render container for container in $ '.yml-render'
