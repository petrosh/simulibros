loading = (s) ->
	results = $ "#ol-results"
	search = $ "#ol-search"
	if s
		# Clear results
		results.html ''
		# Clear input valid
		# Change button state
		search.prop {disabled: true}
		search.attr("data-cache", search.text() )
		search.text "Loading"
	else
		search.prop {disabled: false}
		search.text search.attr "data-cahce"
	return

olRequest = () ->
	search_string = $.grep([
		$('#input-title').val().trim().replace /\s/g, "+"
		$('#input-author').val().trim().replace /\s/g, "+"
	], Boolean).join '+'
	if search_string
		# Loading
		loading(1)
		# Ajax
		$.getJSON "http://openlibrary.org/search.json?q=#{search_string}", (data) ->
			# Completed
			loading(0)
			# Check no data
			if data.docs.length == 0
				$("#ol-results").append $ "<li class='list-group-item'>No results</li>"
			# Loop data
			$.each data.docs, (i, item) ->
				li = $ "<li class='list-group-item'>
					<p class='text-truncate mb-0 font-weight-bold'><a href='#{item.cover_edition_key || item.edition_key.pop()}'>#{item.title}</a></p>
					#{item.author_name || ''}<br>
					<p class='text-muted small text-truncate mb-0'>(#{item.publish_year}) #{item.publisher || ''}</p>
				</li>"
				$("#ol-results").append li
				return
			return
	return

$ '#ol-results'
	.on "click", "a", (e) ->
		e.preventDefault()
		loading 1
		ol_key = this.href.match(/([^\/]*)\/*$/)[1]
		$.getJSON "http://openlibrary.org/api/books?bibkeys=#{ol_key}&format=json&jscmd=data", (data) ->
			loading 0
			book = data[ol_key]
			$("#input-author").val book.authors.map (a) -> return a.name
				.addClass "is-valid"
			$ "#input-title"
				.val book.title
					.addClass "is-valid"
			$("#input-publishers").val book.publishers.map (p) -> return p.name
				.addClass "is-valid"
			$("#input-publish_year").val book.publish_date
				.addClass "is-valid"
			$("#input-edition_key").val book.identifiers.openlibrary[0]
				.addClass "is-valid"
			$("#input-isbn").val book.identifiers.isbn_10[0]
				.addClass "is-valid"
			$("#input-cover").val book.cover.medium || ''
				.addClass "is-valid"

$ () ->
	# Initialize datepicker
	$('[data-toggle="datepicker"]').datepicker {
		autoHide: true
		zIndex: 2048
		format: 'yyyy-mm-dd'
	}
	# Enable currecy button
	if $('#button-currency').length and $('a[data-currency]').length
		$ 'a[data-currency]'
			.on "click", (e) ->
				new_currency = $(e.target).attr "data-currency"
				$('#button-currency').text $('#button-currency').text().slice(0, -1) + new_currency
	# Openlibrary request
	# olRequest onclick
	$ '#ol-search'
		.on "click", olRequest
	# olRequest input ENTER
	$ '#input-title, #input-author'
		.keypress (e) -> if e.which == 13 then olRequest()
	return
