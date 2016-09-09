
angular.module('app').controller 'AuthorizedProviderNewCtrl', ($scope, $state, $stateParams, $window, RucomService, LocationService, $mdDialog, CameraService, ScannerService, AuthorizedProviderService) ->
  #*** Loading Variables **** #
  $scope.showLoading = true
  $scope.loadingMode = "indeterminate"
  $scope.loadingMessage = "Cargando ..."
  $scope.btnContinue = false
  # *********************************** VARIABLES **********************************#
  $scope.currentAuthorizedProvider = null
  $scope.saveBtnEnabled = false
  $scope.rucomIDField =
    label: 'Número de RUCOM'
    field: 'num_rucom'

  $scope.validPersonalData = false
  $scope.tabIndex =
    selectedIndex: 0

  $scope.pendingPost = false

  $scope.goToDocumentation = ->
    $scope.tabIndex.selectedIndex = 1

  # ********* Scanner variables and methods *********** #
  # This have to be executed before retrieve the AuthorizedProviderService model to check for pendind scaned files

  $scope.photo = CameraService.getLastScanImage()
  if CameraService.getJoinedFile() and CameraService.getJoinedFile().length > 0
    $scope.file = CameraService.getJoinedFile()
  else if ScannerService.getScanFiles() and ScannerService.getScanFiles().length > 0
    $scope.file = ScannerService.getScanFiles()

  if $scope.photo and CameraService.getTypeFile() == 1
    AuthorizedProviderService.model.files.photo_file = $scope.photo
    AuthorizedProviderService.saveModel()
    CameraService.clearData()

  if $scope.file
    if CameraService.getTypeFile() == 2
      AuthorizedProviderService.model.files.document_number_file = $scope.file
      AuthorizedProviderService.saveModel()
      goToDocumentation()
    if CameraService.getTypeFile() == 3
      AuthorizedProviderService.model.files.mining_register_file = $scope.file
      AuthorizedProviderService.saveModel()
      goToDocumentation()
    if CameraService.getTypeFile() == 4
      AuthorizedProviderService.model.files.rut_file = $scope.file
      AuthorizedProviderService.saveModel()
      goToDocumentation()
    if CameraService.getTypeFile() == 5
      AuthorizedProviderService.model.files.chamber_of_commerce_file = $scope.file
      AuthorizedProviderService.saveModel()
      goToDocumentation()
    if CameraService.getTypeFile() == 6
      AuthorizedProviderService.model.files.external_user_mining_register_file = $scope.file
      goToDocumentation()
    #AuthorizedProviderService.saveModel()
    CameraService.clearData()
    ScannerService.clearData()

  $scope.scanner = (type) ->
    CameraService.setTypeFile type
    AuthorizedProviderService.model.authorized_provider = $scope.currentAuthorizedProvider
    AuthorizedProviderService.saveModel()
    return

  # **************************************************************************

  $scope.newFiles = AuthorizedProviderService.restoreModel().files

  # ********************************************************************************#

  if $stateParams.id
    AuthorizedProviderService.get($stateParams.id).success (data)->
      $scope.showLoading = false
      $scope.currentAuthorizedProvider = data
  else
    console.log 'no se envió el Id del usuario en los parámetros'

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

  $scope.stateSearch = (query) ->
    results = if query then $scope.states.filter(createFilterFor(query)) else []
    results

  $scope.citySearch = (query) ->
    results = if query then $scope.cities.filter(createFilterFor(query)) else []
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
    window.city = city
    if city
      $scope.selectedCity = city
      $scope.currentAuthorizedProvider.city = city.id || ''
    else
      #console.log 'City changed to none'
      flushFields 'city'
    return

  $scope.searchTextStateChange = (text) ->
    #console.log 'Text changed to ' + text
    if text == ''
      flushFields 'state'
    return

  $scope.searchTextCityChange = (text) ->
    #console.log 'Text changed to ' + text
    if text == '' || text == undefined
      flushFields 'city'
    return

  $scope.save = ->
    #PUT Request:
    AuthorizedProviderService.model.profile.first_name = $scope.currentAuthorizedProvider.first_name
    AuthorizedProviderService.model.profile.last_name = $scope.currentAuthorizedProvider.last_name
    AuthorizedProviderService.model.rucom.rucom_number = $scope.currentAuthorizedProvider.rucom.rucom_number
    AuthorizedProviderService.model.profile.phone_number = $scope.currentAuthorizedProvider.phone_number
    AuthorizedProviderService.model.authorized_provider.email = $scope.currentAuthorizedProvider.email
    AuthorizedProviderService.model.profile.address = $scope.currentAuthorizedProvider.address
    AuthorizedProviderService.model.profile.city_id = $scope.currentAuthorizedProvider.city

  $scope.back = ->
    $window.history.back()
    return

#------------Validations -----------------#
  $scope.validatePersonalFields = ()->
    window.frm = $scope.currentAuthorizedProvider
    res = $scope.isEmptyOrUndefinedAnyField()
    console.log('result de validacion = ' + res)
    if res == true
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
      $scope.btnContinue = false
      console.log 'validacion : campos vacios o no definidos'
    else
      $scope.validPersonalData = true
      $scope.tabIndex.selectedIndex = 1
      $scope.btnContinue =  true
      console.log 'validacion : campos completos'

