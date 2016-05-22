'use strict'

angular.module('cocApp')
.controller 'WallCtrl', ($scope, util, lodash, userFactory, data) ->
    user = data.user
    $scope.readonlyName = data.readonlyName

    name = util.cannonicalName('Walls')
    user[name] ?= []

    $scope.hall = user.setting.hall

    $scope.costFormat = util.costFormat
    $scope.hideDoneBuilding = user.setting.hideDoneBuilding

    nextUpgrade = (current, maxLevel, costArray, user) ->
        return if (current >= maxLevel)
        data = []
        count = user[name][current-1] ? 0
        for i in [current..maxLevel-1]
            data.push([i+1, costArray[i][0]*count])
        return {
        type: 'g'
        data: data
        }

    update = () ->
        $scope.walls = walls =  {}
        walls.data = []
        walls.total = 0
        $scope.requiredCost = [0,0,0]
        $scope.doneCost = [0,0,0]
        $scope.requiredTime = 0
        $scope.doneTime = 0

        walls.available = availableNum = bD['number available'][name][user.setting.hall-1]

        start = 0
        maxLevel = util.max_level(user.setting.hall, bD[name]['required town hall'])
        if ($scope.hideDoneBuilding)
            for i in [0..maxLevel-1]
                count = user[name][i] ? 0
                if (count > 0)
                    start = i
                    break
        if (start <= maxLevel-1)
            for i in [start..maxLevel-1]
                uc = bD[name]['upgrade cost']
                user[name][i] ?= 0
                count = user[name][i]
                walls.total += count
                walls.data.push(
                    idx: i
                    idxno: i-start
                    count: count
                    upgrade: nextUpgrade(i+1, maxLevel, bD[name]['upgrade cost'], user)
                )
        $scope.summary = util.totalWallCost(user)

    update()

    $scope.changeNum = (idx, idxno, count) ->
        if (count == undefined || count < 0)
            $scope.walls.data[no].count = 0;
            return;

        user['walls'][idx] = count
        maxLevel = util.max_level(user.setting.hall, bD[name]['required town hall'])
        $scope.walls.data[idxno].upgrade = nextUpgrade(idx+1, maxLevel, bD[name]['upgrade cost'], user)
        total = 0
        for i in [0..maxLevel-1]
            total += user['walls'][i]
        $scope.walls.total = total
        $scope.summary = util.totalWallCost(user)
        userFactory.set([{'action':'changeWall','data':{index:idx,level:count}}], user)

    $scope.pString = ->
        "may replace elixirs for walls"

