ready = ->
  $("abbr.timeago").timeago()

$(document).ready(ready)

$(document).on 'click', 'body', ->
  $('.auto-clean').remove()