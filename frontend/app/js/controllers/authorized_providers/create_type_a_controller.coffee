angular.module('app').controller 'AuthorizedProviderCreateTypeACtrl', ($scope, $state, $stateParams, $window, AuthorizedProvider, RucomService, LocationService, $mdDialog, CameraService, ScannerService) ->
  # *** Loading Variables **** #
  $scope.showLoading = false
  $scope.loadingMessage = "Cargando archivos ..."
  $scope.loadingMode = "determinate"
  $scope.loadingProgress = 0
  # ****** Tab directive variables and methods ********** #
  $scope.validPersonalData = false
  $scope.abortCreate = false
  $scope.rucomIDField =
    label: 'Número de RUCOM'
    field: 'num_rucom'

  $scope.tabIndex =
    selectedIndex: 0

  $scope.pendingPost = false

  goToDocumentation = ->
    $scope.tabIndex.selectedIndex = 1

  # ********* Scanner variables and methods *********** #
  # This have to be executed before retrieve the AuthorizedProvider model to check for pendind scaned files

  $scope.photo = CameraService.getLastScanImage()
  if CameraService.getJoinedFile() and CameraService.getJoinedFile().length > 0
    $scope.file = CameraService.getJoinedFile()
  else if ScannerService.getScanFiles() and ScannerService.getScanFiles().length > 0
    $scope.file = ScannerService.getScanFiles()

  if $scope.photo and CameraService.getTypeFile() == 1
    AuthorizedProvider.modelToCreate.files.photo_file = $scope.photo
    AuthorizedProvider.saveModelToCreate()
    CameraService.clearData()

  if $scope.file
    if CameraService.getTypeFile() == 2
      AuthorizedProvider.modelToCreate.files.document_number_file = $scope.file
      AuthorizedProvider.saveModelToCreate()
      goToDocumentation()
    if CameraService.getTypeFile() == 3
      AuthorizedProvider.modelToCreate.files.mining_register_file = $scope.file
      AuthorizedProvider.saveModelToCreate()
      goToDocumentation()
    if CameraService.getTypeFile() == 4
      AuthorizedProvider.modelToCreate.files.rut_file = $scope.file
      AuthorizedProvider.saveModelToCreate()
      goToDocumentation()
    if CameraService.getTypeFile() == 5
      AuthorizedProvider.modelToCreate.files.chamber_of_commerce_file = $scope.file
      AuthorizedProvider.saveModelToCreate()
      goToDocumentation()
    if CameraService.getTypeFile() == 6
      AuthorizedProvider.modelToCreate.files.external_user_mining_register_file = $scope.file
      goToDocumentation()
    #AuthorizedProvider.saveModelToCreate()
    CameraService.clearData()
    ScannerService.clearData()
  $scope.scanner = (type) ->
    CameraService.setTypeFile type
    AuthorizedProvider.modelToCreate.external_user = $scope.newAuthorizedProvider
    AuthorizedProvider.saveModelToCreate()
    return

  # **************************************************************************

  $scope.newAuthorizedProvider = AuthorizedProvider.restoreModelToCreate().external_user
  $scope.newCompany = AuthorizedProvider.restoreModelToCreate().company
  $scope.newFiles = AuthorizedProvider.restoreModelToCreate().files
  $scope.user_type = AuthorizedProvider.restoreModelToCreate().user_type
  #console.log AuthorizedProvider.restoreModelToCreate()

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

  flushFields = (level) ->
    $scope.population_centers = []
    $scope.selectedPopulationCenter = null
    $scope.searchPopulationCenter = null
    $scope.populationCenterDisabled = true
    switch level
      when 'state'
        $scope.cities = []
        $scope.selectedState = null
        $scope.selectedCity = null
        $scope.searchState = null
        $scope.searchCity = null
        $scope.cityDisabled = true
      when 'city'
        $scope.searchCity = null
        $scope.selectedCity = null
      else
        break
    return

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

  if $scope.newAuthorizedProvider.population_center_id != ''
    loadProviderLocation($scope.newAuthorizedProvider)

  LocationService.getStates.query {}, (states) ->
    $scope.states = states
    #console.log 'States: ' + JSON.stringify(states)
    return

  createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (state) ->
      state.name.toLowerCase().indexOf(lowercaseQuery) == 0

  flushFields = (level) ->
    $scope.population_centers = []
    $scope.selectedPopulationCenter = null
    $scope.searchPopulationCenter = null
    $scope.populationCenterDisabled = true
    switch level
      when 'state'
        $scope.cities = []
        $scope.selectedState = null
        $scope.selectedCity = null
        $scope.searchState = null
        $scope.searchCity = null
        $scope.cityDisabled = true
      when 'city'
        $scope.searchCity = null
        $scope.selectedCity = null
      else
        break
    return


  # It listens to state changes
  $scope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    if toState.url != '/scanner' and toState.url != '/scanner1' and toState.url != '/camera' and toState.url != '/rucoms'
      if !$scope.abortCreate
        event.preventDefault()
        confirm = undefined
        confirm = $mdDialog.confirm().title('Cancelar la creación del nuevo proveedor').content('¿Desea cancelar la operación actual? Los datos que no haya guardado se perderán').ariaLabel('Lucky day').ok('Aceptar').cancel('Cancelar').targetEvent(event)
        return $mdDialog.show(confirm).then((->
          $scope.abortCreate = true
          AuthorizedProvider.clearModelToCreate()
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
      $scope.newAuthorizedProvider.city_id = city.id
      #LocationService.getPopulationCentersFromCity.query { cityId: city.id }, (population_centers) ->
      #  $scope.population_centers = population_centers
      #  #console.log 'Population Centers from ' + city.name + ': ' + JSON.stringify(population_centers)
      #  return
      $scope.population_centers = []
      $scope.populationCenterDisabled = false
    else
      #console.log 'City changed to none'
      flushFields 'city'
    return

  $scope.selectedPopulationCenterChange = (population_center) ->
    if population_center
      $scope.newAuthorizedProvider.population_center_id = population_center.id
      #console.log $scope.newAuthorizedProvider
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

  #******************* RUCOM  variables ********************************** #

  $scope.searchRucom = ->
    RucomService.user_type = $scope.user_type
    AuthorizedProvider.modelToCreate.external_user = $scope.newAuthorizedProvider
    AuthorizedProvider.saveModelToCreate()
    $state.go 'search_rucom'

  $scope.currentRucom = RucomService.getCurrentRucom()
  if $scope.currentRucom
    AuthorizedProvider.modelToCreate.rucom_id = $scope.currentRucom.id
    AuthorizedProvider.saveModelToCreate()
    if $scope.currentRucom.num_rucom
      $scope.rucomIDField.label = 'Número de RUCOM'
      $scope.rucomIDField.field = 'num_rucom'
    else if $scope.currentRucom.rucom_record
      $scope.rucomIDField.label = 'Número de Expediente'
      $scope.rucomIDField.field = 'rucom_record'


    #console.log AuthorizedProvider.modelToCreate

  #************ Creation methods *************************#
  #TODO: Imporove the watch method on the scope to improve performance
  $scope.$watch  ->
    $scope.validate_personal_fields()


  $scope.createAuthorizedProvider = (ev)->

    $scope.validate_documentation_and_create()

  $scope.cancel= ()->
    $state.go 'index_external_user'


  $scope.validate_personal_fields= ()->
    if $scope.newFiles.photo_file == ''
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
    else if $scope.newAuthorizedProvider.first_name == '' || $scope.newAuthorizedProvider.last_name == '' || $scope.newAuthorizedProvider.last_name == '' || $scope.newAuthorizedProvider.email == '' || $scope.newAuthorizedProvider.document_number == '' || $scope.newAuthorizedProvider.phone_number == '' || $scope.newAuthorizedProvider.address == ''
      $scope.validPersonalData = false
      #$mdDialog.show $mdDialog.alert().title('Formulario Incompleto').content('Por favor llene todos los datos personales incluyendo el centro poblado del usuario').ariaLabel('Alert Dialog Demo').ok('ok')
      $scope.tabIndex.selectedIndex = 0
    else if $scope.newAuthorizedProvider.first_name == undefined || $scope.newAuthorizedProvider.last_name == undefined || $scope.newAuthorizedProvider.last_name == undefined || $scope.newAuthorizedProvider.email ==  undefined || $scope.newAuthorizedProvider.document_number == undefined || $scope.newAuthorizedProvider.phone_number == undefined || $scope.newAuthorizedProvider.address == undefined
      $scope.validPersonalData = false
      #$mdDialog.show $mdDialog.alert().title('Formulario Incompleto').content('Por favor llene todos los datos personales incluyendo el centro poblado del usuario').ariaLabel('Alert Dialog Demo').ok('ok')
      $scope.tabIndex.selectedIndex = 0
    else if $scope.currentRucom == null
      $scope.validPersonalData = false
      #$mdDialog.show $mdDialog.alert().title('Formulario Incompleto').content('Por favor seleccione un rucom').ariaLabel('Alert Dialog Demo').ok('ok')
      $scope.tabIndex.selectedIndex = 0
    else
      $scope.validPersonalData = true
      #goToDocumentation()

  $scope.validate_documentation_and_create=  ()->
      if $scope.newFiles.document_number_file == ''
        $mdDialog.show $mdDialog.alert().title('Formulario Incompleto').content('Debe subir toda la documentacion necesaria').ariaLabel('Alert Dialog Demo').ok('ok')
      else
        $scope.pendingPost = true
        AuthorizedProvider.modelToCreate.external_user = $scope.newAuthorizedProvider
        AuthorizedProvider.modelToCreate.rucom_id = $scope.currentRucom.id
        AuthorizedProvider.modelToCreate.files = $scope.newFiles
        AuthorizedProvider.saveModelToCreate()
        #console.log AuthorizedProvider.modelToCreate
        AuthorizedProvider.create()
        $scope.showUploadingDialog()

  $scope.showUploadingDialog = () ->
    $scope.showLoading = true
    $scope.loadingMessage = "Subiendo archivos ..."
    $scope.$watch (->
      AuthorizedProvider.uploadProgress
    ), (newVal, oldVal) ->
      if typeof newVal != 'undefined'
        $scope.loadingProgress = AuthorizedProvider.uploadProgress
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
    #     'AuthorizedProvider'
    #     (scope, $mdDialog, AuthorizedProvider) ->
    #       scope.progress = AuthorizedProvider.uploadProgress
    #       scope.message = 'Espere por favor...'
    #       scope.mode = 'determinate'
    #       scope.$watch (->
    #         AuthorizedProvider.uploadProgress
    #       ), (newVal, oldVal) ->
    #         if typeof newVal != 'undefined'
    #           console.log 'Progress: ' + scope.progress + ' (' + AuthorizedProvider.uploadProgress + ')'
    #           scope.progress = AuthorizedProvider.uploadProgress
    #           scope.mode = 'indeterminate'
    #           if scope.progress == 100
    #             $scope.abortCreate = true
    #             scope.message = "La carga de archivos ha terminado, espere un momento..."

    #         return

    #       return
    #   ]
    # return



