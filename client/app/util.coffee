'use strict'

angular.module 'cocApp'
.factory 'userFactory', (localStorageService, $http, Auth) ->
    _id = undefined
    initUser = (user)->
        user.upgrade ?= []
        user.setting ?= {}
        user.setting.hall ?= 9
        user.setting.builder ?= 4
        user.setting.setuphall ?= 9
        user.setting.hideDoneBuilding ?= false
        user.setting.hideDoneResearch ?= false
        user.setting.limitTo ?= 5
        user.building ?= {}
        user.building.townhall ?= [user.setting.hall];
        user.hero ?= {}
        user.research ?= {}
        user.walls ?= []
        #console.log(user);

    get: (id) ->
        _id = id
        if (id)
            $http.get '/api/users/'+id+'/data'
                .then (response)->
                    # console.log(response)
                    initUser(response.data)
                    {
                        readonlyName: response.data.name
                        user: response.data
                    }
        else
            if Auth.isLoggedInAsync()
                $http.get '/api/users/me/data'
                .then (response)->
                    # console.log('logged get', response)
                    initUser(response.data)
                    {
                        readonlyName: undefined
                        user: response.data
                    }
            else
                user = localStorageService.get('user')
                user ?= {}
                initUser(user)
                {
                    readonlyName: undefined
                    user: user
                }

    getLog: (id)->
        if (id)
            $http.get '/api/users/'+id+'/log'
            .then (response)->
                {
                readonlyName: response.data.name
                log: response.data.log
                }
        else
            if Auth.isLoggedInAsync()
                $http.get '/api/users/me/log'
                .then (response)->
                    {
                    readonlyName: undefined
                    log: response.data.log
                    }
            else
                user = localStorageService.get('user')
                user ?= {}
                initUser(user)
                {
                    readonlyName: undefined
                    log: user.log
                }

    set: (actLists, user, cb) ->
        if (!_id)
            # console.log(actLists);
            if Auth.isLoggedInAsync()
                $http.post '/api/users/me/data',
                    actLists
                .success (response)->
#                    console.log(response)
                    cb && cb()
            else
                localStorageService.set('user', user)
                cb && cb()

