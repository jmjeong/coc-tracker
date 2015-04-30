'use strict'

angular.module 'cocApp'
.controller 'UpgradeCtrl', ($scope, $filter, util, lodash,  data, ngTableParams) ->

    user = data.user
    console.log(data.user)
    $scope.viewname = data.viewname
    $scope.timeStr = util.timeStr
    $scope.costStr = util.costStr
    $scope.costFormat = util.costFormat
    $scope.builder = user.builder
    $scope.hall = user.hall
    $scope.upgradeList = user.upgrade

    $scope.limitTo = user.limitTo
    $scope.title = user.name

    category = 'all'

    nextUpgrade = (current, maxLevel, timeArray, costArray) ->
        return {} if (current >= maxLevel)
        data = []
        for i in [current..maxLevel-1]
            data.push([i+1, costArray[i], timeArray[i]])
        return {
        type: util.costType(data[0][1])
        popover: util.costStr(data[0][1]) + ' / ' + util.timeStr(data[0][2])
        data: data
        }
    update = () ->
        data = []
        $scope.requiredCost = [0,0,0]
        $scope.doneCost = [0,0,0]
        $scope.requiredTime = 0
        $scope.doneTime = 0
        # $scope.activeTab = undefined
        for item in lodash.sortBy(util.building_list(category))
            name = util.cannonicalName(item)
            availableNum = bD['number available'][name][user.hall-1]
            continue if (availableNum == 0 )

            maxLevel = util.max_level(user.hall, bD[name]['required town hall'])
            uc = bD[name]['upgrade cost']
            ut = bD[name]['upgrade time']
            for i in [0..availableNum-1]
                user[name] ?= []
                currentLevel = user[name][i] ? 0
                continue if (currentLevel >= maxLevel)
                findUpgrade = lodash.findIndex(user.upgrade, {
                    name: name,
                    index: i
                })
                # console.log(find)
                level = currentLevel
                level++ if findUpgrade >= 0

                findEntry = lodash.findIndex(data, {
                    name: item+' #'+(level+1)
                })
                continue if (findEntry >= 0)
                data.push({
                    name: item+' #'+(level+1)
                    time: ut[level]
                    costg: uc[level][0]
                    coste: uc[level][1]
                    costd: uc[level][2]
                })
        $scope.tableParams = new ngTableParams
            page: 1
            count: 50
            sorting:
                name: 'asc'
        ,
            total: data.length
            getData: ($defer, params) ->
                orderedData = if params.sorting() then $filter('orderBy')(data, params.orderBy()) else data
                $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()))

    update()

