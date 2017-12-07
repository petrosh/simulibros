---
---
console.log 'jQuery:', try $().jquery catch e then 'none'

load = (ol_key) ->
	console.log ol_key

olRequest = () ->
	search_string = $.grep([
		$('#input-title').val().trim().replace /\s/g, "+"
		$('#input-author').val().trim().replace /\s/g, "+"
	], Boolean).join '+'
	if search_string
		# beforeSend
		$("#ol-results").html ''
		$("#ol-search").prop {disabled: true}
		cache = $("#ol-search").text()
		$("#ol-search").text "Loading"
		# Ajax
		$.getJSON "http://openlibrary.org/search.json?q=#{search_string}", (data) ->
			# Completed
			$("#ol-search").prop {disabled: false}
			$("#ol-search").text cache
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

$ '#ol-search'
	.on "click", olRequest
	
$ '#input-title, #input-author'
	.keypress (e) -> if e.which == 13 then olRequest()

$ '#ol-results'
	.on "click", "a", (e) ->
		e.preventDefault()
		$("#ol-results").html ''
		ol_key = this.href.match(/([^\/]*)\/*$/)[1]
		$.getJSON "http://openlibrary.org/api/books?bibkeys=#{ol_key}&format=json&jscmd=data", (data) ->
			book = data[ol_key]
			$("#input-author").val book.authors.map (a) -> return a.name
			$("#input-title").val book.title
			$("#input-publishers").val book.publishers.map (p) -> return p.name
			$("#input-publish_year").val book.publish_date
			$("#input-edition_key").val book.identifiers.openlibrary[0]
			$("#input-isbn").val book.identifiers.isbn_10[0]
			$("#input-cover").val book.cover.medium || ''