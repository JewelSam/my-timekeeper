App.controller('ReportsCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', '$interval', '$timeout', ($scope, $route, $http, $rootScope, $sce, $interval, $timeout) ->
  $rootScope.page = 1

  $scope.categories = []
  $scope.categories_order = []
  $scope.entries = []

  $rootScope.loading = true
  $http({method: 'GET', url: '/pages/reports.json'}).success( (data) ->
    $scope.categories = data['categories']
    $scope.categories_order = data['categories_order']
    $scope.entries = data['entries']

#    $scope.update_entries()
    $rootScope.loading = false
  ).error( -> show_error() )



])
