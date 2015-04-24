'use strict'

angular.module 'cocApp'
.controller 'AdminCtrl', ($scope, $http, Auth, User) ->

  $http.get '/api/users'
  .success (users) ->
    $scope.users = users
    #console.log(users)

  $scope.delete = (user) ->
    User.remove id: user._id
    _.remove $scope.users, user
