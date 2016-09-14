angular.module('app').controller 'InventoryShowSaleCtrl', ($scope, SaleService, GoldBatchService, $mdDialog, CurrentUser, LiquidationService, User, CourierService, PurchaseService, $sce, PdfService) ->
  #
  # Deletes the last liquidation
  LiquidationService.deleteState()

  #
  #
  #Get info
  currentSale = SaleService.restoreState()
  $scope.soldBatches = currentSale.sold_batches
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
    $scope.currentCourier = courier
