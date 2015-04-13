angular.module('app').controller 'PurchasesShowCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, PdfService, $timeout, $q, $mdDialog, CurrentUser) ->
  #
  # Instances
  #
  # $scope.purchase.model = PurchaseService.restoreState
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  CurrentUser.get().success (data) ->
    $scope.current_user = data

  # window.s = $scope
  #
  # Fuctions
  #

  #
  #  Send calculated values to create a Purchase Renport in PDF format
  $scope.createPDF =  (purchase, provider, goldBatch)->
    goldBatchForPDF=
      castellanos: {quantity: $scope.goldBatch.model.castellanos, unit_value:  $scope.goldBatch.castellanoUnitPrice}
      tomines: {quantity: $scope.goldBatch.model.tomines, unit_value:  $scope.goldBatch.tominUnitPrice}
      riales: {quantity: $scope.goldBatch.model.riales, unit_value:  $scope.goldBatch.rialUnitPrice}
      ozs: {quantity: $scope.goldBatch.model.riales, unit_value:  $scope.goldBatch.ozUnitPrice}
      gramos: {quantity: $scope.goldBatch.model.grams, unit_value:  $scope.goldBatch.gramUnitPrice}
    provider = purchase.provider
    purchase.provider=[]

    $scope.pdfContent = PdfService.createPurchaseInvoice(purchase, provider, goldBatchForPDF)

