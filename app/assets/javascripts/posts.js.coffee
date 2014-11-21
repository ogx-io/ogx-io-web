# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.set-elite').bind 'ajax:success', (e, data)->
    if data['elite'] == 1
      $(this).parents(".post-detail").find(".elite-mark").show()
      $(this).text('取消精华')
    if data['elite'] == 0
      $(this).parents(".post-detail").find(".elite-mark").hide()
      $(this).text('设为精华')

$(document).ready(ready)
$(document).on('page:load', ready)