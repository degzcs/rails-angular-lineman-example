angular.module('app').controller 'SaleShowCtrl', ($scope, SaleService, GoldBatchService,$mdDialog, CurrentUser, LiquidationService,ClientService,CourierService) ->
  #
  # Deletes the last liquidation  
  LiquidationService.deleteState()
  
  #
  #
  #Get the Sale Recently created and the selected purchases
  $scope.currentSale = SaleService.restoreState()
  $scope.selectedPurchases = $scope.currentSale.selectedPurchases
  $scope.currentClient = null
  $scope.currentUser = null
  console.log $scope.selectedPurchases
  #
  # get Client
  $scope.client = ClientService.retrieveClientById.get {clientId: $scope.currentSale.client_id}, (client)->
    console.log(client)
    $scope.currentClient = client
  #
  # get current user info
  CurrentUser.get().success (user) ->
    console.log user
    $scope.currentUser = user
  #
  # get Courier
  $scope.client = CourierService.retrieveCourierById.get {courierId: $scope.currentSale.courier_id}, (courier)->
    console.log(courier)
    $scope.currentCourier = courier
  