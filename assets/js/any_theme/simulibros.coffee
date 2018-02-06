###
  @function {libros} Search books and fill form
###
libros = (div) ->
  form = $ div
  title = form.find '[aria-label="title"]'
  author = form.find '[aria-label="author"]'
  submit_ol = form.find '[type="submit"]'
  reset = form.find '[type="reset"]'
  results = form.find '.search-results'
  fieldset = form.find 'fieldset'
  append_book = (i, item) ->
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
  search_ol = (string) ->
    form_loading submit_ol, 1
    $.getJSON "http://openlibrary.org/search.json?q=#{string}"
      .done (data) ->
        form_loading submit_ol, 0
        if data.docs.length == 0
          results.append $ "<a href='#' class='no-results'>No results</li>"
        else
          $.each data.docs, append_book
          if results.is(':empty') then results.append $ "<a href='#' class='no-results'>No results</li>"
        true
      .fail (xhr, status, err) ->
        results.append $ "<a href='#' class='no-results'>#{status} #{err}</li>"
        true
    true
  submit_ol_event = (e) ->
    e.preventDefault()
    search_string = $.grep([
        title.val().trim().replace /[\s,]/g, "+"
        author.val().trim().replace /[\s,]/g, "+"
      ], Boolean).join '+'
    if search_string then search_ol search_string
    true
  book_event = (e) ->
    e.preventDefault()
    results.html ''
    data = JSON.parse LZString.decompressFromBase64 $(e.currentTarget).data 'book'
    ['title', 'author', 'year', 'publisher', 'image_url', 'link'].map (field) ->
      form.find("[aria-label='#{field}']").val data[field]
        .change()
      true
    true
  # Init datepicker
  form.find('[type="date"]').datepicker {autoHide: true, zIndex: 2048, format: 'yyyy-mm-dd' }
  # Bind events
  form.on 'submit', submit_ol_event
  reset.on 'click', () -> results.html ''
  results.on "click", "a", book_event
  true

libros div for div in $ '.widget-simulibros'
