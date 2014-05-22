App.controller('EntriesCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', '$interval', ($scope, $route, $http, $rootScope, $sce, $interval) ->
  $scope.categories = []
  $scope.categories_order = []
  $scope.entries = []
  $scope.current_entry = {}

  $rootScope.loading = true
  $http({method: 'GET', url: '/entries/index.json'}).success( (data) ->
    $scope.categories = data['categories']
    $scope.categories_order = data['categories_order']
    $scope.entries = data['entries']

    $scope.update_current_entry()
    $rootScope.loading = false
  ).error( -> show_error() )

#  CURRENT ENTRY ###############################################################################
  $scope.update_current_entry = -> $scope.current_entry = (entry for entry in $scope.entries when entry.current)[0] || {title: ''}
  $interval(
    -> if $scope.current_entry.current then $scope.current_entry.finish = new Date()
  , 1000)

  $scope.saveEntry = (entry) ->
    $http({method: 'POST', url: "/entries/update", data: entry}).success((data) ->
      $scope.entries = data['entries']
      $scope.update_current_entry()
    ).error((data) -> show_error(data['errors']))

  $scope.createEntry = ->
    $scope.current_entry.start = new Date()
    $scope.current_entry.current = 1
    $scope.saveEntry($scope.current_entry)

  $scope.stopEntry = ->
    $scope.current_entry.current = false
    $scope.saveEntry($scope.current_entry)

  $scope.edit_entry = {}
  $scope.showFormEditTime = (entry) ->
    $scope.edit_entry = entry
    $scope.edit_entry.start_to_s = if entry.start_to_i then entry.start_to_i.toHHMM() else ''
    $scope.edit_entry.finish_to_s = if entry.finish_to_i then entry.finish_to_i.toHHMM() else ''

  $scope.saveEditedTime =  ->
    $scope.edit_entry.start = $scope.edit_entry.start_to_s.split(':')


  #  MANUALLY ADD ENTRY ###############################################################################
  $scope.manually_entry = {title: ''}

#  TABLE ENTRIES ###############################################################################
  $scope.checked = -> (entry for entry in $scope.entries when entry.checked)
  $scope.allChecked = ->
    res = true
    res = false for entry in $scope.entries when !entry.checked
    res
  $scope.allCheck = ->
    state = $scope.allChecked()
    entry.checked = !state for entry in $scope.entries

  $scope.duration = (entry) ->
    finish =
      if entry.current then new Date()
      else if entry.finish and entry.finish.constructor.name == 'Date' then entry.finish
      else if entry.finish then new Date(entry.finish_to_i * 1000)
      else 0

    start =
      if entry.start and entry.start.constructor.name == 'Date' then entry.start
      else if entry.start then new Date(entry.start_to_i * 1000)
      else 0

    (finish-start).toHHMMSS()

  $scope.setCurrentEntry = (entry) ->
    if $scope.current_entry.current then $scope.stopEntry()
    $scope.current_entry.title = entry.title
    $scope.current_entry.category_id = entry.category_id
    $scope.createEntry()

  $scope.destroyEntry = (entry = {}) ->
    ids = if entry.id then [entry.id] else $scope.checked().map((en) -> en.id)

    $http({method: 'POST', url: "/entries/destroy", data: {ids: ids}}).success((data) ->
      $scope.entries = data['entries']
    ).error((data) -> show_error(data['errors']))

])
