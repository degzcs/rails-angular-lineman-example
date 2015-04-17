angular.module('app')
.controller 'InventoryAmountCtrl', ($scope, $filter, $window, $mdDialog,pickedItem) ->
    $scope.pickedItem = pickedItem
    $scope.selectedGrams = 0
    $scope.remainingGrams = $scope.pickedItem.inventory_remaining_amount - $scope.selectedGrams
    $scope.submitGrams = ->
      
  return

