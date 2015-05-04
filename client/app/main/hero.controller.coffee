'use strict'

angular.module('cocApp')
.controller 'HeroCtrl', ($scope, $modal, $interval, util, lodash, ngToast, userFactory, HEROFLAG, data) ->
    user = data.user

    $scope.viewname = data.viewname
    $scope.costStr = util.costStr
    $scope.timeStr = util.timeStr
    $scope.costFormat = util.costFormat
    $scope.upgradeList = user.upgrade
    $scope.limitTo = user.limitTo
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
            user[name] ?= 0
            maxlevel = util.max_level(user.hall, hD[name]['required town hall'])
            continue if (maxlevel <= 1)
            continue if (user.set.hideDone && user[name] >= maxlevel)
            find = lodash.findIndex(user.upgrade, {
                name: name,
                index: HEROFLAG
            })
            level = user[name]
            level++ if find >= 0
            $scope.data.push
                title: title
                name: name
                level: user[name]
                maxLevel: maxlevel
                nextUpgrade: nextUpgrade(level, maxlevel,hD[name]['training time'], hD[name]['training cost'], 'd')

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
            user[name] = currentLevel
            $scope.summary = util.totalHeroCostTime(user)
            userFactory.set([{key:name, value:user[name]}], user)

    $scope.upgrade = (name, title, index) ->
        level = user[name] ? 0
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

        modalInstance = $modal.open
            templateUrl: 'myModalContent.html'
            controller: 'ModalInstanceCtrl',
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
        level = user[name] ? 0
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
            level++
        maxlevel = util.max_level(user.hall, hD[name]['required town hall'])
        $scope.data[index].nextUpgrade = nextUpgrade(level, maxlevel,
                                                     hD[name]['training time'], hD[name]['training cost'],'d')
        $scope.summary = util.totalHeroCostTime(user)
        userFactory.set([{key:'upgrade', value:user.upgrade}], user)

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
