interval_id = 0

$(document).on 'page:change', ->
  if $('.need-save-draft').length
    if interval_id
      clearInterval(interval_id)
      interval_id = 0

    $('.need-save-draft').each ->
      $(this).val(localStorage.getItem($(this).attr('draft-key')))

    save_draft_item = ->
      key = $(this).attr('draft-key')
      localStorage.setItem(key, $(this).val()) if key != '' and $(this).val() != ''
      localStorage.removeItem(key) if $(this).val() == ''

    $('.need-save-draft').each ->
      $(this).blur(save_draft_item)

    save_draft_func = ->
      if interval_id
        $('.need-save-draft').each ->
          $(this).blur()

    interval_id = setInterval(save_draft_func, 15000)

$(document).on 'click', '.clean-draft', ->
  clearInterval(interval_id)
  interval_id = 0
  $(this).parents('form').find('.need-save-draft').each ->
    localStorage.removeItem($(this).attr('draft-key'))
