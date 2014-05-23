App.directive('tabletStyle', -> (scope, element, attrs) -> $(element).bootstrapSwitch())
App.directive('datepicker', -> (scope, element, attrs) -> $(element).datepicker())

App.directive('showFormEditTime', -> (scope, element, attrs) ->
  $(element).on('click', (e) ->
    position = $(this).offset();
    $('#form_edit_time').css('position','absolute').css('left',position.left + $(this).outerWidth( true ) - 295).css('top',position.top +  $(this).outerHeight(true)).css('display','block')
    $('#form_edit_time').click (event) -> event.stopPropagation()
    e.stopPropagation();
  )
)
App.directive('showDatepicker', -> (scope, element, attrs) ->
  $(element).on('focus', -> $('.manually-form [datepicker]').show() )
)