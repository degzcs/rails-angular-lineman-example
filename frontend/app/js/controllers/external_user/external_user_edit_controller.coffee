
angular.module('app').controller 'ExternalUserEditCtrl', ($scope, $state, $stateParams, $window, ExternalUser, RucomService, LocationService,$mdDialog) ->
  #   createFilterFor = (query) ->
  #   lowercaseQuery = angular.lowercase(query)
  #   (state) ->
  #     state.name.toLowerCase().indexOf(lowercaseQuery) == 0

  # flushFields = (level) ->
  #   $scope.population_centers = []
  #   $scope.selectedPopulationCenter = null
  #   $scope.searchPopulationCenter = null
  #   $scope.populationCenterDisabled = true
  #   switch level
  #     when 'state'
  #       $scope.cities = []
  #       $scope.selectedState = null
  #       $scope.selectedCity = null
  #       $scope.searchState = null
  #       $scope.searchCity = null
  #       $scope.cityDisabled = true
  #     when 'city'
  #       $scope.searchCity = null
  #       $scope.selectedCity = null
  #     else
  #       break
  #   return

  $scope.currentExternalUser = null
  $scope.companyInfo = null
  $scope.saveBtnEnabled = false
  $scope.rucomIDField =
    label: 'Número de RUCOM'
    field: 'num_rucom'

  if $stateParams.id
    ExternalUser.get($stateParams.id).success (data)->
      $mdDialog.cancel()
      $scope.currentExternalUser = data
      
  # ExternalUser.retrieveProviderById.get { providerId: $stateParams.providerId }, (provider) ->
  #   prov = 
  #     id: provider.id
  #     document_number: provider.document_number
  #     first_name: provider.first_name
  #     last_name: provider.last_name
  #     address: provider.address
  #     email: provider.email
  #     city: provider.city
  #     state: provider.state
  #     phone_number: provider.phone_number
  #     photo_file: provider.photo_file or 'http://robohash.org/' + provider.id
  #     identification_number_file: provider.identification_number_file
  #     mining_register_file: provider.mining_register_file
  #     rut_file: provider.rut_file
  #     rucom:
  #       num_rucom: provider.rucom.num_rucom
  #       rucom_record: provider.rucom.rucom_record
  #       provider_type: provider.rucom.provider_type
  #       rucom_status: provider.rucom.status
  #       mineral: provider.rucom.mineral
  #     population_center:
  #       id: provider.population_center.id
  #       name: provider.population_center.name
  #       population_center_code: provider.population_center.population_center_code
  #   if provider.company_info
  #     prov.company_info =
  #       id: provider.company_info.id
  #       nit_number: provider.company_info.nit_number
  #       name: provider.company_info.name
  #       legal_representative: provider.company_info.legal_representative
  #       id_type_legal_rep: provider.company_info.id_type_legal_rep
  #       id_number_legal_rep: provider.company_info.id_number_legal_rep
  #       email: provider.company_info.email
  #       phone_number: provider.company_info.phone_number
  #   else
  #     $scope.formTabControl.secondUnlocked = false
  #   if provider.rucom.provider_type == 'Comercializadores'
  #     prov.chamber_commerce_file = provider.chamber_commerce_file
  #   $scope.currentProvider = prov
  #   #ProviderService.setCurrentProv(prov);
  #   if prov.rucom.num_rucom
  #     $scope.rucomIDField.label = 'Número de RUCOM'
  #     $scope.rucomIDField.field = 'num_rucom'
  #   else if prov.rucom.rucom_record
  #     $scope.rucomIDField.label = 'Número de Expediente'
  #     $scope.rucomIDField.field = 'rucom_record'
  #   console.log 'Current provider: ' + prov.id
  #   $scope.loadProviderLocation $scope.currentProvider
  #   return

# # Watchers for listen to changes in editable fields
# $scope.$watch 'currentProvider', ((newVal, oldVal) ->
#   if oldVal and newVal != oldVal
#     $scope.saveBtnEnabled = true
#   return
# ), true
# # objectEquality = true
# # end Watchers
# # Autocomplete for State, City and Population Center fields
# $scope.states = []
# LocationService.getStates.query {}, (states) ->
#   $scope.states = states
#   console.log 'States: ' + JSON.stringify(states)
#   return
# $scope.cities = []
# $scope.population_centers = []
# $scope.selectedState = null
# $scope.selectedCity = null
# $scope.selectedPopulationCenter = null
# $scope.searchState = null
# $scope.searchCity = null
# $scope.searchPopulationCenter = null
# $scope.cityDisabled = true
# $scope.populationCenterDisabled = true

