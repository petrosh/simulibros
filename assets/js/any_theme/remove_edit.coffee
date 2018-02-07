$('a.edit').on 'click', (e) ->
  e.preventDefault()
  trigger = $ e.target
  file = trigger.data 'file'  
  id = trigger.data 'id'
  error = (request, status, error) ->
    form_loading trigger, 0
    modal_message "get_sha(): #{status} #{error}", 'danger'
    true
  paste_id = (data, status) ->
    for book in YAML.parse(Base64.decode data.content)
      if id == book.id
        $('.widget-simulibros input[type="text"]').each ->
          $(@).val book[$(@).attr 'aria-label']
            .change()
          true
    true
  commit_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{file}"
  # GET /repos/:owner/:repo/contents/:path
  # get file SHA
  $.ajax commit_url,
    method: 'GET'
    headers:
      authorization: "token #{storage.get('token')}"
      accept: "application/vnd.github.v3.full+json"
    success: paste_id
    error: error
  true

$('a.remove').on 'click', (e) ->
  e.preventDefault()
  trigger = $ e.target
  error = (request, status, error) ->
    form_loading trigger, 0
    modal_message "get_sha(): #{status} #{error}", 'danger'
    true
  delete_id = (data, status) ->
    book_array = []
    for book, i in YAML.parse(Base64.decode data.content)
      if id != book.id then book_array.push book
    $.ajax commit_url,
      method: 'PUT'
      headers: "Authorization": "token #{storage.get('token')}"
      data: JSON.stringify {
        message: "Remove item id=#{id} from /_data/#{file}"
        sha: data.sha
        content: Base64.encode(if book_array.length then YAML.stringify book_array, null, 2 else '')
      }
      success: delete_success
      error: error
    true
  delete_success = () ->
    modal_message "Entry removed", 'success'
    trigger.parents 'li'
      .remove()
    true
  form_loading trigger, 1
  id = trigger.data 'id'
  file = trigger.data 'file'
  commit_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{file}"
  # GET /repos/:owner/:repo/contents/:path
  # get file SHA
  $.ajax commit_url,
    method: 'GET'
    headers:
      authorization: "token #{storage.get('token')}"
      accept: "application/vnd.github.v3.full+json"
    success: delete_id
    error: error
  true
