$ ->
  $('html').click -> $('#form_edit_time').css('display','none')

  $('#form_edit_time [datepicker]').datepicker('option', 'onSelect', ->
    console.log 'sdf'
#    currentDate = $( "#form_edit_time [datepicker]" ).datepicker( "getDate" )
#    $('#form_edit_time [datepicker]').prev('input').val(currentDate)
  )
