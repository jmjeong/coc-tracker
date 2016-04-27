'use strict'

angular.module 'cocApp'
.controller 'UpgradeCtrl', ($scope, $modal, $interval, util, lodash, ngToast, userFactory, HEROFLAG, data, ngTableParams, $filter) ->

    user = data.user
    $scope.readonlyName = data.readonlyName

    $scope.timeStr = util.timeStr
    $scope.costFormat = util.costFormat

    $scope.title = user.name
    $scope.HEROFLAG = HEROFLAG

    update = ->
        if (typeof $scope.tableParams != 'undefined')
            $scope.tableParams.$params.count = 0
        activeBuilder = lodash.filter user.upgrade, (u) ->
            return u.index >= 0
        activeResearch = lodash.filter user.upgrade, (u) ->
            return u.index < 0
        dataList = []
        for item in util.building_list('all')
            name = util.cannonicalName(item)
            availableNum = bD['number available'][name][user.setting.hall-1]
            continue if (availableNum == 0 )

            maxLevel = util.max_level(user.setting.hall, bD[name]['required town hall'])
            uc = bD[name]['upgrade cost']
            ut = bD[name]['upgrade time']
            for i in [0..availableNum-1]
                user.building[name] ?= []
                currentLevel = user.building[name][i] ? 0

                findUpgrade = lodash.findIndex(user.upgrade, {
                    name: name,
                    index: i
                })
                level = currentLevel
                level++ if findUpgrade >= 0

                continue if (level >= maxLevel || ut[level]==0)
                findEntry = lodash.findIndex(dataList, {
                    name: name
                    level: level+1
                    upgrade: findUpgrade>=0
                })
                if (findEntry >= 0)
                    dataList[findEntry].num++
                else
                    dataList.push
                        title: item
                        name: name
                        level: level+1
                        index: i
                        time: ut[level]
                        costg: uc[level][0]
                        coste: uc[level][1]
                        costd: uc[level][2]
                        upgrade: findUpgrade>=0
                        due: user.upgrade[findUpgrade].due if findUpgrade>=0
                        available: activeBuilder.length < user.setting.builder
                        num: 1
        labLevel = util.max_level(user.setting.hall, bD['laboratory']['required town hall'])
        for item in util.research_list()
            name = util.cannonicalName(item)
            user.research[name] ?= 0
            maxlevel = util.max_level(labLevel, rD[name]['laboratory level'])
            continue if ( maxlevel <= 1)
            findUpgrade = lodash.findIndex(user.upgrade, {
                name: name,
                index: -1
            })

            level = user.research[name]
            level++ if findUpgrade>=0
            ut = rD[name]['research time'][level]
            uc = rD[name]['research cost'][level]
            continue if (level >= maxlevel||ut==0)
            darkUnit = rD[name]['barracks type']=='Dark'
            dataList.push
                title: item
                name: name
                level: level+1
                index: -1
                time: ut*60
                costg: 0
                coste: if darkUnit then 0 else uc
                costd: if darkUnit then uc else 0
                upgrade: findUpgrade>=0
                due: user.upgrade[findUpgrade].due if findUpgrade>=0
                available: activeResearch.length==0
                num: 1
        for item in util.hero_list()
            name = util.cannonicalName(item)
            user.hero[name] ?= 0
            maxlevel = util.max_level(user.setting.hall, hD[name]['required town hall'])
            continue if (maxlevel <= 1)
            findUpgrade = lodash.findIndex(user.upgrade, {
                name: name,
                index: HEROFLAG
            })
            level = user.hero[name]
            level++ if findUpgrade>=0
            continue if (level >= maxlevel)
            dataList.push
                name: name
                title: item
                level: level+1
                index: HEROFLAG
                time: hD[name]['training time'][level]
                costg: 0
                coste: if hD[name]['cost type'] == 'e' then hD[name]['training cost'][level] else 0
                costd: if hD[name]['cost type'] == 'd' then hD[name]['training cost'][level] else 0
                upgrade: findUpgrade>=0
                due: user.upgrade[findUpgrade].due if findUpgrade>=0
                available: activeBuilder.length < user.setting.builder
                num: 1

        $scope.tableParams = new ngTableParams
            count: 100
            sorting:
                time: 'asc'
        ,
            counts: []
            getData: ($defer, params) ->
                orderedData = if params.sorting() then $filter('orderBy')(dataList, params.orderBy()) else dataList
                $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()))
        $scope.tableParams.reload()

    update()

    $scope.upgrade = (name, title, level, index, time) ->
        util.showUpgradeModal($modal, $scope.upgradeAction, name, title, level, index, time, time, false)

    $scope.upgradeAction = (name, title, index, level, value) ->
        user.upgrade ?= []
        due = new moment()
        due = due.add(value, 'minutes')
        user.upgrade.push
            name: name
            title: title
            index: index
            level: level
            time: value
            due: due
        update()
        userFactory.set([{'action':'changeUpgrade','data':{name:name,title:title,index:index,level:level,time:value,due:due}}],user)

    $scope.gemPrice = (time) ->
        time *= 60
        switch
            when time==0 then 0
            when time<=60 then 1
            when time<=3600 then parseInt((time-60)*(20-1)/(3600-60))+1
            when time<=84000 then parseInt((time-3600)*(260-20)/(86400-3600))+20
            else parseInt((time-86400)*(1000-260)/(604800-86400))+260

    util.registerTimer($interval, $scope, user, update)
