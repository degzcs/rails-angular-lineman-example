angular.module('app').controller 'SaleShowCtrl', ($scope, SaleService, GoldBatchService, $timeout, $q, $mdDialog, CurrentUser, LiquidationService) ->
  #
  # Deletes the last liquidation  
  LiquidationService.deleteState()
  #
  #Get the Sale Recently created
  $scope.currentSale = SaleService.restoreState()
  console.log $scope.currentSale
  