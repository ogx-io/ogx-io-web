interval_id = 0

save_draft_item = ($item) ->
  key = $item.attr('draft-key') || ''
  if key != ''
    if $item.val() != ''
      localStorage.setItem(key, $item.val())
    else
      localStorage.removeItem(key)

clean_draft = ($item) ->
  clearInterval(interval_id)
  interval_id = 0
  $item.parents('form').find('.need-save-draft').each ->
    localStorage.removeItem($(this).attr('draft-key'))

$(document).on 'page:change', ->
  if $('.need-save-draft').length
    if interval_id
      clearInterval(interval_id)
      interval_id = 0

    has_draft = false
    $('.need-save-draft').each ->
      draft = localStorage.getItem($(this).attr('draft-key')) || ''
      if draft != ''
        $(this).val(draft)
        has_draft = true

    if not has_draft
      $('#delete-draft-wrapper').hide()

    save_draft_func = ->
      if interval_id
        $('.need-save-draft').each ->
          save_draft_item($(this))

    interval_id = setInterval(save_draft_func, 15000)

    $('#delete-draft').click ->
      clean_draft($(this))
      #disable page scrolling to top after loading page content
      Turbolinks.enableTransitionCache(true)
      # pass current page url to visit method
      Turbolinks.visit(location.toString())
      #enable page scroll reset in case user clicks other link
      Turbolinks.enableTransitionCache(false)

$(document).on 'click', '.clean-draft', ->
  clean_draft($(this))

$(document).on 'blur', '.need-save-draft', ->
  save_draft_item($(this))