# --------------------------------------
  $scope.validate_personal_fields_old= ()->
    if $scope.newFiles.photo_file == ''
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
    else if $scope.currentAuthorizedProvider.first_name == '' || $scope.currentAuthorizedProvider.last_name == '' || $scope.currentAuthorizedProvider.last_name == '' || $scope.currentAuthorizedProvider.email == '' || $scope.currentAuthorizedProvider.document_number == '' || $scope.currentAuthorizedProvider.phone_number == '' || $scope.currentAuthorizedProvider.address == ''
      $scope.validPersonalData = false
      $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Formulario Incompleto').content('Por favor llene todos los datos personales incluyendo el centro poblado del usuario').ariaLabel('Alert Dialog Demo').ok('ok')
      #$mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content('Productor no se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
      $scope.tabIndex.selectedIndex = 0
    else if $scope.currentAuthorizedProvider.first_name == undefined || $scope.currentAuthorizedProvider.last_name == undefined || $scope.currentAuthorizedProvider.last_name == undefined || $scope.currentAuthorizedProvider.email ==  undefined || $scope.currentAuthorizedProvider.document_number == undefined || $scope.currentAuthorizedProvider.phone_number == undefined || $scope.currentAuthorizedProvider.address == undefined
      $scope.validPersonalData = false
      $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Formulario Incompleto').content('Por favor llene todos los datos personales incluyendo el centro poblado del usuario').ariaLabel('Alert Dialog Demo').ok('ok')
      $scope.tabIndex.selectedIndex = 0
    else if $scope.currentRucom == ''
      $scope.validPersonalData = false
      $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Formulario Incompleto').content('Por favor seleccione un rucom').ariaLabel('Alert Dialog Demo').ok('ok')
      $scope.tabIndex.selectedIndex = 0
    else
      $scope.validPersonalData = true
      $scope.tabIndex.selectedIndex = 1

# ----------------- dependencie methods to the validations ------------------------#
  $scope.isEmptyOrUndefinedAnyField = ()->
    isOk = true
    frm = $scope.currentAuthorizedProvider
    if frm.first_name == '' || frm.first_name == undefined
    else if frm.last_name == '' || frm.last_name == undefined
    else if frm.document_number == '' || frm.rucom.rucom_number == undefined
    else if frm.rucom.rucom_number == '' || frm.rucom.rucom_number == undefined
    else if frm.email == '' || frm.email == undefined
    else if frm.document_number == '' || frm.document_number == undefined
    else if frm.phone_number == '' || frm.phone_number == undefined
    else if frm.address == '' || frm.address == undefined
    else if frm.address == '' || frm.address == undefined
    else
      isOk = false
    return isOk
#------------end Validations -----------------#

  $scope.validate_documentation_and_update =  ()->
    if $scope.newFiles.document_number_file == ''
      $mdDialog.show $mdDialog.alert().title('Formulario Incompleto').content('Debe subir toda la documentacion necesaria').ariaLabel('Alert Dialog Demo').ok('ok')
    else
      $scope.pendingPost = true

      AuthorizedProviderService.model.profile.first_name = $scope.currentAuthorizedProvider.first_name
      AuthorizedProviderService.model.profile.last_name = $scope.currentAuthorizedProvider.last_name
      AuthorizedProviderService.model.rucom.rucom_number = $scope.currentAuthorizedProvider.rucom.rucom_number
      AuthorizedProviderService.model.profile.phone_number = $scope.currentAuthorizedProvider.phone_number
      AuthorizedProviderService.model.authorized_provider.email = $scope.currentAuthorizedProvider.email
      AuthorizedProviderService.model.profile.address = $scope.currentAuthorizedProvider.address
      AuthorizedProviderService.model.profile.city_id = $scope.currentAuthorizedProvider.city
      AuthorizedProviderService.model.profile.state_id = $scope.currentAuthorizedProvider.state
      AuthorizedProviderService.saveModel()
      AuthorizedProviderService.update($scope.currentAuthorizedProvider.id)
      return


  $scope.updateAuthorizedProviderService = (ev)->
    $scope.validate_documentation_and_update()


  $scope.validate_documentation_and_create =  ()->
    if $scope.newFiles.document_number_file == ''
      $mdDialog.show $mdDialog.alert().title('Formulario Incompleto').content('Debe subir toda la documentacion necesaria').ariaLabel('Alert Dialog Demo').ok('ok')
    else
      $scope.pendingPost = true
      AuthorizedProviderService.model.external_user = $scope.currentAuthorizedProvider
      AuthorizedProviderService.model.rucom_id = $scope.currentRucom.id
      AuthorizedProviderService.model.files = $scope.newFiles
      AuthorizedProviderService.saveModel()
      AuthorizedProviderService.create()
      $scope.showUploadingDialog()

  $scope.showUploadingDialog = () ->
    $scope.showLoading = true
    $scope.loadingMessage = "Subiendo archivos ..."
    $scope.$watch (->
      AuthorizedProviderService.uploadProgress
    ), (newVal, oldVal) ->
      if typeof newVal != 'undefined'
        $scope.loadingProgress = AuthorizedProviderService.uploadProgress
        if $scope.loadingProgress == 100
          $scope.abortCreate = true
          $scope.loadingMessage = "Espere un momento ..."
          $scope.loadingMode = "indeterminate"

#----------- tabs -----------------------------------------#
  $scope.setTab = (setValue) ->
    $scope.selectedTab = setValue

  $scope.isSet = (selectedValue) ->
    return $scope.setTab == selectedValue