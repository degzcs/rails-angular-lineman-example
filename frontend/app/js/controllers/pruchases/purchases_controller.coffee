angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, MeasureConverterService, ExternalUser, SaleService, $timeout, $q, $mdDialog, CurrentUser, ScannerService, $location,$state, $filter) ->
  #*** Loading Variables **** #
  $scope.showLoading = false
  $scope.loadingMode = "determinate"
  $scope.loadingMessage = "Registrando su compra ..."
  $scope.loadingProgress = 0
  $scope.date = $filter('date')(Date.now(), 'yyyy-MM-dd');
  #
  # Instances
  #
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  $scope.totalGrams = 0
  $scope.mineralType = 'Oro'
  $scope.measureUnit = 'Gramos Finos'
  $scope.hover_image = "http://www.gravatar.com/avatar/b76f6e92d9fc0690e6886f7b9d4f32da?s=100";
  $scope.allsellers  = []
  $scope.searchText = null
  $scope.code = null
  $scope.origin_certificate_upload_type = null
  $scope.selectedseller = null

  $scope.rucomIDField =
    label: 'Número de RUCOM'
    field: 'num_rucom'

  # if $scope.purchase.model.origin_certificate_file.url
  # $scope.origin_certificate_file_name =$scope.purchase.model.origin_certificate_file.url.split('/').pop()

  CurrentUser.get().success (data) ->
    $scope.current_user = data
    $scope.buyer_data = buyer_data_from($scope.current_user)
    window.scope = $scope

  #
  # Fuctions
  #

  buyer_data_from = (current_user)->
    if current_user.company
      {
        company_name: current_user.company.name,
        office: current_user.office,
        nit: current_user.company.nit_number,
        rucom_record: current_user.company.rucom.rucom_record,
        first_name: current_user.company.legal_representative.profile.first_name,
        last_name: current_user.company.legal_representative.profile.last_name,
        name: current_user.company.legal_representative.profile.first_name + ' ' + current_user.company.legal_representative.profile.last_name,
        address: current_user.company.address,
        document_type: 'NIT',
        document_number: current_user.company.nit_number,
        phone: current_user.company.phone_number,
        city: current_user.company.city,
        state: current_user.company.state,
      }
    else
      {
        company_name: 'NA',
        office: 'NA',
        nit: current_user.nit,
        rucom_record: current_user.rucom.num_rucom || current_user.rucom.rucom_record,
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        address: current_user.address,
        phone: current_user.phone_number,
        city: current_user.city.name
      }

  #
  # Search one specific seller into the allsellers array
  # @return [Array] with the matched options with the query

  query_for_sellers = (query) ->
    # perform some asynchronous operation, resolve or reject the promise when appropriate.
    $q (resolve, reject) ->
      ExternalUser.query_by_id(query).success (sellers)->
        $scope.allsellers = []

        i = 0
        while i < sellers.length
          prov =
            id: sellers[i].id
            document_number: sellers[i].document_number
            company_name: if sellers[i].company then sellers[i].company.name else 'Ninguna' #'company name test' # <-- TODO: migration
            document_type: if sellers[i].company then 'NIT' else 'CC' # <-- TODO: migration
            first_name: sellers[i].first_name
            last_name: sellers[i].last_name
            address: sellers[i].address
            email: sellers[i].email
            phone_number: sellers[i].phone_number || sellers[i].phone
            photo_file: sellers[i].photo_file or 'http://robohash.org/' + sellers[i].id
            num_rucom: sellers[i].rucom.num_rucom
            rucom_record: sellers[i].rucom.rucom_record
            seller_type: sellers[i].rucom.seller_type
            rucom_status: if sellers[i].rucom.status then sellers[i].rucom.status else (if sellers[i].rucom.id then 'Inscrito' else 'No Inscrito')
            mineral: sellers[i].rucom.mineral
            name: sellers[i].first_name + ' '+ sellers[i].last_name
            city: sellers[i].city || ''
            state: sellers[i].state || ''
            address: sellers[i].address
            provider_type: sellers[i].provider_type
            nit: if sellers[i].company then sellers[i].company.nit_number else "--" # <-- TODO: migration

          $scope.allsellers.push prov
          i++
        resolve $scope.allsellers

      return

  $scope.searchseller = (query)->
    if query
      promise = query_for_sellers(query)
      promise.then ((sellers) ->
        return sellers

      ), (reason) ->
        console.log 'Failed: ' + reason
        return
    else
      return []


  #
  # Search seller by sale code
  # @ sale_code [Integer] is the generated code when the sale is created
  # @return [Array] with the matched options with the query
  $scope.searchsellerByCode = (sale_code)->
    SaleService.get_by_code(sale_code).success (data)->
      if data
        $scope.goldBatch.model.id = data.gold_batch_id
        $scope.goldBatch.model.grade = data.grade
        $scope.purchase.model.fine_gram_unit_price = data.fine_gram_unit_price
        $scope.goldBatch.model.grams =  MeasureConverterService.fineGramsToGrams(data.fine_grams, data.grade)
        $scope.purchase.model.sale_id =  data.id
        $scope.purchase.model.origin_certificate_file = data.origin_certificate_file
        $scope.purchase.model.seller = data.seller

        # TODO: simplify this code
        if data.seller.num_rucom
          $scope.rucomIDField.label = 'Número de RUCOM'
          $scope.rucomIDField.field = 'num_rucom'
          $scope.purchase.model.rucom_id_field = 'num_rucom'
        else if data.seller.rucom_record
          $scope.rucomIDField.label = 'Número de Expediente'
          $scope.rucomIDField.field = 'rucom_record'
          $scope.purchase.model.rucom_id_field = 'rucom_record'
        else
          console.log 'State changed to none'


  #
  #
  #
  $scope.selectedsellerChange = (seller) ->
    console.log "Seleccionado"
    if seller
      if seller.num_rucom
        $scope.rucomIDField.label = 'Número de RUCOM'
        $scope.rucomIDField.field = 'num_rucom'
        $scope.purchase.model.rucom_id_field = 'num_rucom'
      else if seller.rucom_record
        $scope.rucomIDField.label = 'Número de Expediente'
        $scope.rucomIDField.field = 'rucom_record'
        $scope.purchase.model.rucom_id_field = 'rucom_record'
    else
      console.log 'seller changed to none'


  #
  #
  #
  $scope.formatOriginCertificate = (url) ->
    if url
      url.split('/').pop()

  #
  # Create filter function for a query string, just filte by document number field
  #@returns [Function] with the seller
  createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (seller) ->
      seller.document_number.indexOf(lowercaseQuery) != -1

  per_page = 100
  page = 1

  $scope.format_seller = (seller)->
    console.log "el rucom"
    #console.log seller.rucom
    rucom = seller.rucom
    return {
      id: seller.id
      document_number: seller.document_number
      company_name: if seller.company then seller.company.name else seller.first_name + ' ' + seller.last_name #'company name test' # <-- TODO: migration
      document_type: if seller.company then "NIT" else "CC"
      first_name: seller.first_name
      last_name: seller.last_name
      address: seller.address
      email: seller.email
      phone_number: seller.phone_number || seller.phone
      photo_file: seller.photo_file or 'http://robohash.org/' + seller.id
      num_rucom: rucom.num_rucom
      rucom_record: rucom.rucom_record
      seller_type: rucom.seller_type
      rucom_status: rucom.status
      mineral: rucom.mineral
      name: seller.first_name + ' '+ seller.last_name
      city: seller.city.name || ''
      state: seller.state.name || ''
      address: seller.address
    }

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
      seller: {}
      origin_certificate_sequence: ''
      origin_certificate_file: ''
      fine_gram_unit_price: 0 # this is set up for current buyer (currently logged user )
      reference_code: ''
      barcode_html: ''
      code: ''

    GoldBatchService.model =
      grade: 1
      grams: 0 # the introduced grams  by the seller or seller
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
  #  $scope.purchase.model.seller_photo_file=CameraService.getLastScanImage()

  #
  # confirm Dialog
  $scope.showConfirm = (ev) ->
    # Appending dialog to document.body to cover sidenav in docs app
    confirm = $mdDialog.confirm()
                      .title('Desea realizar la compra?')
                      .content('Va a ser generada una compra. Esta seguro que desea realizar esta compra?')
                      .ok('Si, deseo comprar')
                      .cancel('No, cancelar compra')
                      .targetEvent(ev)
    $mdDialog.show(confirm).then (->
      $scope.create(ev)
      # $scope.flushData()
      $scope.message = 'Su compra esta siendo procesada ...'
      #PurchaseService.flushModel() #  =>  Flush the model
      return
    ), ->
      console.log 'purchase canceled'
      $scope.message = 'La compra ha sido cancelada'
      return

  #
  # Create a new purschase register in DB
  $scope.create = (ev) ->
    console.log 'creating purchase ...'
    PurchaseService.create $scope.purchase.model, $scope.goldBatch.model
    $scope.showUploadingDialog(ev)

  #
  # Show dialog displaying file uploading progress
  $scope.showUploadingDialog = (ev) ->
    $scope.showLoading = true
    $scope.loadingMessage = "Subiendo archivos ..."
    $scope.$watch (->
      PurchaseService.impl.uploadProgress
    ), (newVal, oldVal) ->
      if typeof newVal != 'undefined'
        $scope.loadingProgress = PurchaseService.impl.uploadProgress
        if $scope.loadingProgress == 100
          $scope.abortCreate = true
          $scope.loadingMessage = "Espere un momento ..."
          $scope.loadingMode = "indeterminate"
      return

  $scope.infoAlert = (title, content, error) ->
    $mdDialog.show($mdDialog.alert().title(title).content(content).ok('OK')).finally ->
      #if !error
        #$state.go 'index_inventory'
      #return
    return

  $scope.createseller = ->
    sellerService.setCallerState('new_purchase.step1')
    $state.go('search_rucom',{type: 'seller'})

  $scope.getQuery = (query)->
    ExternalUser.query_by_id(query).success( (sellers)->
      $scope.allsellers = []

      i = 0
      while i < sellers.length
        prov =
          id: sellers[i].id
          document_number: sellers[i].document_number
          company_name: if sellers[i].company then sellers[i].company.name else 'Ninguna' #'company name test' # <-- TODO: migration
          document_type: if sellers[i].company then 'NIT' else 'CC' # <-- TODO: migration
          first_name: sellers[i].first_name
          last_name: sellers[i].last_name
          address: sellers[i].address
          email: sellers[i].email
          phone_number: sellers[i].phone_number || sellers[i].phone
          photo_file: sellers[i].photo_file or 'http://robohash.org/' + sellers[i].id
          num_rucom: sellers[i].rucom.num_rucom
          rucom_record: sellers[i].rucom.rucom_record
          seller_type: sellers[i].rucom.seller_type
          rucom_status: sellers[i].rucom.status
          mineral: sellers[i].rucom.mineral
          name: sellers[i].first_name + ' '+ sellers[i].last_name
          city: sellers[i].city || ''
          state: sellers[i].state || ''
          address: sellers[i].address
          nit: if sellers[i].company then sellers[i].company.nit_number else "--" # <-- TODO: migration

        $scope.allsellers.push prov
        i++
    ).error ()->

  $scope.user_has_enough_credits = ->
    $scope.current_user.available_credits >= $scope.purchase.model.price

