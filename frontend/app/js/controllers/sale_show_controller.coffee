angular.module('app').controller 'SaleShowCtrl', ($scope, SaleService, GoldBatchService, $mdDialog, CurrentUser, LiquidationService, User, CourierService, PurchaseService,$sce) ->
  #
  # Deletes the last liquidation
  LiquidationService.deleteState()

  #
  #
  #Get info
  $scope.currentSale = SaleService.restoreState()
  $scope.barcode_html = $sce.trustAsHtml($scope.currentSale.barcode_html)
  $scope.currentBuyer = null
  $scope.currentUser = null
  $scope.currentCourier = null

  #
  # get Client (buyer)
  User.get($scope.currentSale.buyer.id).success (buyer)->
    $scope.currentBuyer = buyer

  #
  # get current user info
  CurrentUser.get().success (user) ->
    $scope.currentUser = user
  #
  # get Courier
  CourierService.retrieveCourierById($scope.currentSale.courier_id).success (courier)->
    $scope.currentCourier = courier

  $scope.getSalePDF = ->
    console.log "Generar pdf"
    PdfService.createSaleInvoice(currentSale.id)
