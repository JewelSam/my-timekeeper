App.controller('EntriesCtrl', ['$scope', '$route', '$http', '$rootScope', '$sce', '$interval', '$timeout', ($scope, $route, $http, $rootScope, $sce, $interval, $timeout) ->
  $rootScope.page = 0

  $scope.categories = []
  $scope.categories_order = []
  $scope.entries = []
  $scope.group_entries = {}
  $scope.current_entry = {}
  $scope.page = 0

  $scope.loadMore = ->
    $rootScope.loading = true
    $http({method: 'POST', data:{page:$scope.page}, url: '/entries/index.json'}).success( (data) ->
      $scope.categories = data['categories']
      $scope.categories_order = data['categories_order']
      $scope.autocompleteData = data['autocompleteData']
      for new_entry in  data['entries']
        push_flag = true
        push_flag = false for old_entry in  $scope.entries when new_entry.id == old_entry.id
        $scope.sort_push_entry(new_entry) if push_flag
      $scope.update_entries()
      $scope.updateAutocomplete()
      $rootScope.loading = false
      $scope.page = $scope.page + 1
    ).error( ->
      $rootScope.loading = false
      show_error()
    )
  $scope.loadMore()

  $scope.sort_push_entry = (main_entry) ->
    flag = true
    $scope.format_entry(main_entry)

    $scope.entries.splice(key, 1) for key,entry of $scope.entries when main_entry.id == entry.id

    for key, entry of $scope.entries
      if entry.start and entry.start.isBefore(main_entry.start) && flag
        $scope.entries.splice(key, 0, main_entry);
        flag = false

    $scope.entries.push(main_entry) if flag

  $scope.format_entry = (entry) ->
    entry.start = moment(entry.start)
    entry.finish = if entry.finish then moment(entry.finish) else null
    entry

  $scope.update_entries = ->
    $scope.current_entry = (entry for entry in $scope.entries when entry.current)[0] || {title: '', is_new:true}
    $scope.group_entries = {}

    i = 0
    old_date = null


    for entry in $scope.entries
      date_of_entry = moment(entry.start).startOf('day')

      if !old_date or !old_date.isSame(date_of_entry)
        i = i + 1
        title =
          if date_of_entry.isSame moment().startOf('day') then 'Today'
          else if date_of_entry.isSame moment().subtract('days', 1).startOf('day')
            'Yesterday'
          else entry.start.format('DD/MM/YY')

        $scope.group_entries[i] = {title:title, data:[]}
        old_date = date_of_entry

      $scope.group_entries[i]['data'].push entry



  #  CURRENT ENTRY ###############################################################################
  $interval(
    -> if $scope.current_entry.current then $scope.current_entry.finish = moment()
  , 1000)

  $scope.saveEntry = (entry, options = {}) ->
    data = angular.copy(entry)
    is_edit_time = options.is_edit_time

    if entry.current
      data.finish = null
    else if !is_edit_time && !entry.edited
      data.finish = moment()

    $rootScope.loading = true
    $http({method: 'POST', url: "/entries/update", data: data}).success((data) ->
      is_new = entry.is_new
      angular.extend(entry, data['entry']);
      entry.is_new = false
      if is_new || is_edit_time then $scope.sort_push_entry(entry) else $scope.format_entry(entry)

      $scope.update_entries()
      options.callback(options.args) if options.callback
      $rootScope.loading = false
    ).error( ->
      $rootScope.loading = false
      show_error()
    )

  $scope.createNewEntry = -> $scope.current_entry = {title: '', is_new: true}

  $scope.submitNewEntryForm = -> if $scope.current_entry.is_new then $scope.createEntry() else $scope.stopEntry()

  $scope.createEntry = ->
    $scope.current_entry.start = moment()
    $scope.current_entry.is_new = true
    $scope.current_entry.current = 1
    $scope.saveEntry($scope.current_entry)

  $scope.stopEntry = ->
    $scope.current_entry.current = false
    $timeout.cancel(onblurCurrentEntry)
    $scope.saveEntry($scope.current_entry, {callback: $scope.createNewEntry})

  $scope.saveCurrentEntry = -> $scope.saveEntry($scope.current_entry) if $scope.current_entry.current

  $scope.edit_entry = {}
  $scope.showFormEditTime = (entry) ->
    $scope.edit_entry = entry
    $scope.edit_entry.start_to_s = if entry.start then entry.start.format('HH:mm') else ''
    $( "#form_edit_time [datepicker]" ).datepicker( "setDate", if entry.start then entry.start.format('L') else moment().format('L') );
    unless entry.current
      $scope.edit_entry.finish_to_s = if entry.finish then entry.finish.format('HH:mm') else ''

  $scope.saveEditedTime =  ->
    date = moment($( "#form_edit_time [datepicker]" ).datepicker( "getDate" )).format('L')
    $scope.edit_entry.start = moment("#{date} #{$scope.edit_entry.start_to_s}")
    $scope.edit_entry.finish = moment("#{date} #{$scope.edit_entry.finish_to_s}") unless $scope.edit_entry.current
    $('#form_edit_time').css('display','none')
    $scope.saveEntry($scope.edit_entry, {is_edit_time: true})

  onblurCurrentEntry = ''
  $scope.blurCurrentEntry = ->
    onblurCurrentEntry = $timeout(
      -> $scope.saveCurrentEntry()
    , 100)

  #  MANUALLY ADD ENTRY ###############################################################################
  $scope.manually_entry = {title: '', start_to_s: moment().format('HH:mm'), finish_to_s: moment().format('HH:mm'), manually: true}
  $scope.saveManuallyEntry = ->
    date = moment($( ".manually-form [datepicker]" ).datepicker( "getDate" )).format('L')
    $scope.manually_entry.start = moment("#{date} #{$scope.manually_entry.start_to_s}")
    $scope.manually_entry.finish = moment("#{date} #{$scope.manually_entry.finish_to_s}")
    $scope.saveEntry($scope.manually_entry, {is_edit_time: true})

  onTimeBlur = ''
  $scope.blur_time = ->
    onTimeBlur = $timeout(
      -> $scope.manually_entry.focus_time = false
    , 100)
  $scope.focus_time = ->
    $scope.manually_entry.focus_time = true
    $timeout.cancel(onTimeBlur)

#  TABLE ENTRIES ###############################################################################
  $scope.checked = (group) -> (entry for entry in group.data when entry.checked)
  $scope.allChecked = (group)->
    res = true
    res = false for entry in group.data when !entry.checked
    res
  $scope.allCheck = (group)->
    state = $scope.allChecked(group)
    entry.checked = !state for entry in group.data

  $scope.duration = (entry) ->
    if entry.start
      finish = entry.finish || moment()
      toHHMMSS(moment.duration(finish.diff(entry.start)))
    else '0 sec'

  $scope.createCurrentEntryAsEntry = (entry) ->
    $scope.createNewEntry()
    $scope.current_entry.title = entry.title
    $scope.current_entry.category_id = entry.category_id
    $scope.createEntry()

  $scope.setCurrentEntry = (entry) ->
    if $scope.current_entry != entry
      if $scope.current_entry.current
        $scope.current_entry.current = false
        $scope.saveEntry( $scope.current_entry, {callback: $scope.createCurrentEntryAsEntry, args: entry})
      else $scope.createCurrentEntryAsEntry(entry)

  $scope.destroyEntry = (entry = {}, group) ->
    ids = if entry.id then [entry.id] else $scope.checked(group).map((en) -> en.id)

    if ids.length > 0 and confirm("Delete #{ids.length} time #{ids.length == 1 ? 'entry' : 'entries'}? This action cannot be reversed.")
      $rootScope.loading = true
      $http({method: 'POST', url: "/entries/destroy", data: {ids: ids}}).success((data) ->
        i = 0
        for key,entry of angular.copy($scope.entries)
          if entry.id in ids
            $scope.entries.splice(key - i, 1)
            i = i + 1
        $scope.update_entries()
        $rootScope.loading = false
      ).error( ->
        $rootScope.loading = false
        show_error()
      )

  $scope.showEditForm = (entry) ->
    entry.edited = true

  $scope.saveEditedEntry = (entry) ->
    $scope.saveEntry(entry)
    entry.edited = false

  $scope.onBlurInputEditedForm = (entry) ->
    entry.onFormBlur = $timeout(
      -> $scope.saveEditedEntry(entry) if entry.edited
    , 100)
  $scope.onFocusInputEditedForm =  (entry) -> $timeout.cancel(entry.onFormBlur)

#  Autocomplete #####################################################################
  $scope.updateAutocomplete = ->
    $http({method: 'GET', url: '/entries/autocomplete_data.json'}).success( (data) ->

      substringMatcher = (strs) -> (q, cb) ->
        matches = []
        substrRegex = new RegExp(q, 'i')
        $.each(strs, (i, str) ->
          if substrRegex.test(str.title)
            category = $scope.categories[str.category_id]
            category_title = if category then category.title else 'No category'
            matches.push({ title: str.title, category_id: str.category_id, category_title: category_title })
        )
        cb(matches)

      $('.typeahead').typeahead({
        highlight: true
      },
      {
        name: 'my-dataset'
        source: substringMatcher(data['autocompleteData'])
        displayKey: 'title'
        templates:
          suggestion: _.template('<p><%= title %> – <%= category_title %></p>')
      });

#      current entry
      set_current_entry = (data) ->
        $scope.current_entry.title = data.title
        $scope.current_entry.category_id = data.category_id

      $('#current_input.typeahead').bind('typeahead:selected', (obj, data, name) ->
        set_current_entry(data)
        $scope.createEntry() unless $scope.current_entry.current
      )
      $('#current_input.typeahead').bind('typeahead:autocompleted', (obj, data, name) -> set_current_entry(data) )

#      manually entry
      $('.manually-form .typeahead').bind('typeahead:selected typeahead:autocompleted', (obj, data, name) ->
        $scope.manually_entry.title = data.title
        $scope.manually_entry.category_id = data.category_id
      )

#      edit entry
      set_edit_entry = (data) ->
        entry = (entry for entry in $scope.entries when entry.edited)[0]
        entry.title = data.title
        entry.category_id = data.category_id

      $('.edit_entry .typeahead').bind('typeahead:selected', (obj, data, name) ->
        set_edit_entry(data)
        $scope.saveEditedEntry(entry)
      )
      $('.edit_entry .typeahead').bind('typeahead:autocompleted', (obj, data, name) -> set_edit_entry(data))

    ).error( -> show_error() )

])
