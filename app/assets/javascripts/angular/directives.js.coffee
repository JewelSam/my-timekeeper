App.directive('tabletStyle', -> (scope, element, attrs) -> $(element).bootstrapSwitch())
App.directive('datepicker', -> (scope, element, attrs) -> $(element).datepicker())

App.directive('daterangepicker', ->
  scope:
    start: '='
    finish: '='
    getdata: '&'
  link: (scope, element, attrs) ->
    $(element).val("#{moment().startOf('week').format('L')} - #{moment().endOf('week').format('L')}")

    $(element).daterangepicker(
      startDate: moment().startOf('week'),
      endDate: moment().endOf('week')
      ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
        'This week': [moment().startOf('week'), moment().endOf('week')],
        'Last week': [moment().subtract('week', 1).startOf('week'), moment().subtract('week', 1).endOf('week')],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
      }
    )

    $(element).on('apply.daterangepicker', (ev, picker) ->
      scope.$apply( ->
        scope.start = picker.startDate
        scope.finish = picker.endDate
      )
      scope.$apply(scope.getdata)
    )
)

App.directive('showFormEditTime', -> (scope, element, attrs) ->
  $(element).on('click', (e) ->
    position = $(this).offset();
    $('#form_edit_time').css('position','absolute').css('left',position.left + $(this).outerWidth( true ) - 295).css('top',position.top +  $(this).outerHeight(true)).css('display','block')
    $('#form_edit_time').click (event) -> event.stopPropagation()
    e.stopPropagation();
  )
)

App.directive('showFormPeriodTime', -> (scope, element, attrs) ->
  $(element).on('click', (e) ->
    position = $(this).offset();
    $('#form_edit_period').css('position','absolute').css('left',position.left + $(this).outerWidth( true ) - 295).css('top',position.top +  $(this).outerHeight(true)).css('display','block')
    $('#form_edit_period').click (event) -> event.stopPropagation()
    e.stopPropagation();
  )
)

App.directive('showDatepicker', -> (scope, element, attrs) ->
  $(element).on('focus', -> $('.manually-form [datepicker]').show() )
)

App.directive('focusFirstInput',  -> (scope, element, attrs) ->
  $(element).click -> $(this).find('input:eq(0)').focus()
)