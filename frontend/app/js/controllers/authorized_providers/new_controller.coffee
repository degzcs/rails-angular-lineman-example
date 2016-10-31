angular.module('app').controller 'AuthorizedProviderNewCtrl', ($scope, $state, $document, $stateParams, $window, LocationService, $mdDialog, CameraService, ScannerService, AuthorizedProviderService) ->
  #*** Loading Variables **** #
  $scope.showLoading = true
  $scope.loadingMode = "indeterminate"
  $scope.loadingMessage = "Cargando ..."
  $scope.btnContinue = false
  # *********************************** VARIABLES **********************************#
  $scope.currentAuthorizedProvider = null
  $scope.validPersonalData = false
  $scope.tabIndex =
    selectedIndex: 0
  rawDataFromDocument = []
  dataFromDocument = []

  $scope.sendingPost = false

  $scope.goToDocumentation = ->
    $scope.tabIndex.selectedIndex = 1

  # **************************************************************************
  # Fill up form with retrieved values
  $scope.currentAuthorizedProvider = AuthorizedProviderService.restoreModel()
  $scope.showLoading = false
  $scope.toggleOff = false 

  #--------------- scanner barcode----------------
  
  $scope.initBarcodeScanner = ->
    window.onkeydown = (e) ->
      if !e.metaKey
        if e.keyCode != 12 and e.keyCode != 187 and e.keyCode != 16 and e.keyCode != 9 and e.keyCode != 13
          rawDataFromDocument.push String.fromCharCode(e.keyCode)
        else
          e.preventDefault()
          rawDataFromDocument.push ','

 #------------- Switch variables----------------

  $scope.onChange = (toggleState) ->
    if toggleState == true
      $scope.initBarcodeScanner()
    else 
      console.log "false"
      false

  # TODO: convert the above function into an indepent function in order to bind it or unbnd it.
  
  $scope.copyDataFromIdDocument = ->
    rawDataFromDocumentString = rawDataFromDocument.join('').replace(/,,/g, ',') # It joins all character into a string.
    dataFromDocument = rawDataFromDocumentString.split(",")
    idDocumentNumber = dataFromDocument[1].toString()
    validateIdDocumentNumber(idDocumentNumber)
    firstLastName = dataFromDocument[2].toString() # TODO: made and object to map this info
    computeNameFrom(firstLastName)
    #$scope.currentAuthorizedProvider.first_name = dataFromDocument[2] 
     # alert "apellido incorrecta"
      #$state.go 'index_authorized_provider'
    #else
     # console.log "no hay problema"

  # TODO: made function to remove black values from rawDataFromDocument
  validateIdDocumentNumber = (idDocumentNumber) -> 
    if $scope.currentAuthorizedProvider.document_number != idDocumentNumber
      alert "Cedula incorrecta" # TODO: put standard popup mdDilaog here
      $state.go 'index_authorized_provider'
    else
      console.log "no hay problema" # TODO: put standard popup mdDilaog here

  computeNameFrom = (firstLastName) ->
    fullNameArray = $scope.currentAuthorizedProvider.fullName.toUpperCase().split(' ')
    position = fullNameArray.indexOf(firstLastName.toUpperCase())
    console.log position
    firstName = fullNameArray.slice(0, position).join(' ')
    lastName = fullNameArray.slice(position).join(' ')
    $scope.currentAuthorizedProvider.first_name = firstName
    $scope.currentAuthorizedProvider.last_name = lastName


    return

    #$scope.$watch 'currentAuthorizedProvider.document_number', (oldVal, newVal) ->
     # if oldVal and newVal != oldVal
      #  console.log "alerta!"
      #else 
       # console.log "no hay problema"


  # ********* Scanner variables and methods *********** #
  # This have to be executed before retrieve the AuthorizedProviderService model to check for pendind scaned files

  $scope.photo = CameraService.getLastScanImage()
  if CameraService.getJoinedFile() and CameraService.getJoinedFile().length > 0
    $scope.file = CameraService.getJoinedFile()

  else if ScannerService.getScanFiles() and ScannerService.getScanFiles().length > 0
    $scope.file = ScannerService.getScanFiles()

  if $scope.photo and CameraService.getTypeFile() == 1
    $scope.currentAuthorizedProvider.photo_file = $scope.photo
    # AuthorizedProviderService.saveModel()
    CameraService.clearData()

  if $scope.file
    if CameraService.getTypeFile() == 2
      $scope.currentAuthorizedProvider.id_document_file = $scope.file
      # AuthorizedProviderService.saveModel()
      goToDocumentation()

    if CameraService.getTypeFile() == 3
      $scope.currentAuthorizedProvider.mining_authorization_file = $scope.file
      # AuthorizedProviderService.saveModel()
      goToDocumentation()

    if CameraService.getTypeFile() == 4
      $scope.currentAuthorizedProvider.rut_file = $scope.file
      # AuthorizedProviderService.saveModel()
      goToDocumentation()

    if CameraService.getTypeFile() == 5
      $scope.currentAuthorizedProvider.chamber_of_commerce_file = $scope.file
      # AuthorizedProviderService.saveModel()
      goToDocumentation()

    if CameraService.getTypeFile() == 6
      $scope.currentAuthorizedProvider.mining_authorization_file = $scope.file
      goToDocumentation()
    #AuthorizedProviderService.saveModel()
    CameraService.clearData()
    ScannerService.clearData()

  $scope.scanner = (type) ->
    CameraService.setTypeFile type
    $scope.currentAuthorizedProvider = AuthorizedProviderService.model
    AuthorizedProviderService.saveModel()
    return

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
        $scope.searchStateText = ''
        $scope.searchCityText = ''
        $scope.cityDisabled = true
      when 'city'
        $scope.searchCityText = ''
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
  $scope.searchStateText = ''
  $scope.searchCityText = ''
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
    if city
      $scope.selectedCity = city
      $scope.currentAuthorizedProvider.city_id = city.id
    else
      #console.log 'City changed to none'
      flushFields 'city'
    return

  $scope.searchTextStateChange = (text) ->
    if text == ''
      flushFields 'state'
    return

  $scope.searchTextCityChange = (text) ->
    if text == '' || text == undefined
      flushFields 'city'
    return

  $scope.back = ->
    $window.history.back()
    return

