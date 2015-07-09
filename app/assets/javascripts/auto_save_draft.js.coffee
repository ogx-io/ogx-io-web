interval_id = 0

save_draft_item = ($item) ->
  key = $item.attr('draft-key') || ''
  if key != ''
    if $item.val() != ''
      localStorage.setItem(key, $item.val())
    else
      localStorage.removeItem(key)

$(document).on 'page:change', ->
  if $('.need-save-draft').length
    if interval_id
      clearInterval(interval_id)
      interval_id = 0

    $('.need-save-draft').each ->
#      alert('ok')
      draft = localStorage.getItem($(this).attr('draft-key')) || ''
      $(this).val(draft) if draft != ''

    save_draft_func = ->
      if interval_id
        $('.need-save-draft').each ->
          save_draft_item($(this))

    interval_id = setInterval(save_draft_func, 15000)

$(document).on 'click', '.clean-draft', ->
  clearInterval(interval_id)
  interval_id = 0
  $(this).parents('form').find('.need-save-draft').each ->
    localStorage.removeItem($(this).attr('draft-key'))

$(document).on 'blur', '.need-save-draft', ->
  save_draft_item($(this))
