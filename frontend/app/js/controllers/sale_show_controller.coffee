angular.module('app').controller 'SaleShowCtrl', ($scope, SaleService, GoldBatchService, $timeout, $q, $mdDialog, CurrentUser) ->
  $scope.currentSale = SaleService.restoreState()
  console.log $scope.currentSale