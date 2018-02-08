form_loading = (element, state) ->
  form = element.parents 'form:first'
  fieldset = form.find 'fieldset'
  results = form.find '[class*=results]'
  if state
    fieldset?.prop {disabled: true}
    results?.html ''
    if element.val()
      element.data 'cache', element.val()
      element.val 'Loading'
    else
      element.data 'cache', element.text()
      element.text 'Loading'
      element.addClass 'disabled'
  else
    fieldset?.prop {disabled: false}
    if element.val()
      element.val element.data 'cache'
    else
      element.text element.data 'cache'
      element.removeClass 'disabled'
  true
