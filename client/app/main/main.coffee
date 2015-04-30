'use strict'

angular.module 'cocApp'
.config ($routeProvider) ->
    $routeProvider
    .when '/',
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        resolve:
            data: (userFactory, $route)->
                userFactory.get($route.current.params.id)
    .when '/about',
        templateUrl: 'app/main/about.html'
    .when '/p/upgrade',
        templateUrl: 'app/main/upgrade.html'
        controller: 'UpgradeCtrl'
        resolve:
            data: (userFactory, $route)->
                userFactory.get($route.current.params.id)
    .when '/p/walls',
        templateUrl: 'app/main/walls.html'
        controller: 'WallCtrl'
        resolve:
            data: (userFactory, $route)->
                userFactory.get($route.current.params.id)
    .when '/p/research',
        templateUrl: 'app/main/research.html'
        controller: 'ResearchCtrl'
        resolve:
            data: (userFactory, $route)->
                userFactory.get($route.current.params.id)
    .when '/p/hero',
        templateUrl: 'app/main/hero.html'
        controller: 'HeroCtrl'
        resolve:
            data: (userFactory, $route)->
                userFactory.get($route.current.params.id)
    .when '/p/overview',
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
        resolve:
            data: (userFactory, $route)->
                userFactory.get($route.current.params.id)
    .when '/p/:category',
        templateUrl: 'app/main/category.html'
        controller: 'MainCtrl'
        resolve:
            data: (userFactory, $route)->
                userFactory.get($route.current.params.id)
.config (localStorageServiceProvider) ->
    localStorageServiceProvider
    .setPrefix('coc-tracker')
    .setStorageType('localStorage')
.constant 'HEROFLAG', 100
.directive 'iconGold', () ->
    restrict: 'E',
    template: '<img src="assets/images/gold.png"  width="10" style="margin: 3px">'
.directive 'iconElixir', () ->
    restrict: 'E',
    template: '<img src="assets/images/elixir.png" width="10" style="margin: 3px">'
.directive 'iconDarkelixir', () ->
    restrict: 'E',
    template: '<img src="assets/images/darkelixir.png" width="10" style="margin: 3px">'
.controller 'subNavbarCtrl', ($scope, $location, lodash, $routeParams) ->
    $scope.isActive = (route) ->
        route is $location.url()

    menu = ['Overview', 'Defense', 'Trap', 'Army', 'Resource', 'Walls', 'Research', 'Hero', 'Other']
    $scope.link = (n)->
        if $routeParams.id then '/p/'+n.toLowerCase()+'?id='+$routeParams.id else '/p/'+n.toLowerCase()
    $scope.menu = lodash.map menu, (n)->
        title: n
        link: $scope.link(n)
    $scope.name = $scope.$parent.name
