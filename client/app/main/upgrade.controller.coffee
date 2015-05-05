'use strict'

angular.module 'cocApp'
.controller 'UpgradeCtrl', ($scope, $filter, $modal, $interval, util, lodash,  data, HEROFLAG, ngTableParams, userFactory) ->

    user = data.user
    $scope.viewname = data.viewname
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
        data = []
        for item in util.building_list('all')
            name = util.cannonicalName(item)
            availableNum = bD['number available'][name][user.hall-1]
            continue if (availableNum == 0 )

            maxLevel = util.max_level(user.hall, bD[name]['required town hall'])
            uc = bD[name]['upgrade cost']
            ut = bD[name]['upgrade time']
            for i in [0..availableNum-1]
                user[name] ?= []
                currentLevel = user[name][i] ? 0

                findUpgrade = lodash.findIndex(user.upgrade, {
                    name: name,
                    index: i
                })
                level = currentLevel
                level++ if findUpgrade >= 0

                continue if (level >= maxLevel || ut[level]==0)
                findEntry = lodash.findIndex(data, {
                    name: name
                    level: level+1
                    upgrade: findUpgrade>=0
                })
                if (findEntry >= 0)
                    data[findEntry].num++
                else
                    data.push
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
                        available: activeBuilder.length < user.builder
                        num: 1
        labLevel = util.max_level(user.hall, bD['laboratory']['required town hall'])
        for item in util.upgrade_list()
            name = util.cannonicalName(item)
            user[name] ?= 0
            maxlevel = util.max_level(labLevel, rD[name]['laboratory level'])
            continue if (typeof rD[name].subtype != 'undefined' || maxlevel <= 1)
            findUpgrade = lodash.findIndex(user.upgrade, {
                name: name,
                index: -1
            })

            level = user[name]
            level++ if findUpgrade>=0
            ut = rD[name]['research time'][level]
            uc = rD[name]['research cost'][level]
            continue if (level >= maxlevel||ut==0)
            darkUnit = rD[name]['barracks type']=='Dark'
            data.push
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
            user[name] ?= 0
            maxlevel = util.max_level(user.hall, hD[name]['required town hall'])
            continue if (maxlevel <= 1)
            findUpgrade = lodash.findIndex(user.upgrade, {
                name: name,
                index: HEROFLAG
            })
            level = user[name]
            level++ if findUpgrade>=0
            continue if (level >= maxlevel)
            data.push
                name: name
                title: item
                level: level+1
                index: HEROFLAG
                time: hD[name]['training time'][level]
                costg: 0
                coste: 0
                costd: hD[name]['training cost'][level]
                upgrade: findUpgrade>=0
                due: user.upgrade[findUpgrade].due if findUpgrade>=0
                available: activeBuilder.length < user.builder
                num: 1

        $scope.tableParams = new ngTableParams
            count: 100
            sorting:
                time: 'asc'
        ,
            counts: []
            getData: ($defer, params) ->
                orderedData = if params.sorting() then $filter('orderBy')(data, params.orderBy()) else data
                $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()))
        $scope.tableParams.reload()

    update()

    $scope.upgrade = (name, title, level, index, time) ->
        modalInstance = $modal.open
            templateUrl: 'myModalContent.html'
            controller: 'ModalInstanceCtrl',
            resolve:
                data: () ->
                    {
                    sliderValue: time
                    title: title
                    sliderMax: time
                    level: level
                    update: false
                    }
        modalInstance.result.then (value) ->
            $scope.upgradeAction(name, title, level, index, value)

    $scope.upgradeAction = (name, title, level, index, value) ->
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
        userFactory.set('changeUpgrade',[{name:name,title:title,index:index,level:level,time:value,due:due}],user)

    $scope.gemPrice = (time) ->
        time *= 60
        switch
            when time==0 then 0
            when time<=60 then 1
            when time<=3600 then parseInt((time-60)*(20-1)/(3600-60))+1
            when time<=84000 then parseInt((time-3600)*(260-20)/(86400-3600))+20
            else parseInt((time-86400)*(1000-260)/(604800-86400))+260

    util.registerTimer($interval, $scope, user, update)
