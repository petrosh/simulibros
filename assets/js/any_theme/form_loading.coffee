form_loading = (element, state) ->
  form = element.parents 'form:first'
  fieldset = form.find 'fieldset'
  results = form.find '[class*=results]'
  if state
    fieldset.prop {disabled: true}
    results.html ''
    element.data 'cache', element.val()
    element.val 'Loading'
  else
    fieldset.prop {disabled: false}
    element.val element.data 'cache'
  true
