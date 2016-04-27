'use strict'

angular.module('cocApp')
.controller 'HeroCtrl', ($scope, $modal, $interval, util, lodash, ngToast, userFactory, HEROFLAG, data) ->
    user = data.user

    $scope.readonlyName = data.readonlyName
    $scope.costStr = util.costStr
    $scope.timeStr = util.timeStr
    $scope.costFormat = util.costFormat
    $scope.upgradeList = user.upgrade
    $scope.limitTo = user.setting.limitTo
    $scope.remainTime = util.remainTime
    $scope.timeStrMoment = util.timeStrMoment

    nextUpgrade = (current, maxLevel, timeArray, costArray, type) ->
        return {} if (current >= maxLevel)
        data = []
        for i in [current..maxLevel-1]
            data.push([i+1, costArray[i], timeArray[i]])
        return {
        type: type
        data: data
        }

    update = () ->
        $scope.data = []
        for title in util.hero_list()
            name = util.cannonicalName(title)
            user.hero ?= {}
            user.hero[name] ?= 0

            maxlevel = util.max_level(user.setting.hall, hD[name]['required town hall'])
            continue if (maxlevel <= 1)
            find = lodash.findIndex(user.upgrade, {
                name: name,
                index: HEROFLAG
            })
            continue if (user.setting.hideDoneBuilding && user.hero[name] >= maxlevel && find < 0)
            level = user.hero[name]
            level++ if find >= 0
            $scope.data.push
                title: title
                name: name
                level: user.hero[name]
                maxLevel: maxlevel
                nextUpgrade: nextUpgrade(level, maxlevel,hD[name]['training time'], hD[name]['training cost'], hD[name]['cost type'])

                upgradeIdx: find

        $scope.summary = util.totalHeroCostTime(user)
    update()

    $scope.timeWithBuilder = (time, builder, maxTime) ->
        max = lodash.max([time/builder, maxTime])
        return util.timeStr(max)

    $scope.changeLevel = (name, index, inc, maxLevel) ->
        currentLevel = oldLevel = $scope.data[index].level
        currentLevel += inc
        currentLevel = 0 if currentLevel < 0
        currentLevel = maxLevel if currentLevel > maxLevel
        $scope.data[index].level = currentLevel
        $scope.data[index].nextUpgrade = nextUpgrade(currentLevel, maxLevel,
                                                     hD[name]['training time'], hD[name]['training cost'],'d')
        if oldLevel != currentLevel
            user.hero[name] = currentLevel
            $scope.summary = util.totalHeroCostTime(user)
            userFactory.set([{'action': 'changeHero', data: {name:name,level:currentLevel}}], user)

    $scope.upgrade = (name, title, index) ->
        level = user.hero[name] ? 0
        user.upgrade ?= []

        find = lodash.findIndex(user.upgrade, {
            name: name,
            index: HEROFLAG
        })
        if (find < 0)
            upgradeNum = lodash.filter user.upgrade, (u) ->
                return u.index >= 0
            if (user.builder <= upgradeNum.length)
                ngToast.create(
                    className: 'warning'
                    content: 'need more builders...')
                return

        ut = hD[name]['training time']
        if (find >= 0)
            due = moment(user.upgrade[find].due)
            value = parseInt(moment.duration(due.diff(moment())).asMinutes())
        else
            value = ut[level]

        util.showUpgradeModal($modal, $scope.upgradeAction, name, title, level+1, index, ut[level], value, (find>=0))

    $scope.upgradeAction = (name, title, index, level, value) ->
        level = user.hero[name] ? 0
        user.upgrade ?= []

        find = lodash.findIndex(user.upgrade, {
            name: name,
            index: HEROFLAG
        })
        ut = hD[name]['training time']
        if (value < 0)
            lodash.remove(user.upgrade, {
                name: name
                index: HEROFLAG
            })
            $scope.data[index].upgradeIdx = -1
            userFactory.set([{'action':'removeUpgrade','data':{name:name,index:HEROFLAG}}],user)
        else
            due = new moment()
            due = due.add(value, 'minutes')

            if (find < 0)
                user.upgrade.push(
                    name: name
                    title: title
                    index: HEROFLAG
                    level: level+1
                    time: ut[level]
                    due: due
                                 )
                $scope.data[index].upgradeIdx = user.upgrade.length-1
            else
                user.upgrade[find] =
                    name: name
                    title: title
                    index: HEROFLAG
                    level: level+1
                    time: ut[level]
                    due: due
                $scope.data[index].upgradeIdx = find
            userFactory.set([{'action':'changeUpgrade', 'data':{name:name,title:title,index:HEROFLAG,level:level+1,time:ut[level],due:due}}],user)
            level++
        maxlevel = util.max_level(user.setting.hall, hD[name]['required town hall'])
        $scope.data[index].nextUpgrade = nextUpgrade(level, maxlevel,
                                                     hD[name]['training time'], hD[name]['training cost'],'d')
        $scope.summary = util.totalHeroCostTime(user)

    $scope.popover = (name, level) ->
        ret = ''
        if (hD[name]['dps'])
            ret += 'dps:'
            ret += hD[name]['dps'][level-1]
            ret += '(+'+(hD[name]['dps'][level-1]-hD[name]['dps'][level-2])+')' if level>1
            ret += '    '
        if (hD[name]['hitpoints'])
            ret += 'hp:'
            ret += hD[name]['hitpoints'][level-1]
            ret += '(+'+(hD[name]['hitpoints'][level-1]-hD[name]['hitpoints'][level-2])+')' if level>1
            ret += '    '

    util.registerTimer($interval, $scope, user, update);