.factory 'util', (userFactory, lodash, HEROFLAG) ->

    cannonicalName =  (name) ->
        name.replace(/\s+|\.|-/g, '').toLowerCase()

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
            when cost >= 1000000 then parseInt(cost/10000)/100 + 'M'
            when cost >= 1000 then parseInt(cost/10)/100 + 'K'
            else cost

    building_list = (type) ->
        result = []
        # exclude = ['Walls', 'Archer Queen Altar', 'Barbarian King Altar', "Builder's Hut"]
        exclude = ['Walls']
        for item in bD['list']
            continue if lodash.indexOf(exclude, item) >= 0
            name = cannonicalName item
            if (type == 'all' || bD[name]['type'].toLowerCase()== type.toLowerCase())
                result.push(item)
        return result

    wallCost = (current, maxLevel, costArray, count) ->
        doneCost = [0,0,0]
        requiredCost = [0,0,0]
        if (maxLevel > 0)
            for i in [0..maxLevel-1]
                if (i <= current)
                    doneCost = addArrays(doneCost, costArray[i], '+')
                else
                    requiredCost = addArrays(requiredCost, costArray[i], '+')
        return {
        doneCost: lodash.map(doneCost, (n)->n*count)
        requiredCost: lodash.map(requiredCost, (n)->n*count)
        }
    research_list = () ->
        rD.list

    hero_list = () ->
        hD.list

    totalHeroCostTime = (user) ->
        requiredElixirCost = requiredDarkCost = 0
        doneElixirCost = doneDarkCost = 0
        requiredTime = maxRequiredTime = 0
        doneTime = maxDoneTime = 0

        for item in hero_list()
            name = cannonicalName(item)
            maxlevel = max_level(user.setting.hall, hD[name]['required town hall'])
            continue if (maxlevel < 1)
            uc = hD[name]['training cost']
            ut = hD[name]['training time']

            level = user.hero[name]
            find = lodash.findIndex user.upgrade,
                                    name: name,
                                    index: HEROFLAG

            mrt = mdt = 0
            for i in [0..maxlevel-1]
                type = hD[name]['cost type']
                if i < level
                    doneDarkCost += uc[i] if type == 'd'
                    doneElixirCost += uc[i] if type == 'e'
                    doneTime += ut[i]
                    mdt += ut[i]
                else if find >= 0 && i+1 == user.upgrade[find].level
                    doneDarkCost += uc[i] if type == 'd'
                    doneDarkCost += uc[i] if type == 'e'
                    due = moment(user.upgrade[find].due)
                    dueMinutes = parseInt(moment.duration(due.diff(moment())).asMinutes())
                    requiredTime += dueMinutes
                    mrt += dueMinutes
                    doneTime += ut[i]-dueMinutes
                    mdt += ut[i]-dueMinutes
                else
                    requiredDarkCost += uc[i] if type == 'd'
                    requiredElixirCost += uc[i] if type == 'e'
                    requiredTime += ut[i]
                    mrt += ut[i]
            maxRequiredTime = lodash.max([maxRequiredTime, mrt])
            maxDoneTime = lodash.max([maxDoneTime, mdt])
        return {
        requiredCost: [0, requiredElixirCost, requiredDarkCost]
        doneCost: [0, doneElixirCost, doneDarkCost]
        requiredTime: requiredTime
        doneTime: doneTime
        maxRequiredTime: maxRequiredTime
        maxDoneTime: maxDoneTime
        }
    checkUpgrade= (user)->
        now = new moment()
        fired = lodash.filter user.upgrade, (u)->
            now.isAfter(moment(u.due))

        return [] if fired.length == 0
        upgradeDone = []

        user.log ?= []
        for u in fired
            if u.index == HEROFLAG
                user.hero[u.name] = u.level
                upgradeDone.push({'action': 'changeHero', data: {name:u.name,level:u.level}})
            else if u.index >= 0
                user.building[u.name][u.index] = u.level
                upgradeDone.push({'action':'changeBuilding','data':{name:u.name,index:u.index,level:u.level}})
            else
                user.research[u.name] = u.level
                upgradeDone.push({'action':'changeResearch', 'data':{name:u.name,level:u.level}})

            upgradeDone.push({'action':'removeUpgrade','data':{name:u.name,index:u.index}})
            upgradeDone.push({'action':'addLog', 'data':{title:u.title, level:u.level, complete:u.due}})
            user.log.push({title:u.title, level:u.level, complete:u.due})

