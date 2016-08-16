angular.module('app')
.controller 'InventoryIngotsCtrl', ($scope, $filter, $window, $mdDialog) ->
    #Main scope variables
    $scope.ingots_number = 1
    $scope.submit_ingots_number = ->
      $mdDialog.hide(parseInt($scope.ingots_number))
  return

