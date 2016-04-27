angular.module('cocApp')
.controller 'ModalInstanceCtrl', ($scope, $modalInstance, data) ->
    $scope.title = data.title
    $scope.level = data.level
    $scope.sliderMax = data.sliderMax
    $scope.sliderValue = data.sliderValue
    $scope.update = data.update

    dhm = (value) ->
        d = moment.duration({ minutes: value})
        [d.days(), d.hours(), d.minutes()]
    minutes = (d,h,m) ->
        d*24*60+h*60+m

    timeStr = (value) ->
        val = dhm(value)

        if (val[0]==0)
            val[1] + 'h ' + val[2] + 'm'
        else
            val[0] + 'd ' + val[1] + 'h'

    $scope.changeInput = () ->
        $scope.sliderValue = minutes($scope.day, $scope.hour, $scope.minute)

    $scope.origin = timeStr(data.sliderMax)
    $scope.changed = $scope.origin

    $scope.ok = ()->
        $modalInstance.close($scope.selected)
    $scope.stop = ()->
        $modalInstance.close(-1)
    $scope.cancel = ()->
        $modalInstance.dismiss('cancel')
    $scope.format = (value)->
        timeStr(value)
    $scope.sliderDelegate = (value, $event) ->
        $scope.changed = timeStr(value)
        $scope.selected = value
        val = dhm(value);
        $scope.day = val[0]
        $scope.hour = val[1]
        $scope.minute = val[2]
