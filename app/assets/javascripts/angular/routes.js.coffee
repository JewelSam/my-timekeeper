window.App = angular.module('my_timekeeper', ['ngRoute', 'ngSanitize'])

App.config(['$routeProvider',
  ($routeProvider) ->
    $routeProvider
    .when('/', {templateUrl: '/entries/index', controller: 'EntriesCtrl'})
])

App.config(["$httpProvider", ($httpProvider) -> $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')]);
