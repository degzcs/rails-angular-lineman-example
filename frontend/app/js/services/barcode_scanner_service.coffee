angular.module('app').factory 'BarcodeScannerService', ($resource, $upload, $http, $mdDialog, $state) ->
  
  service =
  rawDataFromDocument: []
  dataFromDocument: []
  fullNameScopeS: ''
  firstNameScope: ''
  lastNameScope: ''
  documentNumberScope: ''


  initBarcodeScanner = ->
    window.onkeydown = (e) ->
    if !e.metaKey
      if e.keyCode != 12 and e.keyCode != 187 and e.keyCode != 16 and e.keyCode != 9 and e.keyCode != 13
        rawDataFromDocument.push String.fromCharCode(e.keyCode)
      else
        e.preventDefault()
        rawDataFromDocument.push ','


  copyDataFromIdDocument = (documentNumberScope) ->
    rawDataFromDocumentString = rawDataFromDocument.join('').replace(/,,/g, ',') # It joins all character into a string.
    dataFromDocument = rawDataFromDocumentString.split(",")
    firstWhiteSpace = dataFromDocument.indexOf('')
    if firstWhiteSpace == 0
      dataFromDocument.splice(firstWhiteSpace, 1)
      idDocumentNumber = dataFromDocument[0].toString()
      validateIdDocumentNumber(idDocumentNumber, documentNumberScope)
      firstLastName = dataFromDocument[1].toString() # TODO: made and object to map this info
    else
      idDocumentNumber = dataFromDocument[0].toString()
      validateIdDocumentNumber(idDocumentNumber, documentNumberScope)
      firstLastName = dataFromDocument[1].toString()

    computeNameFrom(firstLastName)


  computeNameFrom = (firstLastName, fullNameScope, firstNameScope, lastNameScope) ->
  fullNameArray = fullNameScope.toUpperCase().split(' ')
  position = fullNameArray.indexOf(firstLastName.toUpperCase())
  console.log position
  firstName = fullNameArray.slice(0, position).join(' ')
  lastName = fullNameArray.slice(position).join(' ')
  firstNameScope = firstName
  lastNameScope = lastName

  validateIdDocumentNumber = (idDocumentNumber, documentNumberScope) -> 
  if documentNumberScope != idDocumentNumber
    alert "Cedula incorrecta" # TODO: put standard popup mdDilaog here
    $state.go 'index_authorized_provider'
  else
    console.log "no hay problema" # TODO: put standard popup mdDilaog here

  return service
