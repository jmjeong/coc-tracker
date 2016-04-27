angular.module('cocApp')
.controller 'YesNoCtrl', ($scope, $modalInstance) ->
    $scope.ok = ()->
        $modalInstance.close(1)
    $scope.stop = ()->
        $modalInstance.close(0)
    $scope.cancel = ()->
        $modalInstance.dismiss('cancel')
