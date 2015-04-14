angular.module('app').factory 'BarequeroChatarreroOriginCertificateService', ($rootScope, $upload)->
  service=
    model:
      date: ''
      current_city: '' # where is generated the current OC
      ## mineral's Provider Info
      authorized_miner_type: ''
      provider_first_name: ''
      provider_last_name: ''
      provider_document_number: 0
      provider_state: '' # state where the miner is/was registered
      provider_city: '' # city where the miner is/was registered
      mineral: '' #
      amount: ''
      measure_unit: ''
      ## mineral's Buyer info
      full_name_or_company_name: ''
      buyer_document_type: '' # can be : NIT, CC, RUT, Aliens Card (foreign identification card)
      buyer_document_number: ''

    #
    # Save model temporal states
    #
    saveState: ->
      sessionStorage.restorestate = 'true'
      sessionStorage.barequeroOriginCertificateService = angular.toJson(service.model)
    restoreState: ->
      if(sessionStorage.barequeroOriginCertificateService)
        service.model = angular.fromJson(sessionStorage.barequeroOriginCertificateService)
      else
        sessionStorage.restorestate = 'false'
    #
    # convert from data:image to Blob
    # convert: ->
  #
  # Listeners
  #
  # console.log(service)
  $rootScope.$on 'saveBarequeroOriginCertificateService', service.saveState
  $rootScope.$on 'restoreBarequeroOriginCertificateService', service.restoreState

  #
  # Return
  #
  service