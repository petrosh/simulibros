remove_id = (link) ->
  trigger = $ link
  id = trigger.data 'id'
  file = trigger.data 'file'
  commit_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{file}"
  get_sha = (e) ->
    console.log e
    e.preventDefault()
    form_loading trigger, 1
    # GET /repos/:owner/:repo/contents/:path
    # get file SHA
    $.ajax commit_url,
      method: 'GET'
      headers:
        authorization: "token #{storage.get('token')}"
        accept: "application/vnd.github.v3.full+json"
      success: delete_file
      error: error
    true
  error = (request, status, error) ->
    form_loading trigger, 0
    console.log status, error
  delete_file = (data, status) ->
    # delete a file: path, message, sha
    # DELETE /repos/:owner/:repo/contents/:path
    $.ajax commit_url,
      method: 'DELETE'
      headers: "Authorization": "token #{storage.get('token')}"
      data: JSON.stringify {
        message: "Remove item id=#{id} from /_data/#{file}"
        sha: data.sha
      }
      success: done
      error: error
    true
  done = () ->
    form_loading trigger, 0
    true
  trigger.on "click", get_sha
  true

remove_id link for link in $ 'a.remove'
