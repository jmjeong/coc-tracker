'use strict'

angular.module 'cocApp'
.controller 'UpgradeCtrl', ($scope, $filter, util, lodash,  data, HEROFLAG, ngTableParams) ->

    user = data.user
    $scope.viewname = data.viewname
    $scope.timeStr = util.timeStr
    $scope.costFormat = util.costFormat

    $scope.title = user.name

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

            continue if (level >= maxLevel)
            findEntry = lodash.findIndex(data, {
                name: item+' - Lev'+(level+1)
            })
            continue if (findEntry >= 0)
            data.push({
                name: item+' - Lev'+(level+1)
                time: ut[level]
                costg: uc[level][0]
                coste: uc[level][1]
                costd: uc[level][2]
                upgrade: findUpgrade>=0
            })
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
        continue if (level >= maxlevel)
        ut = rD[name]['research time'][level]
        uc = rD[name]['research cost'][level]
        darkUnit = rD[name]['barracks type']=='Dark'
        data.push
            name: item+' - Lev'+(level+1)
            time: ut*60
            costg: 0
            coste: if darkUnit then 0 else uc
            costd: if darkUnit then uc else 0
            upgrade: findUpgrade>=0
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
            name: item+' - Lev'+(level+1)
            time: hD[name]['training time'][level]
            costg: 0
            coste: 0
            costd: hD[name]['training cost'][level]
            upgrade: findUpgrade>=0
    $scope.tableParams = new ngTableParams
        page: 1
        count: 100
        sorting:
            name: 'asc'
    ,
        total: 1
        counts: []
        getData: ($defer, params) ->
            orderedData = if params.sorting() then $filter('orderBy')(data, params.orderBy()) else data
            $defer.resolve(orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count()))
