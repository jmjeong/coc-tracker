'use strict'

angular.module 'cocApp'
.controller 'NavbarCtrl', ($scope, $location, Auth, User) ->
    $scope.menu = [
        title: 'Home'
        link: '/'
    ,
        title: 'v1.27'
        link: '/about'
    ]
    $scope.isCollapsed = true
    $scope.isLoggedIn = Auth.isLoggedIn
    $scope.isAdmin = Auth.isAdmin
    $scope.getCurrentUser = Auth.getCurrentUser

    $scope.logout = ->
        Auth.logout()
        $location.path '/login'

    $scope.isActive = (route) ->
        route is $location.path()
