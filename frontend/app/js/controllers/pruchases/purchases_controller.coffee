angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, MeasureConverterService, ExternalUser, SaleService, $timeout, $q, $mdDialog, CurrentUser, ScannerService, $location,$state) ->
  #*** Loading Variables **** #
  $scope.showLoading = false
  $scope.loadingMode = "determinate"
  $scope.loadingMessage = "Registrando su compra ..."
  $scope.loadingProgress = 0
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
  $scope.selectedProvider = null

  $scope.rucomIDField =
    label: 'Número de RUCOM'
    field: 'num_rucom'

  # if $scope.purchase.model.origin_certificate_file.url
  # $scope.origin_certificate_file_name =$scope.purchase.model.origin_certificate_file.url.split('/').pop()

  CurrentUser.get().success (data) ->
    $scope.current_user = data
  window.s =  $scope

  #
  # Fuctions
  #

  #
  # Search one specific provider into the allProviders array
  # @return [Array] with the matched options with the query

  query_for_providers = (query) ->
    # perform some asynchronous operation, resolve or reject the promise when appropriate.
    $q (resolve, reject) ->
      ExternalUser.query_by_id(query).success (providers)->
        $scope.allProviders = []

        i = 0
        while i < providers.length
          prov =
            id: providers[i].id
            document_number: providers[i].document_number
            company_name: if providers[i].company then providers[i].company.name else 'Ninguna' #'company name test' # <-- TODO: migration
            document_type: if providers[i].company then 'NIT' else 'CC' # <-- TODO: migration
            first_name: providers[i].first_name
            last_name: providers[i].last_name
            address: providers[i].address
            email: providers[i].email
            phone_number: providers[i].phone_number || providers[i].phone
            photo_file: providers[i].photo_file or 'http://robohash.org/' + providers[i].id
            num_rucom: providers[i].rucom.num_rucom
            rucom_record: providers[i].rucom.rucom_record
            provider_type: providers[i].rucom.provider_type
            rucom_status: providers[i].rucom.status
            mineral: providers[i].rucom.mineral
            name: providers[i].first_name + ' '+ providers[i].last_name
            city: providers[i].city || ''
            state: providers[i].state || ''
            address: providers[i].address
            nit: if providers[i].company then providers[i].company.nit_number else "--" # <-- TODO: migration

          $scope.allProviders.push prov
          i++
        resolve $scope.allProviders

      return

  $scope.searchProvider = (query)->
    if query
      promise = query_for_providers(query)
      promise.then ((providers) ->
        return providers

      ), (reason) ->
        console.log 'Failed: ' + reason
        return
    else
      return []


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
        $scope.goldBatch.model.grams =  MeasureConverterService.fineGramsToGrams(data.fine_grams, data.grade)
        $scope.purchase.model.sale_id =  data.id
        $scope.purchase.model.origin_certificate_file = data.origin_certificate_file
        $scope.purchase.model.provider = data.provider
        # TODO: simplify this code
        if data.provider.num_rucom
          $scope.rucomIDField.label = 'Número de RUCOM'
          $scope.rucomIDField.field = 'num_rucom'
          $scope.purchase.model.rucom_id_field = 'num_rucom'
        else if data.provider.rucom_record
          $scope.rucomIDField.label = 'Número de Expediente'
          $scope.rucomIDField.field = 'rucom_record'
          $scope.purchase.model.rucom_id_field = 'rucom_record'
        else
          console.log 'State changed to none'

  #
  #
  #
  $scope.selectedProviderChange = (provider) ->
    console.log "Seleccionado"
    if provider
      #console.log 'Provider changed to ' + JSON.stringify(provider)
      #console.log "Proovedor!"
      #console.log provider.rucom
      #$scope.format_provider(provider)
      console.log provider.rucom
      console.log $scope.purchase.model.provider

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

  per_page = 100
  page = 1
  #
  # all providers
  # ExternalUser.all(per_page,page).success( (providers)->
  #   $mdDialog.cancel()
  #   i = 0
  #   while i < providers.length
  #     prov =
  #       id: providers[i].id
  #       document_number: providers[i].nit || providers[i].document_number
  #       company_name: if providers[i].company_info then providers[i].company_info.name else providers[i].first_name + ' ' + providers[i].last_name #'company name test' # <-- TODO: migration
  #       document_type: 'CC' # <-- TODO: migration
  #       first_name: providers[i].first_name
  #       last_name: providers[i].last_name
  #       address: providers[i].address
  #       email: providers[i].email
  #       phone_number: providers[i].phone_number || providers[i].phone
  #       photo_file: providers[i].photo_file or 'http://robohash.org/' + providers[i].id
  #       num_rucom: providers[i].rucom.num_rucom
  #       rucom_record: providers[i].rucom.rucom_record
  #       provider_type: providers[i].rucom.provider_type
  #       rucom_status: providers[i].rucom.status
  #       mineral: providers[i].rucom.mineral
  #       name: providers[i].first_name + ' '+ providers[i].last_name
  #       city: providers[i].city || 'Popayan'
  #       state: providers[i].state || 'Cauca'
  #       address: providers[i].address
  #     $scope.allProviders.push prov
  #     i++
  # ).error ()->

  $scope.format_provider = (provider)->
    console.log "el rucom"
    #console.log provider.rucom
    rucom = provider.rucom
    return {
      id: provider.id
      document_number: provider.document_number
      company_name: if provider.company then provider.company.name else provider.first_name + ' ' + provider.last_name #'company name test' # <-- TODO: migration
      document_type: if provider.company then "NIT" else "CC"
      first_name: provider.first_name
      last_name: provider.last_name
      address: provider.address
      email: provider.email
      phone_number: provider.phone_number || provider.phone
      photo_file: provider.photo_file or 'http://robohash.org/' + provider.id
      num_rucom: rucom.num_rucom
      rucom_record: rucom.rucom_record
      provider_type: rucom.provider_type
      rucom_status: rucom.status
      mineral: rucom.mineral
      name: provider.first_name + ' '+ provider.last_name
      city: provider.city.name || ''
      state: provider.state.name || ''
      address: provider.address
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
      provider: {}
      origin_certificate_sequence: ''
      origin_certificate_file: ''
      fine_gram_unit_price: 0 # this is set up for current buyer (currently logged user )
      reference_code: ''
      barcode_html: ''
      code: ''

    GoldBatchService.model =
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
  $scope.create =  (ev) ->
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

  
    # parentEl = angular.element(document.body)
    # $mdDialog.show
    #   parent: parentEl
    #   targetEvent: ev
    #   disableParentScroll: false
    #   template: '<md-dialog>' + '  <md-dialog-content>' + '    <div layout="column" layout-align="center center">' + '      <p>{{message}}</p>' + '      <md-progress-circular md-mode="determinate" value="{{progress}}"></md-progress-circular>' + '    </div>' + '  </md-dialog-content>' + '  <div class="md-actions">' + '    <md-button ng-click="closeDialog()" ng-if="progress === 100" class="md-primary">' + '      Cerrar' + '    </md-button>' + '  </div>' + '</md-dialog>'
    #   controller: [
    #     'scope'
    #     '$mdDialog'
    #     'PurchaseService'
    #     (scope, $mdDialog, PurchaseService) ->
    #       scope.progress = PurchaseService.impl.uploadProgress
    #       scope.message = 'Espere por favor...'
    #       scope.$watch (->
    #         PurchaseService.impl.uploadProgress
    #       ), (newVal, oldVal) ->
    #         if typeof newVal != 'undefined'
    #           console.log 'Progress: ' + scope.progress + ' (' + PurchaseService.impl.uploadProgress + ')'
    #           scope.progress = PurchaseService.impl.uploadProgress
    #           if scope.progress == 100
    #             scope.closeDialog()
    #         return

    #       scope.closeDialog = ->
    #         $mdDialog.cancel()
    #         # $scope.newProvider = {}
    #         # PurchaseService.setCurrentProv {}
    #         $scope.infoAlert 'Crear nueva compra', 'La compra esta siendo procesada ...', false
    #         # $scope.abortCreate = true
    #         # PurchaseService.currentTabProvCreation = 0
    #         return

    #       return
    #   ]
    # return

  $scope.infoAlert = (title, content, error) ->
    $mdDialog.show($mdDialog.alert().title(title).content(content).ok('OK')).finally ->
      #if !error
        #$state.go 'index_inventory'
      #return
    return

  $scope.createProvider = ->
    ProviderService.setCallerState('new_purchase.step1')
    $state.go('search_rucom',{type: 'provider'})

  $scope.getQuery = (query)->
    ExternalUser.query_by_id(query).success( (providers)->
      $scope.allProviders = []

      i = 0
      while i < providers.length
        prov =
          id: providers[i].id
          document_number: providers[i].document_number
          company_name: if providers[i].company then providers[i].company.name else 'Ninguna' #'company name test' # <-- TODO: migration
          document_type: if providers[i].company then 'NIT' else 'CC' # <-- TODO: migration
          first_name: providers[i].first_name
          last_name: providers[i].last_name
          address: providers[i].address
          email: providers[i].email
          phone_number: providers[i].phone_number || providers[i].phone
          photo_file: providers[i].photo_file or 'http://robohash.org/' + providers[i].id
          num_rucom: providers[i].rucom.num_rucom
          rucom_record: providers[i].rucom.rucom_record
          provider_type: providers[i].rucom.provider_type
          rucom_status: providers[i].rucom.status
          mineral: providers[i].rucom.mineral
          name: providers[i].first_name + ' '+ providers[i].last_name
          city: providers[i].city || ''
          state: providers[i].state || ''
          address: providers[i].address
          nit: if providers[i].company then providers[i].company.nit_number else "--" # <-- TODO: migration

        $scope.allProviders.push prov
        i++
    ).error ()->

  $scope.user_has_enough_credits = ->
    $scope.current_user.available_credits >= $scope.purchase.model.price

