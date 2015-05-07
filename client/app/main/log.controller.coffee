'use strict'

angular.module 'cocApp'
.controller 'LogCtrl', ($scope, $filter, data, ngTableParams) ->

    $scope.viewname = data.viewname
    log = data.log

    $scope.tableParams = new ngTableParams
        page: 1,
        count: 25
        filter:
            title: ''
    ,
        getData: ($defer, params) ->
            total: log.length
            orderedData = if params.filter() then $filter('filter')(log, params.filter()) else log
            # orderedData = if params.sorting() then $filter('orderBy')(orderedData, params.orderBy()) else orderedData
            params.total(orderedData.length)
            $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()))
