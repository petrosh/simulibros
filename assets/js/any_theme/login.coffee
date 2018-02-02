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
    init: () ->
      # Clicks
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

# login1 = {
#   link: $ 'a[href="Login"]'
#   form: $ '#loginModal'
#   field: $ '#personalToken'
#   submit: $ '#submitLogin'
#   feedback: $('#loginModal').find '.invalid-feedback'
#   warn: (message) ->
#     login.field.addClass('is-invalid').focus()
#     login.feedback.text message
#     return
#   reset: () ->
#     login.field.removeClass 'is-invalid'
#     login.field.val ''
#     login.submit.prop 'disabled', false
#     return
#   init: () ->
#     login.link
#       .attr 'data-placement', "left"
#       .on "click", login.modal_event
#     login.submit.on "click", login.submit_event
#     if storage.get('token') and login.link.text() == "Login"
#       login.link
#         .text 'Logout'
#         .attr 'href', 'Logout'
#         .attr 'title', "Logged as #{storage.get('user')}"
#         .attr 'data-toggle', 'tooltip'
#         .off "click", login.modal_event
#         .on "click", login.logout_event
#     true
#   request: () ->
#     login.field.removeClass 'is-invalid'
#     login.submit.prop 'disabled', true
#     $.ajax 'https://api.github.com/user',
#       type: 'GET'
#       headers: {"Authorization": "token #{login.field.val()}"}
#       success: login.success
#       error: login.error
#     true
#   success: (data, status) ->
#     login.form.modal 'hide'
#     login.log = true
#     storage
#       .set 'token', login.field.val()
#       .set 'user', data.login
#       .set 'logged', new Date().getTime()
#     login.link
#       .text 'Logout'
#       .attr 'href', 'Logout'
#       .attr 'title', "Logged as #{data.login}"
#       .attr 'data-toggle', 'tooltip'
#       .tooltip 'show'
#       .off "click", login.modal_event
#       .on "click", login.logout_event
#     setTimeout ->
#       login.link.tooltip 'hide'
#     , 3000
#     true
#   error: (request, status, error) ->
#     login.warn "#{status}: #{error}"
#     login.submit.prop 'disabled', false
#     true
#   logout_event: (e) ->
#     e.preventDefault()
#     login.log = false
#     storage.clear()
#     $ e.target
#       .text 'Login'
#       .attr 'href', 'Login'
#       .attr 'data-original-title', "Logged Out"
#       .tooltip 'show'
#       .off "click", login.logout_event
#       .on "click", login.modal_event
#     setTimeout ->
#       $ e.target
#         .tooltip 'dispose'
#     , 3000
#     true
#   modal_event: (e) -> 
#     e.preventDefault()
#     login.reset()
#     login.form.modal 'show'
#     login.field.focus()
#     true
#   submit_event: (e) ->
#     e.preventDefault()
#     if login.field.val().length == 40 then login.request() else login.warn 'Invalid token'
#     true
# }

# login.init()
for div in $ '.login-form'
  login div
