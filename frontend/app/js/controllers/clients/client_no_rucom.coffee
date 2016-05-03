angular.module('app').controller 'ClientCreateNoRucomCtrl', ($scope, $state, $stateParams, $window, ClientService, RucomService, LocationService,$mdDialog,CameraService,ScannerService) ->
  #*** Loading Variables **** #
  $scope.showLoading = false
  $scope.loadingMessage = "Cargando archivos ..."
  $scope.loadingMode = "determinate"
  $scope.loadingProgress = 0
  # ****** Tab directive variables and methods ********** #
  $scope.validPersonalData = false
  $scope.abortCreate = false
  $scope.idTypeLegalRep = [
    { type: 1, name: 'CC' },
    { type: 2, name: 'CE' }
  ]
  $scope.isCompany = ClientService.isCompany
  $scope.tabIndex =
    selectedIndex: 0
  $scope.pendingPost = false
  
  goToDocumentation = ->
    $scope.tabIndex.selectedIndex = 1 

  # ********* Scanner variables and methods *********** #
  # This have to be executed before retrieve the ClientService model to check for pendind scaned files

  $scope.photo = CameraService.getLastScanImage()
  if CameraService.getJoinedFile() and CameraService.getJoinedFile().length > 0
    $scope.file = CameraService.getJoinedFile()
  else if ScannerService.getScanFiles() and ScannerService.getScanFiles().length > 0
    $scope.file = ScannerService.getScanFiles()
  
  if $scope.photo and CameraService.getTypeFile() == 1
    ClientService.modelToCreate.files.photo_file = $scope.photo
    ClientService.saveModelToCreate()
    CameraService.clearData()

  if $scope.file
    if CameraService.getTypeFile() == 2
      ClientService.modelToCreate.files.document_number_file = $scope.file
      ClientService.saveModelToCreate()
      goToDocumentation()
    if CameraService.getTypeFile() == 3
      ClientService.modelToCreate.files.mining_register_file = $scope.file
      ClientService.saveModelToCreate()
      goToDocumentation()
    if CameraService.getTypeFile() == 4
      ClientService.modelToCreate.files.rut_file = $scope.file
      ClientService.saveModelToCreate()
      goToDocumentation()
    if CameraService.getTypeFile() == 5
      ClientService.modelToCreate.files.chamber_of_commerce_file = $scope.file
      ClientService.saveModelToCreate()
      goToDocumentation()
    #ClientService.saveModelToCreate()
    CameraService.clearData()
    ScannerService.clearData()
  $scope.scanner = (type) ->
    CameraService.setTypeFile type
    ClientService.modelToCreate.external_user = $scope.newExternalUser
    ClientService.saveModelToCreate()
    return

  # **************************************************************************

  $scope.newExternalUser = ClientService.restoreModelToCreate().external_user
  $scope.newCompany = ClientService.restoreModelToCreate().company 
  $scope.newFiles = ClientService.restoreModelToCreate().files 
  $scope.user_type = ClientService.restoreModelToCreate().user_type 
  console.log "LLEGO"
  console.log ClientService.restoreModelToCreate()

  #******************* Population center variables ********************************** #
  $scope.states = [];
  $scope.cities = [];
  $scope.population_centers = [];
  $scope.selectedState = null;
  $scope.selectedCity = null;
  $scope.selectedPopulationCenter = null;
  $scope.searchState = null;
  $scope.searchCity = null;
  $scope.searchPopulationCenter = null;
  $scope.cityDisabled = true;
  $scope.populationCenterDisabled = true;

  loadProviderLocation = (provider) ->
    if provider
      LocationService.getPopulationCenterById.get { populationCenterId: provider.population_center_id }, (populationCenter) ->
        $scope.selectedPopulationCenter = populationCenter
        $scope.searchPopulationCenter = populationCenter.name
        $scope.populationCenterDisabled = false
        #console.log 'Current Population Center: ' + JSON.stringify(populationCenter)
        currentCity = null
        LocationService.getCityById.get { cityId: populationCenter.city_id }, (city) ->
          currentCity = city
          $scope.selectedCity = currentCity
          $scope.searchCity = currentCity.name
          $scope.cityDisabled = false
          #console.log 'currentCity: ' + JSON.stringify(city)
          LocationService.getPopulationCentersFromCity.query { cityId: currentCity.id }, (population_centers) ->
            $scope.population_centers = population_centers
            #console.log 'Population Centers from ' + currentCity.name + ': ' + JSON.stringify(population_centers)
            return
          currentState = null
          LocationService.getStateById.get { stateId: currentCity.state_id }, (state) ->
            currentState = state
            $scope.selectedState = currentState
            $scope.searchState = currentState.name
            #console.log 'currentState: ' + JSON.stringify(state)
            LocationService.getCitiesFromState.query { stateId: currentState.id }, (cities) ->
              $scope.cities = cities
              #console.log 'Cities from ' + currentState.name + ': ' + JSON.stringify(cities)
              return
            return
          return
        return
    return
  
  if $scope.newExternalUser.population_center_id != ''
    loadProviderLocation($scope.newExternalUser)

  LocationService.getStates.query {}, (states) ->
    $scope.states = states
    #console.log 'States: ' + JSON.stringify(states)
    return

  createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (state) ->
      state.name.toLowerCase().indexOf(lowercaseQuery) == 0


  # It listens to state changes
  $scope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    if toState.url != '/scanner' and toState.url != '/scanner1' and toState.url != '/camera' and toState.url != '/rucoms'
      if !$scope.abortCreate
        event.preventDefault()
        confirm = undefined
        confirm = $mdDialog.confirm().title('Cancelar la creación del nuevo proveedor').content('¿Desea cancelar la operación actual? Los datos que no haya guardado se perderán').ariaLabel('Lucky day').ok('Aceptar').cancel('Cancelar').targetEvent(event)
        return $mdDialog.show(confirm).then((->
          $scope.abortCreate = true
          ClientService.clearModelToCreate()
          $state.go toState, toParams
          return
        ), ->
        )
    return
  

  $scope.stateSearch = (query) ->
    results = if query then $scope.states.filter(createFilterFor(query)) else []
    results

  $scope.citySearch = (query) ->
    results = if query then $scope.cities.filter(createFilterFor(query)) else []
    results

  $scope.populationCenterSearch = (query) ->
    results = if query then $scope.population_centers.filter(createFilterFor(query)) else []
    results

  $scope.selectedStateChange = (state) ->
    if state
      $scope.selectedState = state
      LocationService.getCitiesFromState.query { stateId: state.id }, (cities) ->
        $scope.cities = cities
        return
      $scope.cityDisabled = false
    else
      flushFields 'state'
    return

  $scope.selectedCityChange = (city) ->
    if city
      $scope.selectedCity = city
      #console.log 'City changed to ' + JSON.stringify(city)
      LocationService.getPopulationCentersFromCity.query { cityId: city.id }, (population_centers) ->
        $scope.population_centers = population_centers
        #console.log 'Population Centers from ' + city.name + ': ' + JSON.stringify(population_centers)
        return
      $scope.populationCenterDisabled = false
    else
      #console.log 'City changed to none'
      flushFields 'city'
    return

  $scope.selectedPopulationCenterChange = (population_center) ->
    if population_center
      $scope.newExternalUser.population_center_id = population_center.id
      #console.log $scope.newExternalUser
    else
      #console.log 'Population Center changed to none'
    return

  $scope.searchTextStateChange = (text) ->
    #console.log 'Text changed to ' + text
    if text == ''
      flushFields 'state'
    return

  $scope.searchTextCityChange = (text) ->
    if text == ''
      flushFields 'city'
    return

  $scope.searchTextPopulationCenterChange = (text) ->
    return

  

  #************ Creation methods *************************#
  #TODO: Imporove the watch method on the scope to improve performance
  $scope.$watch  ->
    $scope.validate_personal_fields()


  $scope.createExternalUser = (ev)->
    
    $scope.validate_documentation_and_create()
    
  $scope.cancel= ()->
    $state.go 'index_external_user'


  $scope.validate_personal_fields= ()->
    if $scope.newFiles.photo_file == ''
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
    else if $scope.newExternalUser.first_name == '' || $scope.newExternalUser.last_name == '' || $scope.newExternalUser.last_name == '' || $scope.newExternalUser.email == '' || $scope.newExternalUser.document_number == '' || $scope.newExternalUser.phone_number == '' || $scope.newExternalUser.address == '' || $scope.newExternalUser.population_center_id == ''
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
    else if $scope.newExternalUser.first_name == undefined || $scope.newExternalUser.last_name == undefined || $scope.newExternalUser.last_name == undefined || $scope.newExternalUser.email ==  undefined || $scope.newExternalUser.document_number == undefined || $scope.newExternalUser.phone_number == undefined || $scope.newExternalUser.address == undefined
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
    else if $scope.currentRucom == null && !$scope.isCompany
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
    else if $scope.isCompany
      $scope.validate_company_fields()
    else
      $scope.validPersonalData = true
      
  $scope.validate_company_fields = ()->
    if $scope.newCompany.name == '' || $scope.newCompany.nit_number == '' || $scope.newCompany.legal_representative == '' || $scope.newCompany.id_number_legal_rep == '' || $scope.newCompany.email == '' || $scope.newCompany.id_type_legal_rep == '' || $scope.newCompany.phone_number == ''
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
    else if $scope.newCompany.name == undefined || $scope.newCompany.nit_number == undefined || $scope.newCompany.legal_representative == undefined || $scope.newCompany.id_number_legal_rep == undefined || $scope.newCompany.email == undefined || $scope.newCompany.id_type_legal_rep == undefined || $scope.newCompany.phone_number == undefined
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
    else if $scope.currentRucom == null 
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
    else
      $scope.validPersonalData = true
      

  $scope.validate_documentation_and_create=  ()->
    if $scope.isCompany &&  ($scope.newFiles.mining_register_file == '' || $scope.newFiles.rut_file == '')
      $mdDialog.show $mdDialog.alert().title('Formulario Incompleto').content('Debe subir toda la documentacion necesaria').ariaLabel('Alert Dialog Demo').ok('ok')
    else if $scope.newFiles.document_number_file == ''
      $mdDialog.show $mdDialog.alert().title('Formulario Incompleto').content('Debe subir toda la documentacion necesaria').ariaLabel('Alert Dialog Demo').ok('ok')
    else
      $scope.pendingPost = true
      console.log $scope.newFiles
      ClientService.modelToCreate.external_user = $scope.newExternalUser
      ClientService.modelToCreate.files = $scope.newFiles 
      ClientService.modelToCreate.company = $scope.newCompany if $scope.isCompany
      ClientService.saveModelToCreate()
      #console.log ExternalUser.modelToCreate
      ClientService.create()
      $scope.showUploadingDialog()



  $scope.showUploadingDialog = () ->
    $scope.showLoading = true
    $scope.loadingMessage = "Subiendo archivos ..."
    $scope.$watch (->
      ClientService.uploadProgress
    ), (newVal, oldVal) ->
      if typeof newVal != 'undefined'
        $scope.loadingProgress = ClientService.uploadProgress
        if $scope.loadingProgress == 100
          $scope.abortCreate = true
          $scope.loadingMessage = "Espere un momento ..."
          $scope.loadingMode = "indeterminate"
    # parentEl = angular.element(document.body)
    # $mdDialog.show
    #   parent: parentEl
    #   disableParentScroll: false
    #   templateUrl: 'partials/uploading_files.html'
    #   controller: [
    #     'scope'
    #     '$mdDialog'
    #     'ExternalUser'
    #     (scope, $mdDialog, ExternalUser) ->
    #       scope.progress = ExternalUser.uploadProgress
    #       scope.message = 'Espere por favor...'
    #       scope.mode = 'determinate'
    #       scope.$watch (->
    #         ExternalUser.uploadProgress
    #       ), (newVal, oldVal) ->
    #         if typeof newVal != 'undefined'
    #           console.log 'Progress: ' + scope.progress + ' (' + ExternalUser.uploadProgress + ')'
    #           scope.progress = ExternalUser.uploadProgress
    #           scope.mode = 'indeterminate'
    #           if scope.progress == 100
    #             $scope.abortCreate = true
    #             scope.message = "La carga de archivos ha terminado, espere un momento..."

    #         return

    #       return
    #   ]
    # return

  $scope.setIsCompany = ()->
    $scope.tabIndex.selectedIndex = 0
    console.log $scope.isCompany
    ClientService.isCompany = $scope.isCompany




  

