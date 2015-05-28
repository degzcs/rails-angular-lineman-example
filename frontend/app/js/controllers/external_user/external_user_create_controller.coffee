angular.module('app').controller 'ExternalUserCreateCtrl', ($scope, $state, $stateParams, $window, ExternalUser, RucomService, LocationService,$mdDialog,CameraService,ScannerService) ->
  
  # ****** Tab directive variables and methods ********** #

  $scope.rucomIDField = {
    label: 'Número de RUCOM',
    field: 'num_rucom'
  };
  $scope.tabIndex =
    selectedIndex: 0
  $scope.next = ->
    $scope.data.selectedIndex = Math.min($scope.data.selectedIndex + 1, 1) 
  $scope.previous = ->
    $scope.data.selectedIndex = Math.max($scope.data.selectedIndex - 1, 0)
  goToDocumentation = ->
    $scope.tabIndex.selectedIndex = 1 

  # ********* Scanner variables and methods *********** #
  # This have to be executed before retrieve the ExternalUser model to check for pendind scaned files

  $scope.photo = CameraService.getLastScanImage()
  if CameraService.getJoinedFile() and CameraService.getJoinedFile().length > 0
    $scope.file = CameraService.getJoinedFile()
  else if ScannerService.getScanFiles() and ScannerService.getScanFiles().length > 0
    $scope.file = ScannerService.getScanFiles()
  
  if $scope.photo and CameraService.getTypeFile() == 1
    ExternalUser.modelToCreate.external_user.photo_file = $scope.photo
    ExternalUser.saveModelToCreate()
    CameraService.clearData()

  if $scope.file
    if CameraService.getTypeFile() == 2
      ExternalUser.modelToCreate.external_user.document_number_file = $scope.file
      goToDocumentation()
    if CameraService.getTypeFile() == 3
      ExternalUser.modelToCreate.external_user.mining_register_file = $scope.file
      goToDocumentation()
    if CameraService.getTypeFile() == 4
      ExternalUser.modelToCreate.external_user.rut_file = $scope.file
      goToDocumentation()
    if CameraService.getTypeFile() == 5
      ExternalUser.modelToCreate.external_user.chamber_commerce_file = $scope.file
      goToDocumentation()
    ExternalUser.saveModelToCreate()
    CameraService.clearData()
    ScannerService.clearData()
  $scope.scanner = (type) ->
    CameraService.setTypeFile type
    return

  # **************************************************************************

  $scope.newExternalUser = ExternalUser.restoreModelToCreate().external_user
  $scope.newCompany = ExternalUser.restoreModelToCreate().company 

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
  
  if $scope.newExternalUser.population_center_id != ''
      $scope.loadProviderLocation $scope.newExternalUser

  LocationService.getStates.query {}, (states) ->
    $scope.states = states
    #console.log 'States: ' + JSON.stringify(states)
    return

  createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (state) ->
      state.name.toLowerCase().indexOf(lowercaseQuery) == 0


  $scope.loadProviderLocation = (provider) ->
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


  # It listens to state changes
  $scope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    if toState.url != '/scanner' and toState.url != '/scanner1' and toState.url != '/camera' and toState.url != '/rucoms'
      if !$scope.abortCreate
        event.preventDefault()
        confirm = undefined
        confirm = $mdDialog.confirm().title('Cancelar la creación del nuevo proveedor').content('¿Desea cancelar la operación actual? Los datos que no haya guardado se perderán').ariaLabel('Lucky day').ok('Aceptar').cancel('Cancelar').targetEvent(event)
        return $mdDialog.show(confirm).then((->
          $scope.abortCreate = true
          ExternalUser.clearModelToCreate()
          $state.go toState, toParams
          return
        ), ->
        )
    return
  # end state change listener

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
      console.log $scope.newExternalUser
    else
      #console.log 'Population Center changed to none'
    return

  $scope.searchTextStateChange = (text) ->
    console.log 'Text changed to ' + text
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
    $state.go 'search_rucom'

  $scope.currentRucom = RucomService.getCurrentRucom()
  if $scope.currentRucom 
    $scope.newExternalUser.rucom_id = $scope.currentRucom.id
    console.log $scope.newExternalUser
  

      