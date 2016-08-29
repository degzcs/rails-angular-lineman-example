angular.module('app').controller 'InventoryShowCtrl', ($scope, PurchaseService,ProviderService,$sce,CurrentUser,User,SaleService) ->
  #Get the current inventory from the sessionStorage using the Inventory Service
  $scope.purchase = PurchaseService.restoreState()
  $scope.seller = null
  $scope.barcode_html = $sce.trustAsHtml($scope.purchase.barcode_html)
  $scope.current_user =  null
  $scope.trazoro_batches = null


  #TODO: refactor grams and fine_grams notation
  $scope.total_fine_grams =  $scope.purchase.gold_batch.grams
  $scope.fine_gram_unit_price =  $scope.purchase.price / $scope.total_fine_grams
  $scope.price =  $scope.purchase.price

  CurrentUser.get().success (data)->
    $scope.current_user = data

  #TODO: refactor grams and fine_grams notation
  $scope.total_fine_grams =  $scope.purchase.gold_batch.grams
  $scope.fine_gram_unit_price =  $scope.purchase.price / $scope.total_fine_grams
  $scope.price =  $scope.purchase.price
  CurrentUser.get().success (data)->
    $scope.current_user = data

  #Get the provier using the api

  #TODO: Refactor seller and user seller logic

  if $scope.purchase.trazoro
    SaleService.getBatches($scope.purchase.sale_id).success (batches)->
      $scope.trazoro_batches  = batches

  User.get($scope.purchase.seller.id).success (user)->
    $scope.seller = user

