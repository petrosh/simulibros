###
  @function {libros} Search books and fill form
###
libros = (div) ->
  form = $ div
  title = form.find '[aria-label="title"]'
  author = form.find '[aria-label="author"]'
  submit_ol = form.find '[aria-label="search_openlibrary"]'
  submit_gr = form.find '[aria-label="search_goodreads"]'
  reset = form.find '[type="reset"]'
  results = form.find '.search-results'
  fieldset = form.find 'fieldset'
  goodreads = $ form.next '.goodreads-form'
  goodreads_key = $ '#goodreadsKey'
  cors_url = "https://cors-anywhere.herokuapp.com/"
  new_cors = "https://afternoon-hollows-35729.herokuapp.com/"
  parsedHash = new URLSearchParams atob(new URLSearchParams(location.search).get('a'))
  ['title','author','year','rating','publisher','link','image_url'].map (x) => $("[aria-label='#{x}']").val parsedHash.get(x)
  title.trigger 'change'
  search_function = (e) ->
    if storage.get 'goodreads_key' then search_gr(e) else search_ol(e)
  $('#submitGoodreads').click (e) ->
    e.preventDefault()
    if goodreads_key.val()
      storage.set 'goodreads_key', goodreads_key.val()
      search_function = (e) -> search_gr(e)
    true
  submit_ol.click (e) ->
    e.preventDefault()
    search_string = get_search_string()
    if search_string then search_ol search_string
    true
  submit_gr.click (e) ->
    e.preventDefault()
    if storage.get 'goodreads_key'
      search_string = get_search_string()
      if search_string then search_gr search_string
    else
      goodreads.modal 'show'
    true
  append_book_ol = (i, item) ->
    # Parse book properties
    book = {
      title: item.title
      author: if item.author_name? then item.author_name.join ', ' else null
      image_url: if item.cover_edition_key?
          "http://covers.openlibrary.org/b/olid/#{item.cover_edition_key}-M.jpg"
        else null
      year: item.first_publish_year ?
        if item.publish_year? then item.publish_year[0] else item.publish_date ? null
      publisher: if item.publisher? then item.publisher[0] else ''
      olid: item.cover_edition_key ? item.edition_key ? null
    }
    # Append data to template
    if book.olid?
      book.link = "https://openlibrary.org/books/#{book.olid}"
      result = $ '<a>',
        'href': book.link
        'data-book': LZString.compressToBase64 JSON.stringify book
        'html': $('#template-book').html()
      ['title', 'author', 'year', 'publisher', 'link'].map (field) ->
        result.find(".libros-#{field}").text book[field]
      if book.image_url
        result.find('.libros-image-container')
          .addClass 'col-2'
          .append $ '<img>', {
            src: book.image_url
            alt: book.title
          }
      # Append book to results
      results.append result
    true
  search_error = (request, status, error) ->
    # form_loading commit, 0
    console.log request
    modal_message "search_gr/ol(): #{status} #{error}", 'danger'
    true
  append_book_gr = (i, item) ->
    item = $ item
    book = {
      author: item.find('best_book author name').text()
      title: item.find('best_book title').text()
      image_url: item.find('best_book image_url').text()
      rating: item.find('average_rating').text()
      link: "https://www.goodreads.com/book/show/#{item.find('best_book > id:first-child').text()}"
      year: item.find('original_publication_year').text()
    }
    result = $ '<a>',
      'href': book.link
      'data-book': LZString.compressToBase64 JSON.stringify book
      'html': $('#template-book').html()
    ['title', 'author', 'year', 'rating', 'link'].map (field) ->
      result.find(".libros-#{field}").text book[field]
    if book.image_url
      result.find('.libros-image-container')
        .addClass 'col-2'
        .append $ '<img>', {
          src: book.image_url
          alt: book.title
        }
    # Append book to results
    results.append result
    true
  gr_success = (xml) ->
    form_loading submit_gr, 0
    if $(xml).find('total-results').text() != '0'
      $.each $(xml).find('work'), append_book_gr
    else results.append $ "<a href='#' class='no-results'>No results</li>"
    true
  search_gr = (string) ->
    form_loading submit_gr, 1
    $.ajax {
      url: "#{new_cors}https://www.goodreads.com/search.xml?key=#{storage.get 'goodreads_key'}&q=#{string}"
      headers:
        "Access-Control-Allow-Origin": "*"
        "Access-Control-Allow-Credentials": "true"
      dataType: "xml"
      success: gr_success
      error: search_error
    }
    true
  search_ol = (string) ->
    form_loading submit_ol, 1
    $.getJSON "http://openlibrary.org/search.json?q=#{string}"
      .done (data) ->
        form_loading submit_ol, 0
        if data.docs.length == 0
          results.append $ "<a href='#' class='no-results'>No results</li>"
        else
          $.each data.docs, append_book_ol
          if results.is(':empty') then results.append $ "<a href='#' class='no-results'>No results</li>"
        true
      .fail (xhr, status, err) -> search_error
    true
  get_search_string = ->
    $.grep([
        title.val().trim().replace /[\s,]/g, "+"
        author.val().trim().replace /[\s,]/g, "+"
      ], Boolean).join '+'
  # submit = (e) ->
  #   e.preventDefault()
  #   search_string = get_search_string
  #   if search_string then search_function search_string
  #   true
  book_event = (e) ->
    e.preventDefault()
    results.html ''
    data = JSON.parse LZString.decompressFromBase64 $(e.currentTarget).data 'book'
    form.find("input[type='text']").each ->
      $(@).val data[$(@).attr 'aria-label']
        .change()
      true
    true
  # Init datepicker
  form.find('[type="date"]').datepicker {autoHide: true, zIndex: 2048, format: 'yyyy-mm-dd' }
  # Bind events
  # form.on 'submit', submit
  form.find('[aria-label="title"],[aria-label="author"]').keypress (e) -> if e.which == 13
    search_string = get_search_string()
    if search_string then search_function search_string
  reset.on 'click', -> results.html ''
  results.on "click", "a", book_event
  true

libros div for div in $ '.widget-simulibros'
