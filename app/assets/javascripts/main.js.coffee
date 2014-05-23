remove_all_alerts = -> $('form .alert').remove()
show_alert_in_form = ($form, status, message) -> $form.prepend("<div class='alert alert-#{status}'>#{message}</div>")

$ ->
  $('form#sign_in, form#sign_up').submit ->
    console.log 'sdf'
    $(this).ajaxSubmit(
      success: ->
        remove_all_alerts()
#        window.location.reload()
      error: (data) =>
        remove_all_alerts()
        show_alert_in_form($(this), 'error', data.responseText)
    )
    false