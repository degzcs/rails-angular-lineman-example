angular.module('app').controller 'InventoryLiquidateCtrl', ($scope,Inventory, PurchaseService,ProviderService) ->
  sale_info = Inventory.getSaleInfo()
  $scope.selectedInventoryItems = sale_info.selected_items
  $scope.ingots_number = sale_info.ingots_number
  $scope.total_amount = sale_info.total_amount
  $scope.ingots = []
  
  i=0
  while i < $scope.ingots_number
    item = {
      law: null,
      grams: null
    }
    $scope.ingots.push(item)
    i++

