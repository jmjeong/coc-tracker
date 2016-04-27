'use strict'

angular.module 'cocApp'
.controller 'MainCtrl', ($scope, $modal, $interval, $log, $route, HEROFLAG,
    util, lodash, userFactory, $routeParams, $http, moment, ngToast, data) ->

    user = data.user
    $scope.readonlyName = data.readonlyName

    $scope.timeStr = util.timeStr
    $scope.costStr = util.costStr
    $scope.costFormat = util.costFormat
    $scope.builder ?= user.setting.builder
    $scope.hall ?= user.setting.hall
    $scope.setuphall ?= user.setting.setuphall
    $scope.hideDoneBuilding = user.setting.hideDoneBuilding
    $scope.hideDoneResearch = user.setting.hideDoneResearch
    $scope.limitTo = user.setting.limitTo
    $scope.upgradeList = user.upgrade
    $scope.activeTab = $routeParams.category

    $scope.HEROFLAG = HEROFLAG
    $scope.remainTime = util.remainTime
    $scope.timeStrMoment = util.timeStrMoment
    $scope.title = user.name

    category = if ($scope.activeTab == undefined) then 'all' else $scope.activeTab
    $scope.isResource = (category=='resource')
    # console.log(category)
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
            availableNum = bD['number available'][name][user.setting.hall-1]
            continue if (availableNum == 0 )

            maxLevel = util.max_level(user.setting.hall, bD[name]['required town hall'])
            detail[name] = []
            uc = bD[name]['upgrade cost']
            ut = bD[name]['upgrade time']
            for i in [0..availableNum-1]
                user.building ?= {}
                user.building[name] ?= []
                currentLevel = user.building[name][i] ? 0
                find = lodash.findIndex(user.upgrade, {
                    name: name,
                    index: i
                })
                continue if ($scope.hideDoneBuilding && currentLevel >= maxLevel && find < 0)

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
        if ($scope.isResource)
            $scope.totalProduction = util.totalProduction(user)

    update()

    $scope.changeLevel = (name, index, inc, maxLevel) ->
        currentLevel = oldLevel = $scope.detail[name][index].level
        currentLevel += inc
        currentLevel = 0 if currentLevel < 0
        currentLevel = maxLevel if currentLevel > maxLevel
        # maxLevel = util.max_level(user.setting.hall, bD[name]['required town hall'])
        uc = bD[name]['upgrade cost']
        ut = bD[name]['upgrade time']
        $scope.detail[name][index] =
            idx: $scope.detail[name][index].idx
            level: currentLevel
            nextUpgrade: nextUpgrade(currentLevel, maxLevel, ut, uc)
        if oldLevel != currentLevel
            user.building[name][$scope.detail[name][index].idx] = currentLevel
            $scope.summary = util.totalCostTime(category, user)
            if ($scope.isResource)
                $scope.totalProduction = util.totalProduction(user)
            userFactory.set([{'action':'changeBuilding','data':{name:name,index:$scope.detail[name][index].idx,level:currentLevel}}], user)

    $scope.timeWithBuilder = (time, builder, maxTime) ->
        # console.log($scope.longRequiredTime, $scope.requiredTime)
        # time = lodash.max([$scope.requiredTime/$scope.builder, $scope.longRequiredTime])
        max = lodash.max([time/builder, maxTime])
        return util.timeStr(max)

    $scope.setHall = (hall) ->
        $scope.hall = user.setting.hall = hall
        userFactory.set([{'action':'setting', 'data':{name:'hall',value:user.setting.hall}}], user)
        update()

    $scope.setBuilder = (builder) ->
        $scope.builder = user.setting.builder = builder
        userFactory.set([{'action':'setting', 'data':{name:'builder', value:builder}}], user)

    $scope.setHideDoneBuilding = (flag) ->
        user.setting.hideDoneBuilding = $scope.hideDoneBuilding = flag
        # console.log($scope.hideDoneBuilding, $scope.hideDoneResearch);
        userFactory.set([{'action':'setting', 'data':{name:'hideDoneBuilding', value:$scope.hideDoneBuilding}}], user)

    $scope.setHideDoneResearch = (flag) ->
        user.setting.hideDoneResearch = $scope.hideDoneResearch = flag
        userFactory.set([{'action':'setting', 'data':{name:'hideDoneResearch', value:$scope.hideDoneResearch}}], user)

    $scope.upgrade = (name, title, index) ->
        idx = $scope.detail[name][index].idx
        level = user.building[name][idx] ? 0
        user.upgrade ?= []
        find = lodash.findIndex(user.upgrade, {
            name: name,
            index: idx
        })
        if (find < 0)
            upgradeNum = lodash.filter user.upgrade, (u) ->
                return u.index >= 0
            if (user.setting.builder <= upgradeNum.length)
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

        util.showUpgradeModal($modal, $scope.upgradeAction, name, title, level+1, index, value, ut[level], (find>=0))

    $scope.upgradeAction = (name, title, index, level, value) ->
        idx = $scope.detail[name][index].idx
        level = user.building[name][idx] ? 0
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
            userFactory.set([{'action':'removeUpgrade','data':{name:name,index:idx}}],user)
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
            userFactory.set([{'action':'changeUpgrade','data':{name:name,title:title,index:idx,level:level+1,time:ut[level],due:due}}],user)
            level++
        maxLevel = util.max_level(user.setting.hall, bD[name]['required town hall'])
        uc = bD[name]['upgrade cost']
        $scope.detail[name][index].nextUpgrade = nextUpgrade(level, maxLevel, ut, uc)
        $scope.summary = util.totalCostTime(category, user)
        if ($scope.isResource)
            $scope.totalProduction = util.totalProduction(user)
    $scope.removeUpgrade = (name, index) ->
        lodash.remove(user.upgrade, {
               name: name,
               index: index
        })
        level = $scope.detail[name][index].level
        $scope.detail[name][index].upgradeIdx = -1
        maxLevel = util.max_level(user.setting.hall, bD[name]['required town hall'])
        ut = bD[name]['upgrade time']
        uc = bD[name]['upgrade cost']
        $scope.detail[name][index].nextUpgrade = nextUpgrade(level, maxLevel, ut, uc)
        $scope.summary = util.totalCostTime(category, user)
        $scope.researchSummary = util.totalResearchCostTime(user)
        if ($scope.isResource)
            $scope.totalProduction = util.totalProduction(user)
        userFactory.set([{'action':'removeUpgrade','data':{name:name,index:index}}],user)

    $scope.pString = ->
        "may replace elixirs for walls"

    changeToMaxHall = (setuphall) ->
        for item in util.building_list('all')
            name = util.cannonicalName(item)
            availableNum = bD['number available'][name][setuphall-1]

            maxLevel = util.max_level(setuphall, bD[name]['required town hall'])
            user.building[name] ?= []
            for i in [0..bD['number available'][name].length-1]
                find = lodash.findIndex user.upgrade,
                    name: name,
                    index:  i
                if find < 0
                    if (i < availableNum)
                        user.building[name][i] = maxLevel
                    else user.building[name][i] = 0

        for item in util.hero_list()
            name = util.cannonicalName(item)
            maxLevel = util.max_level(setuphall, hD[name]['required town hall'])
            find = lodash.findIndex user.upgrade,
                name: name,
                index: HEROFLAG
            if find < 0
                if (maxLevel < 1)
                    user.hero[name] = 0
                else
                    user.hero[name] = maxLevel

        labLevel = util.max_level(setuphall, bD['laboratory']['required town hall'])
        for item in util.research_list()
            name = util.cannonicalName(item)
            maxLevel = util.max_level(labLevel, rD[name]['laboratory level'])
            find = lodash.findIndex user.upgrade,
                name: name,
                index: -1
            if (find < 0)
                if (maxLevel < 1)
                    user.research[name] = 0
                else
                    user.research[name] = maxLevel

        name = util.cannonicalName('Walls')
        for i in [0..bD['number available'][name].length-1]
            user.walls[i] = 0
        maxWallsLevel = util.max_level(setuphall, bD[name]['required town hall'])
        user.walls[maxWallsLevel-1] = bD['number available'][name][maxWallsLevel-1]

        $scope.hall = user.setting.hall = setuphall
        update()

        userFactory.set([{'action':'setuphall','data':user}],user)

    $scope.changeSetupHall = (setuphall) ->
        user.setting.setuphall = setuphall
        userFactory.set([{'action':'setting', 'data':{name:'setuphall',value:user.setting.setuphall}}], user)

    $scope.changeToMaxHall= (setuphall) ->
        m = $modal.open
            templateUrl: 'myYesNoContent.html'
            controller: 'YesNoCtrl'

        m.result.then (v) ->
            changeToMaxHall(setuphall) if v

    $scope.deleteUpgrade = (u) ->
        lodash.remove user.upgrade,
            name: u.name,
            index: u.index
        userFactory.set([{'action':'removeUpgrade','data':{name:u.name,index:u.index}}],user)

    util.registerTimer($interval, $scope, user, update)

