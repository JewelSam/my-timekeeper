$.ajaxSetup(
  beforeSend: -> $(".loading_div").show()
  complete: -> $(".loading_div").hide()
  error: -> show_error()
  cache: false
)

window.show_error = -> $('#my-error').show()

$ ->
  $('html').on('click', 'body', (e) ->
    if $('.manually-form .input-time').find(e.target).length == 0 then $('.manually-form [datepicker]').hide()
  )
  $('html').click ->
    $('#form_edit_time').css('display','none')
    $('#form_edit_period').css('display','none')

  $('#my-error button').click -> $('#my-error').hide()


