# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.comment-panel').delegate 'a.reply-comment', 'click', ->
    $parent = $(this).parent()
    if $parent.parent().children('.comment-form').length > 0
      $parent.parent().children().remove('.comment-form')
      return
    $root = $(this).parents('.comment-panel')
    commentable_type = $root.data('commentable-type')
    commentable_id = $root.data('commentable-id')
    parent_id = $(this).parents('.comment-item').data('comment-id')
    $.get "/comments/new?commentable_type=#{commentable_type}&commentable_id=#{commentable_id}&parent_id=#{parent_id}", (content)->
      $parent.parent().children().remove('.comment-form')
      $parent.after content

$(document).ready(ready)
$(document).on('page:load', ready)