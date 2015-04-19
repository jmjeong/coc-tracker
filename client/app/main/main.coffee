'use strict'

angular.module 'cocApp'
.config ($routeProvider) ->
    $routeProvider
    .when '/',
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
    .when '/about',
        templateUrl: 'app/main/about.html'
    .when '/p/walls',
        templateUrl: 'app/main/walls.html'
        controller: 'WallCtrl'
    .when '/p/research',
        templateUrl: 'app/main/research.html'
        controller: 'ResearchCtrl'
    .when '/p/hero',
        templateUrl: 'app/main/hero.html'
        controller: 'HeroCtrl'
    .when '/p/overview',
          redirectTo: '/'
    .when '/p/:category',
        templateUrl: 'app/main/category.html'
        controller: 'MainCtrl'
.config (localStorageServiceProvider) ->
    localStorageServiceProvider
    .setPrefix('coc-tracker')
    .setStorageType('localStorage')
.constant 'upgradeConfig',
    HEROFLAG: 100
.directive 'iconGold', () ->
    restrict: 'E',
    template: '<img src="assets/images/gold.png"  width="10" style="margin: 3px">'
.directive 'iconElixir', () ->
    restrict: 'E',
    template: '<img src="assets/images/elixir.png" width="10" style="margin: 3px">'
.directive 'iconDarkelixir', () ->
    restrict: 'E',
    template: '<img src="assets/images/darkelixir.png" width="10" style="margin: 3px">'
