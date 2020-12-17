do check_build = ->
  if storage.get('token')
    head_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/git/refs/heads/master?time=#{new Date().getTime()}"
    $.ajax head_url,
      method: 'GET'
      headers:
        authorization: "token #{storage.get('token')}"
        accept: "application/vnd.github.v3.full+json"
      success: (data, status) ->
        real_build = data.object.sha.slice 0,7
        if real_build != "{{ site.github.build_revision | slice: 0, 7 }}"
          badge = $ '#build_badge'
          badge.addClass "badge-danger"
          badge.html 'NOT UPDATED'
        return
      error: (request, status, error) -> console.log request, status, error
  true
