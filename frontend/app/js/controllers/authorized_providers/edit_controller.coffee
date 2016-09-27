
angular.module('app').controller 'AuthorizedProviderEditCtrl', ($scope, $state, $stateParams, $window, AuthorizedProvider, LocationService, $mdDialog) ->
  #*** Loading Variables **** #
  $scope.showLoading = true
  $scope.loadingMode = "indeterminate"
  $scope.loadingMessage = "Cargando ..."
  # *********************************** VARIABLES **********************************#
  $scope.currentAuthorizedProvider = null
  $scope.saveBtnEnabled = false

  $scope.states = []
  LocationService.getStates.query {}, (states) ->
    $scope.states = states
    return
  $scope.cities = []
  $scope.selectedState = ''
  $scope.selectedCity = ''
  $scope.searchState = ''
  $scope.searchCity = ''
  $scope.cityDisabled = true
  # ********************************************************************************#
  if $stateParams.id
    AuthorizedProvider.get($stateParams.id).success (data)->
      $scope.showLoading = false
      $scope.currentAuthorizedProvider = data

  #****** Watchers for listen to changes in editable fields *************************
  $scope.$watch 'currentAuthorizedProvider', ((newVal, oldVal) ->
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
    switch level
      when 'state'
        $scope.cities = []
        $scope.selectedState = ''
        $scope.selectedCity = ''
        $scope.searchState = ''
        $scope.searchCity = ''
        $scope.cityDisabled = true
      when 'city'
        $scope.searchCity = ''
        $scope.selectedCity = ''
      else
        break
    return

  $scope.stateSearch = (query) ->
    results = if query then $scope.states.filter(createFilterFor(query)) else []
    results

  $scope.citySearch = (query) ->
    results = if query then $scope.cities.filter(createFilterFor(query)) else []
    results

  $scope.selectedStateChange = (state) ->
    if state
      $scope.selectedState = state
      LocationService.getCitiesFromState.query { stateId: state.id }, (cities) ->
        $scope.cities = cities
        return
      $scope.cityDisabled = false
    else
      #console.log 'State changed to none'
      flushFields 'state'
    return

  $scope.selectedCityChange = (city) ->
    if city
      $scope.selectedCity = city
    else
      flushFields 'city'
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

  $scope.save = ->
    AuthorizedProvider.model.phone_number = $scope.currentAuthorizedProvider.phone_number
    AuthorizedProvider.model.email = $scope.currentAuthorizedProvider.email
    AuthorizedProvider.model.address = $scope.currentAuthorizedProvider.address

    AuthorizedProvider.update($scope.currentAuthorizedProvider.id).success (data)->
      #$mdDialog.cancel()
      $state.go "show_authorized_provider", {id: $scope.currentAuthorizedProvider.id}
      $mdDialog.show $mdDialog.alert().title('Mensaje').content('Información actualizada correctamente.').ariaLabel('Alert Dialog Demo').ok('ok!')

    return

  $scope.back = ->
    $window.history.back()
    return

