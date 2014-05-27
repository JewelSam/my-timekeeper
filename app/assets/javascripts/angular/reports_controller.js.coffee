App.controller('ReportsCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', '$interval', '$timeout', ($scope, $route, $http, $rootScope, $sce, $interval, $timeout) ->
  $rootScope.page = 1

  $scope.datachart = []

  $rootScope.loading = true
  $http({method: 'GET', url: '/pages/reports.json'}).success( (data) ->
    $scope.datachart = data['datachart']
    update_chart()
    $rootScope.loading = false
  ).error( -> show_error() )

  update_chart = ->
    $.jqplot('chart', [$scope.datachart],
    {
      highlighter:
        show: true
        tooltipContentEditor: (str, seriesIndex, pointIndex, plot) ->
          title = plot.data[seriesIndex][pointIndex][0]
          secs = plot.data[seriesIndex][pointIndex][1]

          "#{title}, #{(secs*1000).toHHMMSS()}";
        formatString:'%s, %d',
        useAxesFormatters: false
      seriesDefaults:
        renderer: jQuery.jqplot.PieRenderer,
        rendererOptions:
          showDataLabels: true
      legend: { show:true, location: 'e' }
    }
    )

])
