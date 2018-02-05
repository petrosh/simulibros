login = (div) ->
  logged = false
  # Elements
  container = $ div
  form = container.find 'form'
  link = $ '#login'
  field = form.find '#personalToken'
  submit = form.find '[type="submit"]'
  feedback = form.find '.invalid-feedback'
  # Events
  events = {
    ###
    @function {init} Check if logged and bind modal.link.click and form.submit events
    ###
    init: () ->
      link.attr 'data-placement', "left"
        .on "click", events.modal
      submit.on "click", events.submit
      if storage.get('token') and link.text() == "Login"
        link.text 'Logout'
          .attr 'title', "Logged as #{storage.get('user')}"
          .attr 'data-toggle', 'tooltip'
          .off "click"
          .on "click", events.logout
      true
    get: () ->
      return logged
    ###
    @function {modal} Reset form, show modal, focus field.
    @param {event} Click event.
    ###
    modal: (e) ->
      e.preventDefault()
      events.reset()
      container.modal 'show'
      field.focus()
      true
    ###
    @function {reset} Remove `invalid` class, clear field, enable submit button.
    ###
    reset: () ->
      field.removeClass 'is-invalid'
      field.val ''
      submit.prop 'disabled', false
      true
    ###
    @function {submit} Reset form, focus field, show modal.
    @param {event} Submit event.
    ###
    submit: (e) ->
      e.preventDefault()
      if field.val().length == 40 then events.request() else events.warn 'Invalid token'
      return
    ###
    @function {warn} Display message.
    @param {string} Message.
    ###
    warn: (message) ->
      field.addClass('is-invalid').focus()
      feedback.text message
      return
    ###
    Check GitHub authorizazion (ajax)
    ###
    request: () ->
      field.removeClass 'is-invalid'
      submit.prop 'disabled', true
      $.ajax '{{ site.github.api_url }}/user',
        method: 'GET'
        headers: {"Authorization": "token #{field.val()}"}
        success: events.success
        error: events.error
      true
    error: (request, status, error) ->
      events.warn "#{status}: #{error}"
      submit.prop 'disabled', false
      true
    success: (data, status) ->
      container.modal 'hide'
      logged = true
      storage.set 'token', field.val()
        .set 'user', data.login
        .set 'logged', new Date().getTime()
      link.text 'Logout'
        .attr 'data-original-title', "Logged as #{data.login}"
        .attr 'data-toggle', 'tooltip'
        .tooltip 'show'
        .off "click"
        .on "click", events.logout
      setTimeout ->
        link.tooltip 'hide'
      , 3000
      true
    logout: (e) ->
      e.preventDefault()
      logged = false
      storage.clear()
      $ e.target
        .text 'Login'
        .attr 'data-original-title', "Logged Out"
        .tooltip 'show'
        .off "click"
        .on "click", events.modal
      setTimeout ->
        $ e.target
          .tooltip 'hide'
      , 3000
      true
  }
  events.init()
  true

login div for div in $ '.login-form'
