interval_id = 0

$(document).on 'page:change', ->
  if $('.need-save-draft').length
    $('.need-save-draft').each ->
      $(this).val(localStorage.getItem($(this).attr('draft-key')))
      alert($(this).attr('draft-key') + ' : ' + localStorage.getItem($(this).attr('draft-key'))) if localStorage.getItem($(this).attr('draft-key'))

    save_draft_func = ->
      $('.need-save-draft').each ->
        localStorage.setItem($(this).attr('draft-key'), $(this).val()) if interval_id

    interval_id = setInterval(save_draft_func, 15)

$(document).on 'click', '.clean-draft', ->
  clearInterval(interval_id)
  interval_id = 0
  $(this).parents('form').find('.need-save-draft').each ->
    localStorage.removeItem($(this).attr('draft-key'))