#        console.log(user.log);
        lodash.remove user.upgrade, (u) ->
            now.isAfter(moment(u.due))

        return upgradeDone

    return {

    building_list: building_list

    research_list: research_list

    hero_list: hero_list

    totalCostTime: (type, user) ->
        requiredCost = [0,0,0]
        doneCost = [0,0,0]
        requiredTime = maxRequiredTime = 0
        doneTime = maxDoneTime = 0
        for item in building_list(type)
            name = cannonicalName(item)
            availableNum = bD['number available'][name][user.setting.hall-1]
            continue if (availableNum == 0 )

            maxLevel = max_level(user.setting.hall, bD[name]['required town hall'])
            uc = bD[name]['upgrade cost']
            ut = bD[name]['upgrade time']

            for i in [0..availableNum-1]
                user.building[name] ?= []
                currentLevel = user.building[name][i] ? 0
                find = lodash.findIndex user.upgrade,
                    name: name,
                    index:  i
                mrt = mdt = 0
                for k in [0..maxLevel-1]
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
                    else
                        requiredCost = addArrays(requiredCost, uc[k], '+')
                        requiredTime += ut[k]
                        mrt += ut[k]
                maxRequiredTime = lodash.max([maxRequiredTime, mrt])
                maxDoneTime = lodash.max([maxDoneTime, mdt])
        if type == 'all'
            hs = totalHeroCostTime(user)
            requiredCost = addArrays(requiredCost, hs.requiredCost, '+')
            doneCost = addArrays(doneCost, hs.doneCost, '+')
            requiredTime += hs.requiredTime
            doneTime += hs.doneTime
            maxRequiredTime = lodash.max([maxRequiredTime, hs.maxRequiredTime])
            maxDoneTime = lodash.max([maxDoneTime, hs.maxDoneTime])
        return {
        requiredCost: requiredCost
        doneCost: doneCost
        requiredTime: requiredTime
        doneTime: doneTime
        maxRequiredTime: maxRequiredTime
        maxDoneTime: maxDoneTime
        }
    totalWallCost: (user) ->
        requiredCost = doneCost = [0,0,0]
        name = cannonicalName('Walls')
        user[name] ?= []

        uc = bD[name]['upgrade cost']
        maxLevel = max_level(user.setting.hall, bD[name]['required town hall'])
        elixirLevel = (8-1)

        for i in [0..maxLevel-1]
            count = user[name][i] ? 0
            costVal = wallCost(i, maxLevel, uc, count)
            doneCost = addArrays(doneCost, costVal.doneCost, '+')
            requiredCost = addArrays(requiredCost, costVal.requiredCost, '+')

        return {
        requiredCost: requiredCost
        doneCost: doneCost
        }
    totalProduction: (user)->
        pB = ['goldmine', 'elixircollector', 'darkelixirdrill']
        result = [0,0,0]
        for name in pB
            availableNum = bD['number available'][name][user.setting.hall-1]
            continue if (availableNum == 0 )
            for i in [0..availableNum-1]
                currentLevel = user.building[name][i] ? 0
                continue if (currentLevel == 0)
                find = lodash.findIndex user.upgrade,
                    name: name,
                    index: i
                continue if (find >= 0)
                result = addArrays(result, bD[name]['production'][currentLevel-1], '+')
        lodash.map(result, (n)->n*24)
    totalResearchCostTime: (user) ->
        requiredElixirCost = requiredDarkCost = 0
        doneElixirCost = doneDarkCost = 0
        requiredTime = doneTime = 0
        labLevel = max_level(user.setting.hall, bD['laboratory']['required town hall'])

        for item in research_list()
            name = cannonicalName(item)
            maxlevel = max_level(labLevel, rD[name]['laboratory level'])
            continue if (maxlevel < 1)
            uc = rD[name]['research cost']
            ut = rD[name]['research time']

            level = user.research[name]
            find = lodash.findIndex user.upgrade,
                                    name: name,
                                    index: -1
            for i in [0..maxlevel-1]
                type = if rD[name]['barracks type'] == 'Dark' then 'd' else 'e'
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
        return {
        requiredCost: [0, requiredElixirCost, requiredDarkCost]
        doneCost: [0, doneElixirCost, doneDarkCost]
        requiredTime: requiredTime*60
        doneTime: doneTime*60
        }
    totalHeroCostTime: totalHeroCostTime
    cannonicalName: cannonicalName

    max_level: max_level
    timeStr: (time) ->
        switch
            when time == 0 || time == undefined then '0'
            when time < 60 then parseInt(time) + 'm'
            when time < 60 * 24 then parseInt(time / 60) + 'h'
            else
                day = parseInt(time/60/24)
                hour = parseInt((time-day*60*24)/60)
                if hour == 0
                    day + 'd'
                else
                    day += parseFloat((hour/24).toFixed(1))
                    day + 'd '


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

    checkUpgrade: checkUpgrade

    registerTimer: ($interval, $scope, user, cb)->
        intervalPromise = $interval ()->
            return if $scope.readonlyName
            upgradeDone = checkUpgrade(user)
            if _.size(upgradeDone) > 0
                userFactory.set(upgradeDone, user, ()->
                    cb();
                );
        , 3000
        $scope.$on '$destroy', () ->
            $interval.cancel(intervalPromise)

    showUpgradeModal: ($modal, cb, name, title, level, index, maxTime, valueTime, update) ->
        modalInstance = $modal.open
            templateUrl: 'myModalContent.html'
            controller: 'ModalInstanceCtrl',
            resolve:
                data: () ->
                    {
                        sliderValue: valueTime
                        title: title
                        sliderMax: maxTime
                        level: level
                        update: update
                    }
        modalInstance.result.then (v) ->
            cb(name, title, index, level,  v)


    remainTime: (researchDue) ->
        due = moment(researchDue)
        moment.duration(due.diff(moment())).asMinutes()

    timeStrMoment: (min) ->
        return 'Finished' if min <= 0
        moment.duration(min, 'minutes').format('d[d] h[h] m[m]')

    category: (name) ->
        for item in building_list('all')
            return 'building' if item == name
        for item in hero_list()
            return 'hero' if item == name
        for item in research_list()
            return 'research' if item == name
        return 'error'
    }

