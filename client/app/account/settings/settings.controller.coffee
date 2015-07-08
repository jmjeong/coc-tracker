'use strict'

angular.module 'cocApp'
.controller 'SettingsCtrl', ($scope, $location, User, Auth) ->
  $scope.errors = {}
  $scope.url = '/p/overview?id='+ Auth.getCurrentUser()._id
  $scope.upgrade = $location.protocol()+'://'+$location.host()+'/api/users/'+ Auth.getCurrentUser()._id + '/upgrade'
  $scope.log = $location.protocol()+'://'+$location.host()+'/api/users/'+ Auth.getCurrentUser()._id + '/log'
  $scope.changePassword = (form) ->
    $scope.submitted = true

    if form.$valid
      Auth.changePassword $scope.user.oldPassword, $scope.user.newPassword
      .then ->
        $scope.message = 'Password successfully changed.'

      .catch ->
        form.password.$setValidity 'mongoose', false
        $scope.errors.other = 'Incorrect password'
        $scope.message = ''
