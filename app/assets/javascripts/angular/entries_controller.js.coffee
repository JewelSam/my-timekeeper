App.controller('EntriesCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', '$interval', '$timeout', ($scope, $route, $http, $rootScope, $sce, $interval, $timeout) ->
  $scope.categories = []
  $scope.categories_order = []
  $scope.entries = []
  $scope.group_entries = {}
  $scope.current_entry = {}

  $rootScope.loading = true
  $http({method: 'GET', url: '/entries/index.json'}).success( (data) ->
    $scope.categories = data['categories']
    $scope.categories_order = data['categories_order']
    $scope.entries = data['entries']

    $scope.update_entries()
    $rootScope.loading = false
  ).error( -> show_error() )

  $scope.push_entry = (main_entry) ->
    flag = true
    for key,entry of $scope.entries
      if entry.start_to_i < main_entry.start_to_i && flag
        $scope.entries.splice(key, 0, main_entry);
        flag = false
    $scope.entries.splice(0, 0, main_entry) if flag
    console.log $scope.entries
#
#  $scope.add_entry = (entry) ->
#    console.log(entry)
#    if entry.is_new
#      flag = true
#      for key, g_entry of $scope.group_entries
#        console.log g_entry
#        if g_entry.sort_date == entry.sort_date
#          $scope.push_entry entry, g_entry
#          flag = false
#  #    $scope.group_entries





  $scope.format_entry = (entry) ->
    entry.start = new Date(entry.start_to_i * 1000)
    entry.finish = if entry.finish_to_i then new Date(entry.finish_to_i * 1000) else null
    entry.sort_date =  entry.start.toSortDateInt()




  $scope.update_entries = ->
    $scope.current_entry = (entry for entry in $scope.entries when entry.current)[0] || {title: ''}
    $scope.group_entries = {}


    i = 0
    today = new Date().toSortDateInt()
    yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    yesterday = yesterday.toSortDateInt();
    old_sort_date = ''


    for entry in $scope.entries
      $scope.format_entry entry

      if old_sort_date != entry.sort_date
        i = i + 1
        title =  entry.start.toYYYYMMDD()
        if entry.sort_date == today then title = 'Today'
        if entry.sort_date == yesterday then title = 'Yesterday'
        $scope.group_entries[i] = {title:title, sort_date:entry.sort_date ,data:[]}
        old_sort_date = entry.sort_date

      $scope.group_entries[i]['data'].push entry



  #  CURRENT ENTRY ###############################################################################
  $interval(
    -> if $scope.current_entry.current then $scope.current_entry.finish = new Date()
  , 1000)

  $scope.saveEntry = (entry) ->
    data = angular.copy(entry)
    data.finish = null if entry.current

    $http({method: 'POST', url: "/entries/update", data: data}).success((data) ->
      is_new = entry.is_new
      angular.extend(entry, data['entry']);
      entry.is_new = false
      $scope.push_entry(entry) if is_new
      $scope.update_entries()
    ).error((data) -> show_error(data['errors']))

  $scope.createNewEntry = ->
    $scope.current_entry = {title:'222', is_new:true}

  $scope.createEntry = ->
    $scope.current_entry.start = new Date()
    $scope.current_entry.is_new = true
    $scope.current_entry.current = 1
    $scope.saveEntry($scope.current_entry)

  $scope.stopEntry = ->
    $scope.current_entry.current = false
    $scope.saveEntry($scope.current_entry)
    $scope.createNewEntry()

  $scope.saveCurrentEntry = -> $scope.saveEntry($scope.current_entry) if $scope.current_entry.current

  $scope.edit_entry = {}
  $scope.showFormEditTime = (entry) ->
    $scope.edit_entry = entry
    $scope.edit_entry.start_to_s = if entry.start then entry.start.toHHMM() else ''
    $( "#form_edit_time [datepicker]" ).datepicker( "setDate", entry.start || new Date() );
    unless entry.current
      $scope.edit_entry.finish_to_s = if entry.finish then entry.finish.toHHMM() else ''

  $scope.saveEditedTime =  ->
    date = $( "#form_edit_time [datepicker]" ).datepicker( "getDate" )
    $scope.edit_entry.start = $scope.edit_entry.start_to_s.fromHHMM(date)
    $scope.edit_entry.finish = $scope.edit_entry.finish_to_s.fromHHMM(date) unless $scope.edit_entry.current
    $('#form_edit_time').css('display','none')
    $scope.saveEntry($scope.edit_entry)

  #  MANUALLY ADD ENTRY ###############################################################################
  $scope.manually_entry = {title: '', start_to_s: new Date().toHHMM(), finish_to_s: new Date().toHHMM(), manually: true}
  $scope.saveManuallyEntry = ->
    date = $( ".manually-form [datepicker]" ).datepicker( "getDate" )
    $scope.manually_entry.start = $scope.manually_entry.start_to_s.fromHHMM(date)
    $scope.manually_entry.finish = $scope.manually_entry.finish_to_s.fromHHMM(date)
    $scope.saveEntry($scope.manually_entry)

  onTimeBlur = ''
  $scope.blur_time = ->
    onTimeBlur = $timeout(
      -> $scope.manually_entry.focus_time = false
    , 100)
  $scope.focus_time = ->
    $scope.manually_entry.focus_time = true
    $timeout.cancel(onTimeBlur)

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
    if $scope.current_entry.current
      $scope.current_entry.current = false
      $scope.saveEntry($scope.current_entry)

    $scope.current_entry.title = entry.title
    $scope.current_entry.category_id = entry.category_id
    $scope.createEntry()

  $scope.destroyEntry = (entry = {}) ->
    ids = if entry.id then [entry.id] else $scope.checked().map((en) -> en.id)

    $http({method: 'POST', url: "/entries/destroy", data: {ids: ids}}).success((data) ->
      $scope.entries = data['entries']
      $scope.update_entries()
    ).error((data) -> show_error(data['errors']))

  $scope.showEditForm = (entry) -> entry.edited = true

  $scope.saveEditedEntry = (entry) ->
    entry.edited = false
    $scope.saveEntry(entry)

  onFormBlur = ''
  $scope.onBlurInputEditedForm = (entry) ->
    onFormBlur = $timeout(
      -> $scope.saveEditedEntry(entry)
    , 100)
  $scope.onFocusInputEditedForm = -> $timeout.cancel(onFormBlur)

])
