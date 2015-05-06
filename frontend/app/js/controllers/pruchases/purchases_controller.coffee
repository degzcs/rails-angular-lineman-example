angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, MeasureConverterService, ProviderService, SaleService, $timeout, $q, $mdDialog, CurrentUser, ScannerService, $location) ->

  #
  # Instances
  #
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  $scope.totalGrams = 0
  $scope.hover_image = "http://www.gravatar.com/avatar/b76f6e92d9fc0690e6886f7b9d4f32da?s=100";
  $scope.allProviders  = []
  $scope.searchText = null
  $scope.code = null
  $scope.origin_certificate_upload_type = null

  $scope.rucomIDField = 
    label: 'Número de RUCOM'
    field: 'num_rucom'

  # if $scope.purchase.model.origin_certificate_file.url
  # $scope.origin_certificate_file_name =$scope.purchase.model.origin_certificate_file.url.split('/').pop()

  CurrentUser.get().success (data) ->
  #IMPROVE: I Set up Missing values to generate the Purchase invoice but this values have to be creted in the DB and return them by the API endpoint
    data.company_name = 'TrazOro'
    data.nit = '123456789456123'
    data.rucom_record = 6547896321
    data.office = 'TrazOro Popayan'
    data.address = 'Calle falsa 123'
    data.phone = '3007854214'
    $scope.current_user = data

  window.s =  $scope

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
  # Search provider by sale code
  # @ sale_code [Integer] is the generated code when the sale is created
  # @return [Array] with the matched options with the query
  $scope.searchProviderByCode = (sale_code)->
    console.log 'query: ' + sale_code
    SaleService.get_by_code(sale_code).success (data)->
      if data
        $scope.goldBatch.model.id = data.gold_batch_id
        $scope.goldBatch.model.grade = data.grade
        $scope.purchase.model.fine_gram_unit_price = data.fine_gram_unit_price
        $scope.goldBatch.model.grams =  MeasureConverterService.fineGramsToGrams(data.grams, data.grade)
        $scope.purchase.model.sale_id =  data.id
        $scope.purchase.model.origin_certificate_file = data.origin_certificate_file
        $scope.purchase.model.provider = data.provider

  #
  #
  #
  $scope.selectedProviderChange = (provider) ->
    if provider
      console.log 'Provider changed to ' + JSON.stringify(provider)
      if provider.num_rucom
        $scope.rucomIDField.label = 'Número de RUCOM'
        $scope.rucomIDField.field = 'num_rucom'
        $scope.purchase.model.rucom_id_field = 'num_rucom'
      else if provider.rucom_record
        $scope.rucomIDField.label = 'Número de Expediente'
        $scope.rucomIDField.field = 'rucom_record'
        $scope.purchase.model.rucom_id_field = 'rucom_record'
    else
      console.log 'State changed to none'

  #
  #
  #
  $scope.formatOriginCertificate = (url) ->
    if url
      url.split('/').pop()

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
        company_name: 'company name test' # <-- TODO: migration
        document_type: 'NIT' # <-- TODO: migration
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
        city: 'Popayan'
        state: 'Cauca'
      $scope.allProviders.push prov
      i++
  ), (error) ->

  # Set the last picture that was took
  $scope.photo=CameraService.getLastScanImage()
  # Set the last certificate file that was
  if(ScannerService.getScanFiles() and ScannerService.getScanFiles().length>0)
    $scope.file= ScannerService.getScanFiles()
  else if(CameraService.getJoinedFile() and CameraService.getJoinedFile().length>0)
    $scope.file= CameraService.getJoinedFile()

  if($scope.photo and CameraService.getTypeFile() == 1)
    $scope.purchase.model.seller_picture=$scope.photo
    CameraService.clearData();

  if($scope.file and CameraService.getTypeFile() == 2)
    $scope.purchase.model.origin_certificate_file=$scope.file
    CameraService.clearData()
    ScannerService.clearData()

  $scope.scanner = (type) ->
    $scope.saveState()
    CameraService.setTypeFile(type)

  # Watch and setup measures and total price
  $scope.$watch '[goldBatch.model.grade, goldBatch.model.castellanos,  goldBatch.model.ozs, goldBatch.model.tomines, goldBatch.model.riales, goldBatch.model.grams, purchase.model.fine_gram_unit_price]', ->

    #Convertions
    $scope.castellanosToGrams = MeasureConverterService.castellanosToGrams($scope.goldBatch.model.castellanos)
    $scope.ozsToGrams = MeasureConverterService.ozsToGrams($scope.goldBatch.model.ozs)
    $scope.tominesToGrams = MeasureConverterService.tominesToGrams($scope.goldBatch.model.tomines)
    $scope.rialesToGrams = MeasureConverterService.rialesToGrams($scope.goldBatch.model.riales)
    $scope.grams = $scope.goldBatch.model.grams
    $scope.goldBatch.model.total_grams = $scope.castellanosToGrams + $scope.ozsToGrams + $scope.tominesToGrams + $scope.rialesToGrams + $scope.grams

    # cover grams to fineGrams
    $scope.goldBatch.model.total_fine_grams = MeasureConverterService.gramsToFineGrams($scope.goldBatch.model.total_grams, $scope.goldBatch.model.grade)
    #Price
    $scope.purchase.model.price = $scope.goldBatch.model.total_fine_grams * $scope.purchase.model.fine_gram_unit_price

  #
  # Flush Data
  #
  $scope.flushData =->
    PurchaseService.deleteState()
    GoldBatchService.deleteState()

    PurchaseService.model =
      type: ''
      price: 0
      # seller_picture: ''
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
    console.log 'deleting models ...'

  #
  # Save the values in SessionStorage
  $scope.saveState= ->
    console.log('saving purchase and gold batch states on sessionStore ... ')
    $scope.purchase.saveState()
    $scope.goldBatch.saveState()
  #  $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()

  #
  # confirm Dialog
  $scope.showConfirm = (ev) ->
    # Appending dialog to document.body to cover sidenav in docs app
    confirm = $mdDialog.confirm()
                      .title('Desea realizar la compra?')
                      .content('Va a ser generada una compra. Esta seguro que desea realizar esta compra?')
                      .ariaLabel('Lucky day')
                      .ok('Si, deseo comprar')
                      .cancel('No, cancelar compra')
                      .targetEvent(ev)
    $mdDialog.show(confirm).then (->
      $scope.create()
      # $scope.flushData()
      $scope.message = 'Su compra a sido registrada con exito'
      return
    ), ->
      console.log 'purchase canceled'
      $scope.message = 'La compra ha sido cancelada'
      return

  #
  # Create a new purschase register in DB
  $scope.create =  ->
    console.log 'creating purchase ...'
    PurchaseService.create $scope.purchase.model, $scope.goldBatch.model

