angular.module('app').controller 'InventoryShowSaleCtrl', ($scope, SaleService, GoldBatchService,$mdDialog, CurrentUser, LiquidationService,User,CourierService,ProviderService,PurchaseService,$sce,PdfService) ->
  #
  # Deletes the last liquidation
  LiquidationService.deleteState()

  #
  #
  #Get info
  currentSale = SaleService.restoreState()
  $scope.soldBatches = currentSale.sold_batches
  console.log(currentSale)
  $scope.associatedPurchases = currentSale.associatedPurchases
  $scope.price = currentSale.price
  $scope.totalAmount = currentSale.totalAmount
  $scope.barcode_html = $sce.trustAsHtml(currentSale.barcode_html)
  $scope.code = currentSale.code
  $scope.currentClient = null
  $scope.currentUser = null
  $scope.purchase_files_collection = currentSale.purchase_files_collection
  $scope.proof_of_sale = currentSale.proof_of_sale

  

  #
  # get Client
  User.get(currentSale.buyer_id).success (buyer)->
    $scope.currentClient = buyer

  #
  # get current user info
  CurrentUser.get().success (user) ->
    $scope.currentUser = user
  #
  # get Courier
  $scope.client = CourierService.retrieveCourierById.get {courierId: currentSale.courier_id}, (courier)->
    console.log(courier)
    $scope.currentCourier = courier

  $scope.getSalePDF = ->
    console.log "Generar pdf"
    PdfService.createSaleInvoice(currentSale.id)


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

