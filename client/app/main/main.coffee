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
    .when '/p/overview',
        redirectTo: '/'
    .when '/p/:category',
        templateUrl: 'app/main/category.html'
        controller: 'MainCtrl'
.config (localStorageServiceProvider) ->
    localStorageServiceProvider
    .setPrefix('coc-tracker')
    .setStorageType('localStorage')
.factory 'userFactory', (localStorageService) ->
    get: () ->
        user = localStorageService.get('user')
        user ?= {}
        user.upgrade ?= []
        user.hall ?= 7
        user.builder ?= 3
        user.hideDone ?= false
        user.set ?= {}
        user.set.hideDone ?= false
        user.set.hideDoneResearch ?= false
        user.limitTo ?= 5
        return user
    set: (user) ->
        localStorageService.set('user', user)
.directive 'iconGold', () ->
    restrict: 'E',
    template: '<img src="assets/images/gold.png"  width="10" style="margin: 3px">'
.directive 'iconElixir', () ->
    restrict: 'E',
    template: '<img src="assets/images/elixir.png" width="10" style="margin: 3px">'
.directive 'iconDarkelixir', () ->
    restrict: 'E',
    template: '<img src="assets/images/darkelixir.png" width="10" style="margin: 3px">'
.factory 'util', (lodash) ->
    cannonicalName =  (name) ->
        name.replace(/\s+|\'/g, '').toLowerCase()

    max_level = (level, required) ->
        for l, i in required by -1
            return i + 1 if l <= level
        return 0

    addArrays = (first, second, op) ->
        result = []
        for i in [0..first.length - 1]
            switch op
                when '+' then result.push(first[i] + second[i])
                when '-' then result.push(first[i] - second[i])
        return result

    costFormat = (cost) ->
        switch
            when cost >= 1000000 then return parseInt(cost/10000)/100 + 'M'
            when cost >= 1000 then return parseInt(cost/10)/100 + 'K'
            else return cost

    building_list = (type) ->
        result = []
        # exclude = ['Walls', 'Archer Queen Altar', 'Barbarian King Altar', "Builder's Hut"]
        exclude = ['Walls']
        for item in buildingData['list']
            continue if lodash.indexOf(exclude, item) >= 0
            name = cannonicalName item
            if (type == 'all' || buildingData[name]['type'].toLowerCase()== type.toLowerCase())
                result.push(item)
        return result

    wallCost = (current, maxLevel, costArray) ->
        doneCost = 0
        requiredCost = 0
        if (maxLevel > 0)
            for i in [0..maxLevel-1]
                if (i <= current)
                    doneCost += costArray[i][0]
                else
                    requiredCost += costArray[i][0]
        return {
        doneCost: doneCost
        requiredCost: requiredCost
        }
    upgrade_list = () ->
        return troopData.list

    return {
        building_list: building_list

        upgrade_list: upgrade_list

        totalCostTime: (type, user) ->
            requiredCost = [0,0,0]
            doneCost = [0,0,0]
            requiredTime = maxRequiredTime = 0
            doneTime = maxDoneTime = 0
            for item in building_list(type)
                name = cannonicalName(item)
                availableNum = buildingData['number available'][name][user.hall-1]
                continue if (availableNum == 0 )

                maxLevel = max_level(user.hall, buildingData[name]['required town hall'])
                uc = buildingData[name]['upgrade cost']
                ut = buildingData[name]['upgrade time']

                for i in [0..availableNum-1]
                    user[name] ?= []
                    currentLevel = user[name][i] ? 0
                    find = lodash.findIndex(user.upgrade, {
                        name: name,
                        index:  i
                    })
                    mrt = mdt = 0
                    for k in [0..maxLevel-1]
        # console.log(name, i, k, ut[k])
                        if k < currentLevel
                            doneCost = addArrays(doneCost, uc[k], '+')
                            doneTime += ut[k]
                            mdt += ut[k]
                        else if find >= 0 && k+1 == user.upgrade[find].level
                            doneCost = addArrays(doneCost, uc[k], '+')
                            due = moment(user.upgrade[find].due)
                            dueMin = parseInt(moment.duration(due.diff(moment())).asMinutes())

                            requiredTime += dueMin
                            mrt += dueMin
                            doneTime += ut[k]-dueMin
                            mdt += ut[k]-dueMin
        # console.log(name, i, k, dueMin, ut[k])
                        else
                            requiredCost = addArrays(requiredCost, uc[k], '+')
                            requiredTime += ut[k]
                            mrt += ut[k]
                    maxRequiredTime = lodash.max([maxRequiredTime, mrt])
                    maxDoneTime = lodash.max([maxDoneTime, mdt])
            # console.log(name, requiredCost)
            return {
            requiredCost: requiredCost
            doneCost: doneCost
            requiredTime: requiredTime
            doneTime: doneTime
            maxRequiredTime: maxRequiredTime
            maxDoneTime: maxDoneTime
            }
        totalWallCost: (user) ->
            requiredCost = 0
            doneCost = 0
            name = cannonicalName('Walls')
            user[name] ?= []

            uc = buildingData[name]['upgrade cost']
            maxLevel = max_level(user.hall, buildingData[name]['required town hall'])

            for i in [0..maxLevel-1]
                count = user[name][i] ? 0
                costVal = wallCost(i, maxLevel, uc)
                #console.log(count, costVal)
                doneCost += count * costVal.doneCost
                requiredCost += count * costVal.requiredCost
            # console.log(requiredCost, doneCost)
            return {
            requiredCost: requiredCost
            doneCost: doneCost
            }
        totalResearchCostTime: (user) ->
            requiredElixirCost = requiredDarkCost = 0
            doneElixirCost = doneDarkCost = 0
            requiredTime = doneTime = 0
            labLevel = max_level(user.hall, buildingData['laboratory']['required town hall'])

            for item in upgrade_list()
                name = cannonicalName(item)
                maxlevel = max_level(labLevel, troopData[name]['laboratory level'])
                continue if (typeof troopData[name].subtype != 'undefined' || maxlevel <= 1)
                maxLevel = max_level(labLevel, troopData[name]['laboratory level'])
                uc = troopData[name]['research cost']
                ut = troopData[name]['research time']

                level = user[name]
                find = lodash.findIndex user.upgrade,
                    name: name,
                    index: -1
                for i in [0..maxLevel-1]
                    switch troopData[name]['barracks type']
                        when 'Normal' then type = 'e'
                        else type = 'd'
                    if i < level
                        doneDarkCost += uc[i] if type == 'd'
                        doneElixirCost += uc[i] if type == 'e'
                        doneTime += ut[i]
                    else if find >= 0 && i+1 == user.upgrade[find].level
                        doneDarkCost += uc[i] if type == 'd'
                        doneElixirCost += uc[i] if type == 'e'
                        due = moment(user.upgrade[find].due)
                        dueHours = parseInt(moment.duration(due.diff(moment())).asHours())
                        requiredTime += dueHours
                        doneTime += ut[i]-dueHours
                    else
                        requiredDarkCost += uc[i] if type == 'd'
                        requiredElixirCost += uc[i] if type =='e'
                        requiredTime += ut[i]
            # console.log(name, requiredElixirCost, requiredDarkCost, requiredTime, doneTime)
            return {
            requiredCost: [0, requiredElixirCost, requiredDarkCost]
            doneCost: [0, doneElixirCost, doneDarkCost]
            requiredTime: requiredTime*60
            doneTime: doneTime*60
            }

        cannonicalName: cannonicalName

        max_level: max_level
        timeStr: (time) ->
        # console.log(time)
            retString = switch
                when time == 0 then '0'
                when time < 60 then time + 'm'
                when time < 60 * 24 then parseInt(time / 60) + 'h'
                else
                    parseInt(time / 60 / 24) + 'd'
            return retString

        costFormat: costFormat

        costStr: (costArr) ->
            for cost in costArr
                continue if cost == 0
                return costFormat(cost)
            return 0

        costType: (costArr) ->
            upgradeCostStr = ['g', 'e', 'd']
            for cost, idx in costArr
                continue if cost == 0
                return upgradeCostStr[idx]
            return ''

        addArrays: addArrays
    }
