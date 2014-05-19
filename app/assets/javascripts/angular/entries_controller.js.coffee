App.controller('EntriesCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', ($scope, $route, $http, $rootScope, $sce) ->
  $scope.categories = []
  $scope.entries = []

  $rootScope.loading = true
  $http({method: 'GET', url: '/entries/index.json'}).success( (data) ->
    $scope.categories = data['categories']
    $scope.entries = data['entries']
    $rootScope.loading = false
  ).error( -> show_error() )

  $scope.duration = (entry) ->
    finish = new Date(entry.finish_to_i * 1000)
    start = new Date(entry.start_to_i * 1000)
    (finish-start).to_count_of_hours()
])
