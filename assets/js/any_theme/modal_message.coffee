modal_message = (message, color = '') ->
  modal = $ '.modal-message'
  content = modal.find '.modal-content'
  if color != '' then content.addClass "border-#{color} text-#{color}"
  title = modal.find '.modal-title'
  title.text message
  modal.modal 'show'
  true
