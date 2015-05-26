
angular.module('app').controller 'ExternalUserEditCtrl', ($scope, $state, $stateParams, $window, ExternalUser, RucomService, LocationService,$mdDialog) ->
  # *********************************** VARIABLES **********************************#
  $scope.currentExternalUser = null
  $scope.companyInfo = null
  $scope.saveBtnEnabled = false
  $scope.rucomIDField =
    label: 'Número de RUCOM'
    field: 'num_rucom'
  # ********************************************************************************#
  if $stateParams.id
    ExternalUser.get($stateParams.id).success (data)->
      $mdDialog.cancel()
      $scope.currentExternalUser = data
      $scope.loadProviderLocation(data)
  
  #****** Watchers for listen to changes in editable fields *************************
  $scope.$watch 'currentExternalUser', ((newVal, oldVal) ->
    if oldVal and newVal != oldVal
      $scope.saveBtnEnabled = true
    return
  ), true


  #****** Autocomplete for State, City and Population Center fields *****************

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


  $scope.states = []
  $scope.cities = []
  $scope.population_centers = []
  $scope.selectedState = null
  $scope.selectedCity = null
  $scope.selectedPopulationCenter = null
  $scope.searchState = null
  $scope.searchCity = null
  $scope.searchPopulationCenter = null
  $scope.cityDisabled = true
  $scope.populationCenterDisabled = true

  $scope.loadProviderLocation = (provider) ->
    if provider
      LocationService.getPopulationCenterById.get { populationCenterId: provider.population_center.id }, (populationCenter) ->
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
      #console.log 'State changed to ' + JSON.stringify(state)
      LocationService.getCitiesFromState.query { stateId: state.id }, (cities) ->
        $scope.cities = cities
        #console.log 'Cities from ' + state.name + ': ' + JSON.stringify(cities)
        return
      $scope.cityDisabled = false
    else
      #console.log 'State changed to none'
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
      ExternalUser.modelToUpdate.external_user.population_center_id = population_center.id
    else
      #console.log 'Population Center changed to none'
    return

  $scope.searchTextStateChange = (text) ->
    #console.log 'Text changed to ' + text
    if text == ''
      flushFields 'state'
    return

  $scope.searchTextCityChange = (text) ->
    #console.log 'Text changed to ' + text
    if text == ''
      flushFields 'city'
    return

  $scope.searchTextPopulationCenterChange = (text) ->
    #console.log 'Text changed to ' + text
    return

  $scope.save = ->
    #PUT Request:

    ExternalUser.modelToUpdate.external_user.phone_number = $scope.currentExternalUser.phone_number
    ExternalUser.modelToUpdate.external_user.email = $scope.currentExternalUser.email
    ExternalUser.modelToUpdate.external_user.address = $scope.currentExternalUser.address
    
    ExternalUser.update_external_user($scope.currentExternalUser.id).success (data)->
      $mdDialog.cancel()
      console.log data

    # $resource = ProviderService.edit($scope.currentExternalUser)
    # if $resource
    #   $resource.update { id: $scope.currentExternalUser.id }, $scope.currentExternalUser
    # $window.history.back()
    return

  $scope.back = ->
    $window.history.back()
    return