#------------Validations -----------------#
  # Validates if the fiels are fill up or not
  # and take action ver the viwe flows.
  $scope.validatePersonalFields = ()->
    res = $scope.isEmptyOrUndefinedAnyField()
    if res == false
      $scope.validPersonalData = false
      $scope.tabIndex.selectedIndex = 0
      $scope.btnContinue = false
    else
      $scope.validPersonalData = true
      $scope.tabIndex.selectedIndex = 1
      $scope.btnContinue =  true

# ----------------- dependencie methods to the validations ------------------------#
  # Returns TRUE if the authorized provider data entered by the trader are OK
  # otherwise returns FLASE
  # @return [ Boolean ]
  $scope.isEmptyOrUndefinedAnyField = ()->
    isOk = false
    frm = $scope.currentAuthorizedProvider
    if frm.first_name == '' || frm.first_name == undefined
    else if frm.last_name == '' || frm.last_name == undefined
    else if frm.document_number == '' || frm.rucom.rucom_number == undefined
    else if frm.rucom.rucom_number == '' || frm.rucom.rucom_number == undefined
    else if frm.email == '' || frm.email == undefined
    else if frm.document_number == '' || frm.document_number == undefined
    else if frm.phone_number == '' || frm.phone_number == undefined
    else if frm.address == '' || frm.address == undefined
    else if frm.photo_file == '' || frm.photo_file == undefined
    else
      isOk = true
    return isOk
#-----------Validations -----------------#

  $scope.updateAuthorizedProvider = (ev)->
    validateDocumentationAndUpdate()

  validateDocumentationAndUpdate =  ()->
    if $scope.currentAuthorizedProvider.id_document_file == '' || $scope.currentAuthorizedProvider.mining_authorization_file == ''
      $mdDialog.show $mdDialog.alert().title('Formulario Incompleto').content('Debe subir toda la documentacion necesaria').ariaLabel('Alert Dialog Demo').ok('ok')
    else
      $scope.sendingPost = true
      AuthorizedProviderService.model = $scope.currentAuthorizedProvider
      AuthorizedProviderService.saveModel()
      AuthorizedProviderService.update($scope.currentAuthorizedProvider.id)
      $scope.showUploadingDialog()
      return

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

    
 