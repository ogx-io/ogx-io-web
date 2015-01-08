# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('#post-preview').click ->
    form = $('.post-form').ajaxSubmit({data: {preview: "true"}})
    xhr = form.data('jqxhr')
    xhr.done (content)->
      $('.edit-post-container').hide().after(content)

  $('body').delegate '.back-to-editor', 'click', ->
    $('.post-preview-container').remove()
    $('.edit-post-container').show()
  $('body').delegate '.submit-post-form', 'click', ->
    $('.post-form').submit()

$(document).ready(ready)
$(document).on('page:load', ready)