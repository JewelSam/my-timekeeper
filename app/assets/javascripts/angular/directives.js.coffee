App.directive('tabletStyle', -> (scope, element, attrs) -> $(element).bootstrapSwitch())
App.directive('datepicker', -> (scope, element, attrs) -> $(element).datepicker())
App.directive('chartdiv', -> (scope, element, attrs) ->
  $.jqplot(attrs.id,  [[[1, 2],[3,5.12],[5,13.1],[7,33.6],[9,85.9],[11,219.9]]])
)

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

App.directive('focusFirstInput',  -> (scope, element, attrs) ->
  $(element).click -> $(this).find('input:eq(0)').focus()
)