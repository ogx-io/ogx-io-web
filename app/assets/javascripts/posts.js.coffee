# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  # start to activate post preview process
  $('#post-preview').click ->
    form = $('.post-form').ajaxSubmit({data: {preview: "true"}})
    xhr = form.data('jqxhr')
    xhr.done (content)->
      $('.edit-post-container').hide().after(content)

  $('body').delegate '.fast-reply', 'click', ->
    $(this).parents('.post-container').find('.reply-container').toggleClass('hide')

  # process the two buttons in the preview page
  $('body').delegate '.back-to-editor', 'click', ->
    $('.post-preview-container').remove()
    $('.edit-post-container').show()
  $('body').delegate '.submit-post-form', 'click', ->
    $('.post-form').submit()

  # upload pictures
  $("#post-add-pic").bind "click", () ->
    $(".post-editor").focus()
    $("#post-upload-images").click()
    return false

  $('body').delegate '.toggle-post-comments', 'ajax:beforeSend', ->
    panel = $('#post-'+ $(this).data('post-id') + '-comments')
    if panel.length > 0
      panel.remove()
      return false


  opts =
    url: "/pictures"
    type: "POST"
    beforeSend: () ->
      $("#post-add-pic").hide().before("<span class='loading'>上传中...</span>")
    success: (result, status, xhr) ->
      restoreUploaderStatus()
      if result != ''
        appendImageFromUpload([result])
      else
        alert('您可能上传图片太频繁了')
    error: (result, status, errorThrown) ->
      restoreUploaderStatus()
      alert(errorThrown)
  $("#post-upload-images").fileUpload opts

  appendImageFromUpload = (srcs) ->
    txtBox = $(".post-editor")
    caret_pos = txtBox.caret('pos')
    src_merged = ""
    for src in srcs
      src_merged = "![](#{src})\n"
    source = txtBox.val()
    before_text = source.slice(0, caret_pos)
    txtBox.val(before_text + src_merged + source.slice(caret_pos+1, source.count))
    txtBox.caret('pos',caret_pos + src_merged.length)
    txtBox.focus()

  restoreUploaderStatus = () ->
    $("#post-add-pic").parent().find("span.loading").remove()
    $("#post-add-pic").show()

$(document).ready(ready)
