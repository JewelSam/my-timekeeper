App.controller('SettingsCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', '$interval', '$timeout', ($scope, $route, $http, $rootScope, $sce, $interval, $timeout) ->
  $rootScope.page = 2

  $scope.categories = []

  $rootScope.loading = true
  $http({method: 'GET', url: '/pages/settings.json'}).success( (data) ->
    $scope.categories = data['categories']
    $rootScope.loading = false
  ).error( -> show_error() )

  $scope.showEditForm = (category) -> category.editing = true
  $scope.hideEditForm = (category) -> category.editing = false

  $scope.saveCategory = (category) ->
    is_new = category.is_new

    $http({method: 'POST', url: "/categories/update", data: category}).success( (data) ->
      if is_new then $scope.categories.push(data)
      else
        category.title = data.title
        category.editing = false
      $scope.new_category = {is_new: true}
    ).error((data) -> show_error(data['errors']))

  $scope.deleteCategory = (category) ->
    $http({method: 'POST', url: "/categories/delete", data: category}).success( (data) ->
      $scope.categories.remove(category)
    ).error((data) -> show_error(data['errors']))

  $scope.new_category = {is_new: true}

])
