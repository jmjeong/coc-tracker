'use strict'

angular.module 'cocApp'
.factory 'userFactory', (localStorageService, upgradeConfig) ->
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
        user
    set: (user) ->
        localStorageService.set('user', user)
.factory 'util', (lodash, upgradeConfig) ->
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
        rD.list

    hero_list = () ->
        hD.list

    totalHeroCostTime = (user) ->
        requiredDarkCost = 0
        doneDarkCost = 0
        requiredTime = maxRequiredTime = 0
        doneTime = maxDoneTime = 0

        for item in hero_list()
            name = cannonicalName(item)
            maxlevel = max_level(user.hall, hD[name]['required town hall'])
            continue if (maxlevel <= 1)
            uc = hD[name]['training cost']
            ut = hD[name]['training time']

            level = user[name]
            find = lodash.findIndex user.upgrade,
                                    name: name,
                                        index: upgradeConfig.HELOFLAG

            mrt = mdt = 0
            for i in [0..maxlevel-1]
                if i < level
                    doneDarkCost += uc[i]
                    doneTime += ut[i]
                    mdt += ut[i]
                else if find >= 0 && i+1 == user.upgrade[find].level
                    doneDarkCost += uc[i]
                    due = moment(user.upgrade[find].due)
                    dueMinutes = parseInt(moment.duration(due.diff(moment())).asMinutes())
                    requiredTime += dueMinutes
                    mrt += dueMinutes
                    doneTime += ut[i]-dueMinutes
                    mdt += ut[i]-dueMinutes
                else
                    requiredDarkCost += uc[i]
                    requiredTime += ut[i]
                    mrt += ut[i]
            maxRequiredTime = lodash.max([maxRequiredTime, mrt])
            maxDoneTime = lodash.max([maxDoneTime, mdt])
        return {
        requiredCost: [0, 0, requiredDarkCost]
        doneCost: [0, 0, doneDarkCost]
        requiredTime: requiredTime
        doneTime: doneTime
        maxRequiredTime: maxRequiredTime
        maxDoneTime: maxDoneTime
        }

    return {
    building_list: building_list

    upgrade_list: upgrade_list

    hero_list: hero_list

    totalCostTime: (type, user) ->
        requiredCost = [0,0,0]
        doneCost = [0,0,0]
        requiredTime = maxRequiredTime = 0
        doneTime = maxDoneTime = 0
        for item in building_list(type)
            name = cannonicalName(item)
            availableNum = bD['number available'][name][user.hall-1]
            continue if (availableNum == 0 )

            maxLevel = max_level(user.hall, bD[name]['required town hall'])
            uc = bD[name]['upgrade cost']
            ut = bD[name]['upgrade time']

            for i in [0..availableNum-1]
                user[name] ?= []
                currentLevel = user[name][i] ? 0
                find = lodash.findIndex(user.upgrade, {
                    name: name,
                    index:  i
                })
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
        requiredCost = 0
        doneCost = 0
        name = cannonicalName('Walls')
        user[name] ?= []

        uc = bD[name]['upgrade cost']
        maxLevel = max_level(user.hall, bD[name]['required town hall'])

        for i in [0..maxLevel-1]
            count = user[name][i] ? 0
            costVal = wallCost(i, maxLevel, uc)
            doneCost += count * costVal.doneCost
            requiredCost += count * costVal.requiredCost
        return {
        requiredCost: requiredCost
        doneCost: doneCost
        }
    totalResearchCostTime: (user) ->
        requiredElixirCost = requiredDarkCost = 0
        doneElixirCost = doneDarkCost = 0
        requiredTime = doneTime = 0
        labLevel = max_level(user.hall, bD['laboratory']['required town hall'])

        for item in upgrade_list()
            name = cannonicalName(item)
            maxlevel = max_level(labLevel, rD[name]['laboratory level'])
            continue if (typeof rD[name].subtype != 'undefined' || maxlevel <= 1)
            uc = rD[name]['research cost']
            ut = rD[name]['research time']

            level = user[name]
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
            when time == 0 then '0'
            when time < 60 then time + 'm'
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

    checkUpgrade: (user)->
        now = new moment()
        fired = lodash.filter user.upgrade, (u)->
            now.isAfter(moment(u.due))
        if fired.length > 0
            for u in fired
                if u.index >= 0 && u.index != upgradeConfig.HEROFLAG
                    user[u.name][u.index] = u.level
                else
                    user[u.name] = u.level
            lodash.remove user.upgrade, (u) ->
                now.isAfter(moment(u.due))
            return 0
        else return 1

    }
