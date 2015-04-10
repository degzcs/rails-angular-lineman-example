angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, MeasureConverterService, ProviderService, PdfService, $timeout, $q) ->
  #
  # Instances
  #
  # $scope.purchase.model = PurchaseService.restoreState
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  $scope.totalGrams = 0

  $scope.allProviders  = []
  $scope.selectedProvider = null
  $scope.searchText = null
  window.s = $scope
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
  $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()

  # Watch and setup measures and total price
  $scope.$watch '[goldBatch.model.castellanos,  goldBatch.model.ozs, goldBatch.model.tomines, goldBatch.model.riales, goldBatch.model.grams]', ->

    #Convertions
    $scope.castellanosToGrams = MeasureConverterService.castellanosToGrams($scope.goldBatch.model.castellanos)
    $scope.ozsToGrams = MeasureConverterService.ozsToGrams($scope.goldBatch.model.ozs)
    $scope.tominesToGrams = MeasureConverterService.tominesToGrams($scope.goldBatch.model.tomines)
    $scope.rialesToGrams = MeasureConverterService.rialesToGrams($scope.goldBatch.model.riales)
    $scope.grams = $scope.goldBatch.model.grams
    $scope.goldBatch.model.totalGrams = $scope.castellanosToGrams + $scope.ozsToGrams + $scope.tominesToGrams + $scope.rialesToGrams + $scope.grams
    #Price
    $scope.purchase.model.price = $scope.goldBatch.model.totalGrams * $scope.goldBatch.gramUnitPrice

  #
  # Save the values in SessionStorage
  $scope.saveState= ->
    console.log('saving purchase state on sessionStore ... ')
    $scope.purchase.saveState()
    $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()
    $scope.goldBatch.saveState()

  #
  # Create a new purschase in the server
  $scope.create = (data) ->
    PurchaseService.create $scope.purchase.model, $scope.goldBatch.model

  #
  #  Send a predefined values to create a Purchase in PDF format
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

