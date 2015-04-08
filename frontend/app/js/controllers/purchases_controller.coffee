angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, MeasureConverterService, ProviderService) ->
  #
  # Instances
  #
  # $scope.purchase.model = PurchaseService.restoreState
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  $scope.totalGrams = 0
  $scope.providers  = []

  #Set $scope.providers
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
      $scope.providers.push prov
      i++
  ), (error) ->

  window.m = $scope.purchase.model
  #
  # Fuctions
  #
  $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()

  # Watch and setup measures and total price
  $scope.$watch '[goldBatch.model.castellanos,  goldBatch.model.ozs, goldBatch.model.tomines, goldBatch.model.riales]', ->

    #Convertions
    $scope.castellanosToGrams = MeasureConverterService.castellanosToGrams($scope.goldBatch.model.castellanos)
    $scope.ozsToGrams = MeasureConverterService.ozsToGrams($scope.goldBatch.model.ozs)
    $scope.tominesToGrams = MeasureConverterService.tominesToGrams($scope.goldBatch.model.tomines)
    $scope.rialesToGrams = MeasureConverterService.rialesToGrams($scope.goldBatch.model.riales)
    $scope.goldBatch.model.grams = $scope.castellanosToGrams + $scope.ozsToGrams + $scope.tominesToGrams + $scope.rialesToGrams
    #Price
    $scope.purchase.model.price = $scope.goldBatch.model.grams * $scope.goldBatch.gramUnitPrice


  $scope.saveState= ->
    console.log('saving purchase state on sessionStore ... ')
    $scope.purchase.saveState()
    $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()
    $scope.goldBatch.saveState()


  # Create a new purschase in the server
  $scope.create = (data) ->
    PurchaseService.create $scope.purchase.model, $scope.goldBatch.model