# $scope.loadProviderLocation = (provider) ->
#   if provider
#     LocationService.getPopulationCenterById.get { populationCenterId: provider.population_center.id }, (populationCenter) ->
#       $scope.selectedPopulationCenter = populationCenter
#       $scope.searchPopulationCenter = populationCenter.name
#       $scope.populationCenterDisabled = false
#       console.log 'Current Population Center: ' + JSON.stringify(populationCenter)
#       currentCity = null
#       LocationService.getCityById.get { cityId: populationCenter.city_id }, (city) ->
#         currentCity = city
#         $scope.selectedCity = currentCity
#         $scope.searchCity = currentCity.name
#         $scope.cityDisabled = false
#         console.log 'currentCity: ' + JSON.stringify(city)
#         LocationService.getPopulationCentersFromCity.query { cityId: currentCity.id }, (population_centers) ->
#           $scope.population_centers = population_centers
#           console.log 'Population Centers from ' + currentCity.name + ': ' + JSON.stringify(population_centers)
#           return
#         currentState = null
#         LocationService.getStateById.get { stateId: currentCity.state_id }, (state) ->
#           currentState = state
#           $scope.selectedState = currentState
#           $scope.searchState = currentState.name
#           console.log 'currentState: ' + JSON.stringify(state)
#           LocationService.getCitiesFromState.query { stateId: currentState.id }, (cities) ->
#             $scope.cities = cities
#             console.log 'Cities from ' + currentState.name + ': ' + JSON.stringify(cities)
#             return
#           return
#         return
#       return
#   return

# $scope.stateSearch = (query) ->
#   results = if query then $scope.states.filter(createFilterFor(query)) else []
#   results

# $scope.citySearch = (query) ->
#   results = if query then $scope.cities.filter(createFilterFor(query)) else []
#   results

# $scope.populationCenterSearch = (query) ->
#   results = if query then $scope.population_centers.filter(createFilterFor(query)) else []
#   results

# $scope.selectedStateChange = (state) ->
#   if state
#     $scope.selectedState = state
#     console.log 'State changed to ' + JSON.stringify(state)
#     LocationService.getCitiesFromState.query { stateId: state.id }, (cities) ->
#       $scope.cities = cities
#       console.log 'Cities from ' + state.name + ': ' + JSON.stringify(cities)
#       return
#     $scope.cityDisabled = false
#   else
#     console.log 'State changed to none'
#     flushFields 'state'
#   return

# $scope.selectedCityChange = (city) ->
#   if city
#     $scope.selectedCity = city
#     console.log 'City changed to ' + JSON.stringify(city)
#     LocationService.getPopulationCentersFromCity.query { cityId: city.id }, (population_centers) ->
#       $scope.population_centers = population_centers
#       console.log 'Population Centers from ' + city.name + ': ' + JSON.stringify(population_centers)
#       return
#     $scope.populationCenterDisabled = false
#   else
#     console.log 'City changed to none'
#     flushFields 'city'
#   return

# $scope.selectedPopulationCenterChange = (population_center) ->
#   if population_center
#     console.log 'Population Center changed to ' + JSON.stringify(population_center)
#     $scope.currentProvider.population_center.id = population_center.id
#     $scope.currentProvider.city = $scope.selectedCity.name
#     $scope.currentProvider.state = $scope.selectedState.name
#   else
#     console.log 'Population Center changed to none'
#   return

# $scope.searchTextStateChange = (text) ->
#   console.log 'Text changed to ' + text
#   if text == ''
#     flushFields 'state'
#   return

# $scope.searchTextCityChange = (text) ->
#   console.log 'Text changed to ' + text
#   if text == ''
#     flushFields 'city'
#   return

# $scope.searchTextPopulationCenterChange = (text) ->
#   console.log 'Text changed to ' + text
#   return

# # end Autocomplete management
# $scope.formTabControl =
#   selectedIndex: 0
#   secondUnlocked: true
#   firstLabel: 'Información Básica'
#   secondLabel: 'Información de la Compañía'
#   thirdLabel: 'Documentación'

# $scope.save = ->
#   #PUT Request:
#   $resource = ProviderService.edit($scope.currentProvider)
#   if $resource
#     $resource.update { id: $scope.currentProvider.id }, $scope.currentProvider
#   $window.history.back()
#   return

# $scope.back = ->
#   $window.history.back()
#   return

# $scope.next = ->
#   $scope.formTabControl.selectedIndex = Math.min($scope.formTabControl.selectedIndex + 1, 2)
#   return

# $scope.previous = ->
#   $scope.formTabControl.selectedIndex = Math.max($scope.formTabControl.selectedIndex - 1, 0)
#   return

