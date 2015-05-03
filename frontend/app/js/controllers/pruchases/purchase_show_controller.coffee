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
    #IMPROVE: I Set up Missing values to generate the Purchase invoice but this values have to be creted in the DB and return them by the API endpoint
    data.nit = '123456789456123'
    data.rucom_record = 6547896321
    data.office = 'TrazOro Popayan'
    data.address = 'Calle falsa 123'
    data.phone = '3007854214'
    $scope.current_user = data

  #
  # Fuctions
  #

  $scope.flushData =->
    PurchaseService.deleteState()
    GoldBatchService.deleteState()

    PurchaseService.model =
      price: 0
      seller_picture: ''
      provider: {}
      origin_certificate_sequence: ''
      origin_certificate_file: ''
      fine_gram_unit_price: 0 # this is set up for current buyer (currently logged user )
      reference_code: ''
      barcode_html: ''
      code: ''

    GoldBatchService.model =
      parent_batches: ''
      grade: 1
      grams: 0 # the introduced grams  by the seller or provider
      castellanos: 0
      ozs: 0
      tomines: 0
      riales: 0
      inventory_id: 1
      total_grams: 0
      total_fine_grams: 0

    console.log 'deleting sessionStorage ...'

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
