angular.module('app').controller 'SaleShowCtrl', ($scope, SaleService, GoldBatchService,$mdDialog, CurrentUser, LiquidationService,ClientService,CourierService,ProviderService,PurchaseService,$sce) ->
  #
  # Deletes the last liquidation  
  LiquidationService.deleteState()
  
  #
  #
  #Get info
  currentSale = SaleService.restoreState()
  $scope.selectedPurchases = currentSale.selectedPurchases
  #GET full info for every selected purchase from api
  console.log "Purchases"
  #PurchaseService.get_list(currentSale.selectedPurchases.length).success (data)->
  #  $scope.selectedPurchases = data

  $scope.totalAmount = currentSale.totalAmount
  $scope.barcode_html = $sce.trustAsHtml(currentSale.barcode_html)
  $scope.code = currentSale.code
  $scope.currentClient = null
  $scope.currentUser = null
  #
  # get Client
  $scope.client = ClientService.retrieveClientById.get {clientId: currentSale.client_id}, (client)->
    console.log(client)
    $scope.currentClient = client
  #
  # get current user info
  CurrentUser.get().success (user) ->
    console.log user
    $scope.currentUser = user
  #
  # get Courier
  $scope.client = CourierService.retrieveCourierById.get {courierId: currentSale.courier_id}, (courier)->
    console.log(courier)
    $scope.currentCourier = courier
  #
  # TODO: Get All providers for purchases
  ###
  i=0
  while i < $scope.selectedPurchases.length
    provider_id = $scope.selectedPurchases[i].provider.id
    ProviderService.retrieveProviderById.get {providerId: provider_id}, (provider)->
      #$scope.selectedPurchases[i].provider = provider
      $scope.selectedPurchases[i]['provider'] = provider
      console.log provider
    i++
  console.log $scope.selectedPurchases
  ###
  
