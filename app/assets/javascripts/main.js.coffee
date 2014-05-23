remove_all_alerts = -> $('form .alert').remove()
show_alert_in_form = ($form, status, message) -> $form.prepend("<div class='alert alert-#{status}'>#{message}</div>")

$ ->
  $('form#sign_in').submit ->
    $(this).ajaxSubmit(
      success: (data, textStatus, jqXHR) ->
        remove_all_alerts()
        window.location.reload()
      error: (data) =>
        remove_all_alerts()
        show_alert_in_form($(this), 'error', data.responseText)
    )
    false

  $('form#sign_up').submit ->
    $(this).ajaxSubmit(
      success: (data, textStatus, jqXHR) ->
        remove_all_alerts()
        console.log $(data)

        if $(data).filter('div.boxed').children('ng-view').length > 0
          window.location.reload()
        else
          $(data).filter('div.boxed').find('form#new_user #error_explanation li').each ->
            message = $(this).html()
            show_alert_in_form($('form#sign_up'), 'error', message)
      error: (data) =>
        remove_all_alerts()
        show_alert_in_form($(this), 'error', data.responseText)
    )
    false