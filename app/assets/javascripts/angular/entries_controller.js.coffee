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

    $scope.update_entries()
    $rootScope.loading = false
  ).error( -> show_error() )

  $scope.update_entries = ->
    $scope.current_entry = (entry for entry in $scope.entries when entry.current)[0] || {title: ''}
    for entry in $scope.entries
      entry.start = new Date(entry.start_to_i * 1000)
      entry.finish = if entry.finish_to_i then new Date(entry.finish_to_i * 1000) else null

#  CURRENT ENTRY ###############################################################################
  $interval(
    -> if $scope.current_entry.current then $scope.current_entry.finish = new Date()
  , 1000)

  $scope.saveEntry = (entry) ->
    $http({method: 'POST', url: "/entries/update", data: entry}).success((data) ->
      $scope.entries = data['entries']
      $scope.update_entries()
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
    $scope.edit_entry.start_to_s = entry.start.toHHMM()
    $scope.edit_entry.finish_to_s = entry.finish.toHHMM() unless entry.current

  $scope.saveEditedTime =  ->
    $scope.edit_entry.start = $scope.edit_entry.start_to_s.fromHHMM()
    $scope.edit_entry.finish = if $scope.edit_entry.current then null else $scope.edit_entry.finish_to_s.fromHHMM()
    $scope.saveEntry($scope.edit_entry)

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
    finish = entry.finish || (if entry.current then new Date() else 0)
    start = entry.start || 0

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
      $scope.update_entries()
    ).error((data) -> show_error(data['errors']))

])
