###
  Store `storage` object in `localStorage`, LZ compressed to Base 64.
  @example
  // Initialize storage in localStorage
  storage.init()
  @example
  // Get a key's value or whole object
  storage.get([key])
  @example
  // Set a value for a key
  storage.set(key, value)
  @example
  // Remove a key value pair or clear whole object
  storage.clear([key])
###
storage = {
  init: () ->
    if !localStorage.getItem("storage")? then storage.store { "created": new Date().getTime() }
    # $('a[href="Show"]').on "click", (e) ->
    #   e.preventDefault()
    #   console.log storage.get()
    #   true
    $ '#storage_log'
      .off "click"
      .on "click", (e) ->
        e.preventDefault()
        console.log storage.get()
        true
    true
  clear: (key) ->
    obj = storage.get()
    if key?
      delete obj[key]
      storage.store obj
      true
    else
      localStorage.removeItem 'storage'
      true
  set: (key, value) ->
    if !localStorage.getItem("storage")? then storage.init()
    obj = storage.get()
    if key? and value?
      obj[key] = value
      storage.store obj
      return storage
    else
      false
  get: (key) ->
    if !localStorage.getItem("storage")? then storage.init()
    if key?
      storage.get()[key]
    else
      JSON.parse LZString.decompressFromBase64 localStorage.getItem "storage"
  store: (obj) ->
    localStorage.setItem 'storage', LZString.compressToBase64 JSON.stringify obj
}

storage.init()
