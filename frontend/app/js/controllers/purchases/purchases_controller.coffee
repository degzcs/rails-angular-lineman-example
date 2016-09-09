angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, MeasureConverterService, SaleService, $timeout, $q, $mdDialog, CurrentUser, ScannerService, $location,$state, $filter, AuthorizedProvider, SignatureService) ->

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
    $scope.buyer_data = buyerDataFrom($scope.current_user)

  #
  # Fuctions
  #

  fullName = (current_user) ->
    return current_user.first_name + ' ' + current_user.last_name

  #
  # Get the buyer information who is the legal representative, this current user is not necessary the legal representative,
  # it could be (most of the time) a worker for the company.
  # @param current_user [ Object ]
  # @return [ Object ]
  buyerDataFrom = (current_user)->
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
        name: fullName(current_user)
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        address: current_user.address,
        phone: current_user.phone_number,
        city: if current_user.city then current_user.city.name else ''
      }

  #
  # Search one specific seller into the allsellers array
  # @param query [ String ]
  # @return [ Array ] with the matched options with the query
  queryForSellers = (query) ->
    # perform some asynchronous operation, resolve or reject the promise when appropriate.
    $q (resolve, reject) ->
      AuthorizedProvider.queryById(query).success (sellers)->
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
            photo_file: sellers[i].photo_file
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

  #
  # Calls the authorized provider service to get the seller by BD id
  # @param query [ String ]
  # @return []
  $scope.searchSeller = (query)->
    if query
      promise = queryForSellers(query)
      promise.then ((sellers) ->
        return sellers

      ), (reason) ->
        console.log 'Failed: ' + reason
        return
    else
      return []


  #
  # Searchs seller by sale code
  # @ sale_code [ Integer ] is the generated code when the sale is created
  # @return [ Array ] with the matched options with the query
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
  # Gets the last part of the origin certificate URl
  # @param url [ String ]
  # @retun [ String ]
  $scope.formatOriginCertificate = (url) ->
    if url
      url.split('/').pop()

  #
  # Creates a filter function for a query by document number
  # @param query [ String ]
  # @returns [ Function ] with the seller
  createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (seller) ->
      seller.document_number.indexOf(lowercaseQuery) != -1

  per_page = 100
  page = 1

  #
  # Gets the useful information to show
  # @param seller [ Object ]
  # @return [ Object ]
  $scope.formatSeller = (seller)->
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
      photo_file: seller.photo_file
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

  #
  # Camara and Scanner config
  #

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

  #
  # Watchers
  #

  #
  # Setup measures and total price if any of them have changed
  $scope.$watch '[goldBatch.model.grade, goldBatch.model.castellanos,  goldBatch.model.ozs, goldBatch.model.tomines, goldBatch.model.reales, goldBatch.model.granos, goldBatch.model.grams, purchase.model.fine_gram_unit_price, purchase.model.fine_gram_unit_price_to_buy]', ->

    #Convertions
    $scope.castellanosToGrams = MeasureConverterService.castellanosToGrams($scope.goldBatch.model.castellanos)
    $scope.ozsToGrams = MeasureConverterService.ozsToGrams($scope.goldBatch.model.ozs)
    $scope.tominesToGrams = MeasureConverterService.tominesToGrams($scope.goldBatch.model.tomines)
    $scope.rialesToGrams = MeasureConverterService.rialesToGrams($scope.goldBatch.model.riales)
    $scope.granosToGrams = MeasureConverterService.granosToGrams($scope.goldBatch.model.granos)

    $scope.grams = $scope.goldBatch.model.grams
    $scope.goldBatch.model.total_grams = $scope.castellanosToGrams + $scope.ozsToGrams + $scope.tominesToGrams + $scope.rialesToGrams + $scope.granosToGrams + $scope.grams

    # cover grams to fineGrams
    $scope.goldBatch.model.total_fine_grams = MeasureConverterService.gramsToFineGrams($scope.goldBatch.model.total_grams, $scope.goldBatch.model.grade)
    #Price
    $scope.purchase.model.price = $scope.goldBatch.model.total_fine_grams * $scope.purchase.model.fine_gram_unit_price
    $scope.purchase.model.fine_gram_unit_price_to_buy = (($scope.purchase.model.fine_gram_unit_price * $scope.goldBatch.model.grade) / 1000)

  #
  # Flush Data
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
      granos: 0
      inventory_id: 1
      total_grams: 0
      total_fine_grams: 0

  #
  # Save values in SessionStorage
  $scope.saveState= ->
    $scope.purchase.saveState()
    $scope.goldBatch.saveState()
  #  $scope.purchase.model.seller_photo_file=CameraService.getLastScanImage()

  #
  # confirm Dialog to create a purchase
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
      $scope.message = 'La compra ha sido cancelada'
      return

  #
  # Create a new purschase register in DB
  $scope.create = (ev) ->
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

  #
  # Stantandar popup
  # @param title [ String ]
  # @param content [ String ]
  # @param error [ Function ]
  $scope.infoAlert = (title, content, error) ->
    $mdDialog.show($mdDialog.alert().title(title).content(content).ok('OK')).finally ->
      #if !error
        #$state.go 'index_inventory'
      #return
    return

  #
  #
  #$scope.createSeller = ->
  #  sellerService.setCallerState('new_purchase.step0')
  #  $state.go('search_rucom', {type: 'seller'} )

  #
  # Search Authorized provider by DB id
  # @param query [ String ]
  # TODO: checks if this method do the same that queryForSellers
  $scope.getQuery = (query)->
    AuthorizedProvider.queryById(query).success( (sellers)->
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
          photo_file: sellers[i].photo_file
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

  #
  # Validates if the current user has enought Credits to buy
  # @return [ Boolean ]
  $scope.userHasEnoughCredits = ->
    $scope.current_user.available_credits >= $scope.purchase.model.price

  #
  # Formatted the provider data returned from ProviderService
  # @param producer [ Object ]
  # @return [ Object ]
  formattedContent = (producer)->
    prov =
      id: producer.id
      document_number: producer.document_number
      first_name: producer.first_name
      last_name: producer.last_name
      address: producer.address
      email: producer.email
      city: producer.city
      state: producer.state
      phone_number: producer.phone_number
      photo_file: producer.photo_file
      identification_number_file: producer.identification_number_file
      mining_register_file: producer.mining_register_file
      rut_file: producer.rut_file
      rucom:
        id: producer.rucom.id
        num_rucom: producer.rucom.rucom_number
        provider_type: producer.rucom.producer_type
        rucom_status: if producer.rucom.status then producer.rucom.status else if producer.rucom.id then 'Inscrito' else 'No Inscrito'
        mineral: producer.rucom.minerals
    return prov


  #
  # Query to return an answer if the rucom exist or no
  # @param ev [ Event ]
  # @param idNumber [ Integer ]
  $scope.queryRucomByIdNumber = (ev, idNumber) ->
    if idNumber
      AuthorizedProvider.basicProvider(idNumber)
      .success((data, status, headers) ->
        $scope.showLoading = false
        $scope.current_user = data
        $scope.purchase.model.seller = data
        $scope.purchase.model.seller.provider_type = 'Barequero'
        $scope.purchase.model.seller.document_type = 'CEDULA'
        $scope.purchase.model.seller.name = fullName($scope.current_user)
        $scope.purchase.model.seller.company_name = "NA"
        $scope.buyer_data = buyerDataFrom($scope.current_user)
        $scope.prov = formattedContent(data)
        $scope.purchase.model.seller.name = fullName($scope.current_user)
        $scope.purchase.model.seller.company_name = "NA"
        $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Consulta Exitosa').content('Productor si se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
        $state.go 'new_purchase.step1', { id: $scope.prov.id, content: $scope.prov}
      )
      .error((error)->
        $scope.prov = error
        $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content('Productor no se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
        )

  #
  # Signature services
  #

  #
  # Allows to see if the device is connected.
  $scope.restartSessionDevice = ->
    SignatureService.imageId = 'purchase_signature'
    SignatureService.authorizedProviderName = $scope.purchase.model.seller.name
    SignatureService.restartSession()

  #
  # Captures the signature from the device
  $scope.captureSignature = ->
    SignatureService.Capture()

  #
  # Puts it in a img tag
  $scope.saveSignature = ->
    $scope.purchase.model.signature_picture = document.getElementById('purchase_signature').src


