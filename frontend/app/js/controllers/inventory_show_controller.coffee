angular.module('app').controller 'InventoryShowCtrl', ($scope, PurchaseService,ProviderService,$sce,CurrentUser) ->
  #Get the current inventory from the sessionStorage using the Inventory Service
  $scope.purchase = PurchaseService.restoreState()
  $scope.provider = null
  $scope.barcode_html = $sce.trustAsHtml($scope.purchase.barcode_html)
  $scope.current_user =  null


  #TODO: refactor grams and fine_grams notation
  $scope.total_fine_grams =  $scope.purchase.gold_batch.grams
  $scope.fine_gram_unit_price =  $scope.purchase.price / $scope.total_fine_grams
  $scope.price =  $scope.purchase.price
  
  CurrentUser.get().success (data)->
    $scope.current_user = data
    console.log data

  #TODO: refactor grams and fine_grams notation
  $scope.total_fine_grams =  $scope.purchase.gold_batch.grams
  $scope.fine_gram_unit_price =  $scope.purchase.price / $scope.total_fine_grams
  $scope.price =  $scope.purchase.price
  console.log $scope.purchase
  CurrentUser.get().success (data)->
    $scope.current_user = data
    
  #Get the provier using the api

  ProviderService.retrieveProviderById.get {providerId: $scope.purchase.provider.id}, (provider)->
    $scope.provider = provider
  