angular.module('app').controller 'PurchasesShowCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, PdfService, $timeout, $q, $mdDialog, CurrentUser,  $sce) ->

  #
  # Instances
  #
  PurchaseService.restoreState()
  GoldBatchService.restoreState()
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  $scope.barcode_html = $sce.trustAsHtml($scope.purchase.model.barcode_html)
  CurrentUser.get().success (data) ->
    #IMPROVE: Set up Missing values to generate the Purchase invoice
    data.company_name = 'TrazOro'
    data.nit = '123456789456123'
    data.rucom_record = 6547896321
    data.office = 'TrazOro Popayan'
    data.address = 'Calle falsa 123'
    data.phone = '3007854214'
    $scope.current_user = data

  window.s =$scope
  #
  # Fuctions
  #

  $scope.flushData =->
    sessionStorage.purchaseService = []
    sessionStorage.goldBatchService = []
    $scope.purchase = PurchaseService
    $scope.goldBatch = GoldBatchService
    $scope.barcode_html = $sce.trustAsHtml($scope.purchase.model.barcode_html)
    console.log 'deleting sessionStorage'

  #
  #  Send calculated values to create a Purchase Renport in PDF format
  $scope.createPDF =  (purchase, goldBatch, buyer)->
    goldBatchForPDF=
      castellanos: {quantity: $scope.goldBatch.model.castellanos} #TODO: add grams
      tomines: {quantity: $scope.goldBatch.model.tomines}
      riales: {quantity: $scope.goldBatch.model.riales}
      ozs: {quantity: $scope.goldBatch.model.riales}
      grams: {quantity: $scope.goldBatch.model.grams}
      total_grams:  $scope.goldBatch.model.total_grams
      total_fine_grams:  $scope.goldBatch.model.total_fine_grams
      grade: $scope.goldBatch.model.grade

    providerForPDF = purchase.provider

    purchasePDF =  purchase
    # purchasePDF.provider=[]

    $scope.pdfContent = PdfService.createPurchaseInvoice(purchasePDF, providerForPDF, goldBatchForPDF, buyer)

