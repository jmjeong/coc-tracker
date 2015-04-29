'use strict'

angular.module('cocApp')
.controller 'WallCtrl', ($scope, util, lodash, userFactory, data) ->
    # user = userFactory.get()

    user = data.user
    $scope.viewname = data.viewname

    name = util.cannonicalName('Walls')
    user[name] ?= []

    $scope.hall = user.hall
    $scope.costStr = util.costStr

    $scope.costFormat = util.costFormat
    $scope.hideDone = user.set.hideDone

    nextUpgrade = (current, maxLevel, costArray) ->
        return if (current >= maxLevel)
        data = []
        for i in [current..maxLevel-1]
            data.push([i+1, costArray[i]])
        return {
        type: util.costType(data[0][1])
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

        walls.available = availableNum = bD['number available'][name][user.hall-1]

        start = 0
        maxLevel = util.max_level(user.hall, bD[name]['required town hall'])
        if ($scope.hideDone)
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
                # continue if ($scope.hideDone && currentLevel >= maxLevel)
                walls.data.push(
                    idx: i-start
                    level: i+1
                    count: count
                    upgrade: nextUpgrade(i+1, maxLevel, bD[name]['upgrade cost'])
                )
        $scope.summary = util.totalWallCost(user)

    update()

    $scope.changeNum = (level, idx, count) ->
        return if count == undefined || count < 0
        user['walls'][level-1] = count
        maxLevel = util.max_level(user.hall, bD[name]['required town hall'])
        $scope.walls.data[idx].upgrade = nextUpgrade(level, maxLevel, bD[name]['upgrade cost'])
        total = 0
        for i in [0..maxLevel-1]
            total += user['walls'][i]
        $scope.walls.total = total
        $scope.summary = util.totalWallCost(user)
        userFactory.set([{key:'walls', value:user.walls}], user)


