#App.directive('accordion', ->
#  {
#  restrict: 'E',
#  transclude: true,
#  replace: true,
#  scope: {
#    header: '@'
#  },
#  templateUrl: 'accordion.html',
#  link: (scope, element, attrs) ->
#    element.find('.accordion-body').addClass('in') if attrs.isContentVisible is 'true'
#
#    scope.isContentVisible = (attrs.isContentVisible is 'true')
#    scope.toggleContent = -> scope.isContentVisible = !scope.isContentVisible
#
#    scope.accordionId = "#{element.parent().attr('id')}_#{accordion_id}"
#    accordion_id++
#  }
#)