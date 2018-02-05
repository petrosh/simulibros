remove_id = (link) ->
  trigger = $ link
  id = trigger.data 'id'
  file = trigger.data 'file'
  commit_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{file}"
  get_sha = (e) ->
    e.preventDefault()
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
  error = (request, status, error) ->
    form_loading trigger, 0
    console.log status, error
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
        content: Base64.encode(YAML.stringify book_array, null, 2)
      }
      success: done
      error: error
    true
  done = () ->
    true
  trigger.on "click", get_sha
  true

remove_id link for link in $ 'a.remove'
