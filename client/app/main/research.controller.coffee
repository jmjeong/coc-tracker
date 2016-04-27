'use strict'

angular.module('cocApp')
.controller 'ResearchCtrl', ($scope, $modal, $interval, util, lodash, ngToast, userFactory, data) ->
    # user = userFactory.get()

    user = data.user
    $scope.readonlyName = data.readonlyName

    $scope.costStr = util.costStr
    $scope.timeStr = util.timeStr
    $scope.costFormat = util.costFormat
    $scope.upgradeList = user.upgrade
    $scope.limitTo = user.setting.limitTo
    $scope.remainTime = util.remainTime
    $scope.timeStrMoment = util.timeStrMoment

    labLevel = util.max_level(user.setting.hall, bD['laboratory']['required town hall'])

    nextUpgrade = (current, maxLevel, timeArray, costArray, type) ->
        return {} if (current >= maxLevel)
        switch type
            when 'Dark' then type = 'd'
            else type = 'e'
        data = []
        for i in [current..maxLevel-1]
            data.push([i+1, costArray[i], timeArray[i]*60])
        return {
        type: type
        data: data
        }

    update = () ->
        $scope.data = []
        for title in util.research_list()
            name = util.cannonicalName(title)
            user.research ?= {}
            user.research[name] ?= 0
            maxlevel = util.max_level(labLevel, rD[name]['laboratory level'])
            continue if (maxlevel < 1)
            find = lodash.findIndex(user.upgrade, {
                name: name,
                index: -1
            })
            continue if (user.setting.hideDoneResearch && user.research[name] >= maxlevel && find < 0)

            level = user.research[name]
            level++ if find >= 0
            $scope.data.push
                title: title
                name: name
                level: user.research[name]
                maxLevel: maxlevel
                nextUpgrade: nextUpgrade(level, maxlevel,
                    rD[name]['research time'], rD[name]['research cost'],
                    rD[name]['barracks type'])
                upgradeIdx: find
        $scope.summary = util.totalResearchCostTime(user)

    update()

    $scope.changeLevel = (name, index, inc, maxLevel) ->
        currentLevel = oldLevel = $scope.data[index].level
        currentLevel += inc
        currentLevel = 0 if currentLevel < 0
        currentLevel = maxLevel if currentLevel > maxLevel
        # console.log(name)
        # console.log(rD[name]['research time'] )
        $scope.data[index].level = currentLevel
        $scope.data[index].nextUpgrade = nextUpgrade(currentLevel, maxLevel,
            rD[name]['research time'], rD[name]['research cost'],
            rD[name]['barracks type'])
        if oldLevel != currentLevel
            user.research[name] = currentLevel
            $scope.summary = util.totalResearchCostTime(user)
            userFactory.set([{'action':'changeResearch', 'data':{name:name,level:currentLevel}}], user)

    $scope.upgrade = (name, title, index) ->
        level = user.research[name] ? 0
        user.upgrade ?= []

        find = lodash.findIndex(user.upgrade, {
            name: name,
            index: -1
        })
        if (find < 0)
            upgradeNum = lodash.filter user.upgrade, (u) ->
                return u.index < 0
            if (upgradeNum.length >= 1)
                ngToast.create(
                    className: 'warning'
                    content: 'research in progress...')
                return

        ut = rD[name]['research time']
        if (find >= 0)
            due = moment(user.upgrade[find].due)
            value = parseInt(moment.duration(due.diff(moment())).asMinutes())
        else
            value = ut[level]*60

        util.showUpgradeModal($modal, $scope.upgradeAction, name, title, level+1, index, value, ut[level]*60, (find>=0))

    $scope.upgradeAction = (name, title, index, level, value) ->
        level = user.research[name] ? 0
        user.upgrade ?= []

        find = lodash.findIndex(user.upgrade, {
            name: name,
            index: -1
        })
        ut = rD[name]['research time']
        if (value < 0)
            lodash.remove(user.upgrade, {
                name: name
                index: -1
            })
            $scope.data[index].upgradeIdx = -1
            userFactory.set([{'action':'removeUpgrade','data':{name:name,index:-1}}],user)
        else
            due = new moment()
            due = due.add(value, 'minutes')
            if (find < 0)
                user.upgrade.push(
                    name: name
                    title: title
                    index: -1
                    level: level+1
                    time: ut[level]*60
                    due: due
                )
                $scope.data[index].upgradeIdx = user.upgrade.length-1
            else
                user.upgrade[find] =
                    name: name
                    title: title
                    index: -1
                    level: level+1
                    time: ut[level]*60
                    due: due
                $scope.data[index].upgradeIdx = find
            userFactory.set([{'action':'changeUpgrade','data':{name:name,title:title,index:-1,level:level+1,time:ut[level]*60,due:due}}],user)
            level++
        maxlevel = util.max_level(labLevel, rD[name]['laboratory level'])
        $scope.data[index].nextUpgrade = nextUpgrade(level, maxlevel,
            rD[name]['research time'], rD[name]['research cost'],
            rD[name]['barracks type'])
        $scope.summary = util.totalResearchCostTime(user)

    $scope.popover = (name, level) ->
        ret = ''
        if (rD[name]['dps'])
            ret += 'dps:'
            ret += rD[name]['dps'][level-1]
            ret += '('+parseInt((rD[name]['dps'][level-1]-rD[name]['dps'][level-2])*100/rD[name]['dps'][level-2])+'%)' if level>1
            ret += '    '
        if (rD[name]['hps'])
            ret += 'hps:'
            ret += rD[name]['hps'][level-1]
            ret += '('+parseInt((rD[name]['hps'][level-1]-rD[name]['hps'][level-2])*100/rD[name]['hps'][level-2])+'%)' if level>1
            ret += '    '
        if (rD[name]['hitpoints'])
            ret += 'hp:'
            ret += rD[name]['hitpoints'][level-1]
            ret += '('+parseInt((rD[name]['hitpoints'][level-1]-rD[name]['hitpoints'][level-2])*100/rD[name]['hitpoints'][level-2])+'%)' if level>1
            ret += '    '

    util.registerTimer($interval, $scope, user, update)
