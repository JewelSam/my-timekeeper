App.directive('tabletStyle', -> (scope, element, attrs) -> $(element).bootstrapSwitch())
App.directive('datepicker', -> (scope, element, attrs) -> $(element).datepicker())
App.directive('showFormEditTime', -> (scope, element, attrs) ->
  $(element).on('click', (e) ->
    $('#form_edit_time').css('position','fixed').css('left',e.clientX-300).css('top',e.clientY+10).css('display','block')
#    $('html').on('click', -> $('#form_edit_time').css('display','none') )
  )
)