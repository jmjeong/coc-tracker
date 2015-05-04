'use strict'

angular.module 'cocApp'
.controller 'AdminCtrl', ($scope, $http, Auth, User, lodash) ->
    $http.get '/api/users'
    .success (users) ->
        $scope.users = users
        lodash.map users, (u) ->
            if (u.data)
                data = JSON.parse(u.data)
                u.hall = data.hall
            u
    $scope.delete = (user) ->
        return if user.role == 'admin'
        return
        User.remove id: user._id
        _.remove $scope.users, user
