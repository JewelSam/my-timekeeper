App.controller('ReportsCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', '$interval', '$timeout', ($scope, $route, $http, $rootScope, $sce, $interval, $timeout) ->
  $rootScope.page = 1
#  $scope.colors = [ "#f89e01", "#bf0000", "#6c008f", "#097900", "#de8d01", "#a50000",
#                    "#005b00", "#8300ae", "#fff", "#00708c", "#00439e"]

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
    $('#chart').highcharts({
      chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false
      },
      title: {
        text: 'Summary report'
      },
      tooltip: {
        formatter: -> "#{this.key}, #{(this.y*1000).toHHMMSS()}"
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: true,
            format: '<b>{point.name}</b>: {point.percentage:.1f} %',
            style: {
              color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
            }
          }
        }
      },
      series: [{
        type: 'pie',
        data: $scope.datachart
      }]
    });

  $scope.get_data()

])
