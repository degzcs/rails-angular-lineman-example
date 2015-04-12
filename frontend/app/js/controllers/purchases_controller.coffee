angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, MeasureConverterService, ProviderService, PdfService, $timeout, $q, $mdDialog) ->
  #
  # Instances
  #
  # $scope.purchase.model = PurchaseService.restoreState
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  $scope.totalGrams = 0

  $scope.allProviders  = []
  $scope.searchText = null
  $scope.message
  # window.s = $scope
  #
  # Fuctions
  #

  #
  # Search one specific provider into the allProviders array
  # @return [Array] with the matched options with the query
  $scope.searchProvider = (query)->
    console.log 'query: ' + query
    results = if query then $scope.allProviders.filter(createFilterFor(query)) else []
    results

  #
  # Create filter function for a query string, just filte by document number field
  #@returns [Function] with the provider
  createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (provider) ->
      provider.document_number.indexOf(lowercaseQuery) != -1

  #
  # all providers
  ProviderService.retrieveProviders.query {
    per_page: 100
    page: 1
  }, ((providers, headers) ->
    i = 0
    while i < providers.length
      prov =
        id: providers[i].id
        document_number: providers[i].document_number
        company_name: 'company name test'
        nit: 'NIT number'
        first_name: providers[i].first_name
        last_name: providers[i].last_name
        address: providers[i].address
        email: providers[i].email
        phone_number: providers[i].phone_number
        photo_file: providers[i].photo_file or 'http://robohash.org/' + providers[i].id
        num_rucom: providers[i].rucom.num_rucom
        rucom_record: providers[i].rucom.rucom_record
        provider_type: providers[i].rucom.provider_type
        rucom_status: providers[i].rucom.status
        mineral: providers[i].rucom.mineral
        name: providers[i].first_name + ' '+ providers[i].last_name
      $scope.allProviders.push prov
      i++
  ), (error) ->

  # Set the last picture that was took
  $scope.photo=CameraService.getLastScanImage()
  # Set the last certificate file that was took
  $scope.file=CameraService.getJoinedFile()

  if($scope.photo and CameraService.getTypeFile() == 1)
    $scope.purchase.model.seller_picture=$scope.photo
    CameraService.clearData();

  if($scope.file and CameraService.getTypeFile() == 2)
    $scope.purchase.model.origin_certificate_file=$scope.file
    CameraService.clearData();

  $scope.scanner = (type) ->
    CameraService.setTypeFile(type)

  # Watch and setup measures and total price
  $scope.$watch '[purchase.model.law, goldBatch.model.castellanos,  goldBatch.model.ozs, goldBatch.model.tomines, goldBatch.model.riales, goldBatch.model.grams]', ->

    #Convertions
    $scope.castellanosToGrams = MeasureConverterService.castellanosToGrams($scope.goldBatch.model.castellanos)
    $scope.ozsToGrams = MeasureConverterService.ozsToGrams($scope.goldBatch.model.ozs)
    $scope.tominesToGrams = MeasureConverterService.tominesToGrams($scope.goldBatch.model.tomines)
    $scope.rialesToGrams = MeasureConverterService.rialesToGrams($scope.goldBatch.model.riales)
    $scope.grams = $scope.goldBatch.model.grams
    $scope.goldBatch.model.total_grams = $scope.castellanosToGrams + $scope.ozsToGrams + $scope.tominesToGrams + $scope.rialesToGrams + $scope.grams
    # cover grams to fineGrams
    $scope.goldBatch.model.total_fine_grams = MeasureConverterService.gramsToFineGrams($scope.goldBatch.model.total_grams, $scope.purchase.model.law)
    #Price
    $scope.purchase.model.price = $scope.goldBatch.model.total_fine_grams * $scope.goldBatch.gramUnitPrice

  #
  # Save the values in SessionStorage
  $scope.saveState= ->
    console.log('saving purchase state on sessionStore ... ')
    $scope.purchase.saveState()
  #  $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()
    $scope.goldBatch.saveState()

  #
  # confirm Dialog
  $scope.showConfirm = (ev) ->
    # Appending dialog to document.body to cover sidenav in docs app
    confirm = $mdDialog.confirm()
                      .title('Desea realizar la compra?')
                      .content('Va a ser generado una compra del lote de oro segun el anterior reporte. Esta usted de acuerdo?')
                      .ariaLabel('Lucky day')
                      .ok('Si, deseo comprar')
                      .cancel('No, cancelar compra')
                      .targetEvent(ev)
    $mdDialog.show(confirm).then (->
      $scope.create()
      $scope.message = 'Su compra a sido registrada con exito'
      return
    ), ->
      console.log 'canceled'
      $scope.message = 'La compra ha sido cancelada'
      return

  #
  # Create a new purschase in the server
  $scope.create =  ->
    PurchaseService.create $scope.purchase.model, $scope.goldBatch.model

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

