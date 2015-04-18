angular.module('app').factory 'BarequeroChatarreroOriginCertificateService', ($rootScope, $upload)->
  service=
    model:
      date: ''
      city: '' # where is generated the current OC
      ## mineral's Provider Info
      provider:
        type: ''
        first_name: ''
        last_name: ''
        name: ''
        document_number: 0
        state: '' # state where the miner is/was registered
        city: '' # city where the miner is/was registered
      ##mineral info
      mineral:
        type: ''
        amount: ''
        measure_unit: ''
      ## mineral's Buyer info
      buyer:
        company_name: ''
        document_type: '' # can be : NIT, CC, RUT, Aliens Card (foreign identification card)
        document_number: ''
        rucom_record: ''

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