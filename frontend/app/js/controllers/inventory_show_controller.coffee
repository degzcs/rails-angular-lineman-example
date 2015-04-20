angular.module('app').controller 'InventoryShowCtrl', ($scope,Inventory, PurchaseService,ProviderService) ->
  currentInventory = Inventory.getCurrent()
  console.log(currentInventory)
  
  PurchaseService.get(currentInventory.purchase_id).success (data) ->
    $scope.inventory = data
    getProvider()
    console.log($scope.inventory)
    return


  getProvider = ->
    ProviderService.retrieveProviderById.get {providerId: $scope.inventory.provider.id}, (provider)->
      $scope.provider = provider
      console.log($scope.provider)