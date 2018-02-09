$('a.edit').on 'click', (e) ->
  e.preventDefault()
  trigger = $ e.target
  file = trigger.data 'file'  
  id = trigger.data 'id'
  form = $ '.widget-simulibros'
  error = (request, status, error) ->
    form_loading trigger, 0
    modal_message "get_sha(): #{status} #{error}", 'danger'
    true
  paste_id = (data, status) ->
    form_loading trigger, 0
    for book in YAML.parse(Base64.decode data.content)
      if id == book.id
        # Fill form fields with same `aria-label` as book property
        form.find('input[type="text"], input[type="date"]').each ->
          label = $(@).attr 'aria-label'
          $(@).val '' # Reset field
          if book[label]
            $(@).val book[$(@).attr 'aria-label']
              .change()
          true
        # Scroll to form top
        $ 'html, body'
          .animate
            scrollTop: form.offset().top
    true
  # GET /repos/:owner/:repo/contents/:path
  # get file
  form_loading trigger, 1
  commit_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{file}"
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
