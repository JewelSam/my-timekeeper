App.controller('ReportsCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', '$interval', '$timeout', ($scope, $route, $http, $rootScope, $sce, $interval, $timeout) ->
  $rootScope.page = 1
  $scope.colors = [ "#f89e01", "#bf0000", "#6c008f", "#097900", "#de8d01", "#a50000",
                    "#005b00", "#8300ae", "#fff", "#00708c", "#00439e"]

  $scope.datachart = []
  $scope.start = moment().startOf('week')
  $scope.finish = moment().endOf('week')

  $scope.get_data = ->
    $rootScope.loading = true
    $http({method: 'POST', url: '/reports/data', data: {start: $scope.start, finish: $scope.finish}}).success( (data) ->
      $scope.datachart = data['datachart']
      $scope.update_chart()
      $rootScope.loading = false
    ).error( ->
      $rootScope.loading = false
      show_error()
    )

  $scope.update_chart = ->
    $.jqplot('chart', [$scope.datachart],
    {
      seriesColors: $scope.colors
      highlighter:
        show: true
        tooltipContentEditor: (str, seriesIndex, pointIndex, plot) ->
          title = plot.data[seriesIndex][pointIndex][0]
          secs = plot.data[seriesIndex][pointIndex][1]

          "#{title}, #{(secs*1000).toHHMMSS()}";
        formatString:'%s, %d',
        useAxesFormatters: false
      seriesDefaults:
        renderer: jQuery.jqplot.PieRenderer
        shadow: false
      grid:
        background: '#fff'
        borderWidth: 0
        shadow: false
    }
    )

  $scope.get_data()

])
