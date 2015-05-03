angular.module('app').controller 'InventoryShowCtrl', ($scope, PurchaseService,ProviderService) ->
  #Get the current inventory from the sessionStorage using the Inventory Service
  currentInventory = PurchaseService.restoreState()
  console.log(currentInventory)
  
  #Get the purchase object using the api
  PurchaseService.get(currentInventory.purchase_id).success (data) ->
    $scope.inventory = data
    getProvider()
    console.log($scope.inventory)
    return

  #Get the provier using the api
  getProvider = ->
    ProviderService.retrieveProviderById.get {providerId: $scope.inventory.provider.id}, (provider)->
      $scope.provider = provider
      console.log($scope.provider)