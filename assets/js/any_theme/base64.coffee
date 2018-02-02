b64e = (str) ->
  btoa encodeURIComponent(str).replace(/%([0-9A-F]{2})/g, (match, p1) -> String.fromCharCode "0x#{p1}")

b64d = (str) ->
  decodeURIComponent Array.prototype.map.call(atob(str), (c) -> '%' + c.charCodeAt(0).toString(16)).join ''
