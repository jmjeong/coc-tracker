'use strict'

angular.module 'cocApp'
.controller 'MainCtrl', ($scope, $modal, $interval, $log, $route, HEROFLAG,
    util, lodash, userFactory, $routeParams, $http, moment, ngToast, data) ->

    # user = userFactory.get()
    # console.log(data)
    user = data
    $scope.timeStr = util.timeStr
    $scope.costStr = util.costStr
    $scope.costFormat = util.costFormat
    $scope.builder = user.builder
    $scope.hall = user.hall
    $scope.upgradeList = user.upgrade
    $scope.activeTab = $routeParams.category
    $scope.set = {}
    $scope.set.hideDone ?= user.set.hideDone
    $scope.set.hideDoneResearch ?= user.set.hideDoneResearch
    $scope.limitTo = user.limitTo
    $scope.HEROFLAG = HEROFLAG

    intervalPromise = $interval ()->
         if !util.checkUpgrade(user)
            userFactory.set('upgrade', user.upgrade)
            update()
    , 5000
    $scope.$on '$destroy', () ->
        $interval.cancel(intervalPromise)

    category = if ($scope.activeTab == undefined) then 'all' else $scope.activeTab
    #console.log(category)
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
        $scope.list = list =  []
        $scope.detail = detail = {}
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
            detail[name] = []
            uc = bD[name]['upgrade cost']
            ut = bD[name]['upgrade time']
            for i in [0..availableNum-1]
                user[name] ?= []
                currentLevel = user[name][i] ? 0
                continue if ($scope.set.hideDone && currentLevel >= maxLevel)
                find = lodash.findIndex(user.upgrade, {
                    name: name,
                    index: i
                })
                # console.log(find)
                level = currentLevel
                level++ if find >= 0
                detail[name].push(
                    idx: i
                    level: currentLevel
                    nextUpgrade: nextUpgrade(level, maxLevel, ut, uc)
                    upgradeIdx: find
                )
            continue if detail[name].length == 0

            list.push(
                title: item
                name: name
                available: availableNum
                maxLevel: maxLevel
            )
        $scope.summary = util.totalCostTime(category, user)
        $scope.researchSummary = util.totalResearchCostTime(user)
        $scope.wallSummary = util.totalWallCost(user)
        # console.log($scope.activeTab)

    update()

    $scope.changeLevel = (name, index, inc, maxLevel) ->
        currentLevel = oldLevel = $scope.detail[name][index].level
        currentLevel += inc
        currentLevel = 0 if currentLevel < 0
        currentLevel = maxLevel if currentLevel > maxLevel
        # maxLevel = util.max_level(user.hall, bD[name]['required town hall'])
        uc = bD[name]['upgrade cost']
        ut = bD[name]['upgrade time']
        $scope.detail[name][index] =
            idx: $scope.detail[name][index].idx
            level: currentLevel
            nextUpgrade: nextUpgrade(currentLevel, maxLevel, ut, uc)
        if oldLevel != currentLevel
            user[name][$scope.detail[name][index].idx] = currentLevel
            $scope.summary = util.totalCostTime(category, user)
            console.log(name, $scope.detail[name][index].idx,currentLevel)
            userFactory.set(name, user[name])

    $scope.timeWithBuilder = (time, builder, maxTime) ->
        # console.log($scope.longRequiredTime, $scope.requiredTime)
        # time = lodash.max([$scope.requiredTime/$scope.builder, $scope.longRequiredTime])
        max = lodash.max([time/builder, maxTime])
        return util.timeStr(max)

    $scope.setHall = (hall) ->
        $scope.hall = user.hall = hall
        userFactory.set('hall', user.hall)
        update()

    $scope.setBuilder = (builder) ->
        $scope.builder = user.builder = builder
        userFactory.set('builder', builder)

    $scope.settingChanged = () ->
        user.set.hideDone = $scope.set.hideDone
        user.set.hideDoneResearch = $scope.set.hideDoneResearch
        userFactory.set('set', user.set)

    $scope.upgrade = (name, title, index) ->
        idx = $scope.detail[name][index].idx
        level = user[name][idx] ? 0
        user.upgrade ?= []
        find = lodash.findIndex(user.upgrade, {
            name: name,
            index: idx
        })
        if (find < 0)
            upgradeNum = lodash.filter user.upgrade, (u) ->
                return u.index >= 0
            if (user.builder <= upgradeNum.length)
                ngToast.create(
                    className: 'warning'
                    content: 'need more builders...')
                return
        ut = bD[name]['upgrade time']
        if (find >= 0)
            due = moment(user.upgrade[find].due)
            value = parseInt(moment.duration(due.diff(moment())).asMinutes())
        else
            value = ut[level]

        modalInstance = $modal.open
            templateUrl: 'myModalContent.html'
            controller: 'ModalInstanceCtrl',
            # size: 'sm'
            resolve:
                data: () ->
                    {
                    sliderValue: value
                    title: title
                    sliderMax: ut[level]
                    level: level+1
                    update: (find >= 0)
                    }
        modalInstance.result.then (value) ->
            $scope.upgradeAction(name, title, index, value)

    $scope.upgradeAction = (name, title, index, value) ->
        idx = $scope.detail[name][index].idx
        level = user[name][idx] ? 0
        user.upgrade ?= []

        find = lodash.findIndex(user.upgrade, {
            name: name,
            index: idx
        })
        ut = bD[name]['upgrade time']
        if (value < 0)
            lodash.remove(user.upgrade, {
                name: name,
                index: idx
            })
            $scope.detail[name][index].upgradeIdx = -1
        else
            due = new moment()
            due = due.add(value, 'minutes')

            if (find < 0)
                $scope.detail[name][index].upgradeIdx = user.upgrade.length
                user.upgrade.push(
                    name: name
                    title: title
                    index: idx
                    level: level+1
                    time: ut[level]
                    due: due
                )
            else
                $scope.detail[name][index].upgradeIdx = find
                user.upgrade[find] = {
                    name: name
                    title: title
                    index: idx
                    level: level+1
                    time: ut[level]
                    due: due
                }
            level++
        maxLevel = util.max_level(user.hall, bD[name]['required town hall'])
        uc = bD[name]['upgrade cost']
        $scope.detail[name][index].nextUpgrade = nextUpgrade(level, maxLevel, ut, uc)
        $scope.summary = util.totalCostTime(category, user)
        # user.upgrade = []
        userFactory.set('upgrade', user.upgrade)

        # console.log(find, name, index, idx, level, util.timeStr(ut[level]) )
        # console.log(user.upgrade)
        #
    $scope.cancelUpgrade = (name, index) ->
        lodash.remove(user.upgrade, {
               name: name,
               index: index
        })
        level = $scope.detail[name][index].level
        $scope.detail[name][index].upgradeIdx = -1
        maxLevel = util.max_level(user.hall, bD[name]['required town hall'])
        ut = bD[name]['upgrade time']
        uc = bD[name]['upgrade cost']
        $scope.detail[name][index].nextUpgrade = nextUpgrade(level, maxLevel, ut, uc)
        $scope.summary = util.totalCostTime(category, user)
        $scope.researchSummary = util.totalResearchCostTime(user)
        userFactory.set('upgrade', user.upgrade)

angular.module('cocApp')
    .controller 'ModalInstanceCtrl', ($scope, $modalInstance, data) ->
        $scope.sliders = data
        $scope.selected = data.sliderValue
        $scope.update = data.update

        timeStr = (value) ->
            duration = moment.duration({
                minutes: value
            })
            d = duration.days()
            h = duration.hours()
            m = duration.minutes()
            if (d==0)
                h + 'h ' + m + 'm'
            else
                d + 'd ' + h + 'h'

        $scope.origin = timeStr(data.sliderMax)
        $scope.changed = $scope.origin

        $scope.ok = ()->
            $modalInstance.close($scope.selected)
        $scope.stop = ()->
            $modalInstance.close(-1)
        $scope.cancel = ()->
            $modalInstance.dismiss('cancel')
        $scope.format = (value)->
            timeStr(value)
        $scope.sliderDelegate = (value, $event) ->
            $scope.changed = timeStr(value)
            $scope.selected = value
