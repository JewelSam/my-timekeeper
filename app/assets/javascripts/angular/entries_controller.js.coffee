App.controller('EntriesCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', ($scope, $route, $http, $rootScope, $sce) ->
  $scope.categories = []
  $scope.entries = []

  $rootScope.loading = true
  $http({method: 'GET', url: '/entries/index.json'}).success( (data) ->
    $scope.categories = data['categories']
    $scope.entries = data['entries']
    $rootScope.loading = false
  ).error( -> show_error() )
])
