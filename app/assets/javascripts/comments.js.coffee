# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('body').delegate '.comment-panel a.reply-comment', 'click', ->
    $(this).parent().parent().next().next().find('.comment-form').toggleClass('hide').find('.comment-form-body').focus()

  $('body').delegate '.comment-form-body', 'keyup change input', ->
    $(this).parent().next().find(".tips .left-number").text(200 - $(this).val().length)
  $('.comment-form').find(".comment-form-body").trigger("keyup")

$(document).ready(ready)
