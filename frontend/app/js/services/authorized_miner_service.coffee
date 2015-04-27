angular.module('app').factory 'AuthorizedMinerOriginCertificateService', ($rootScope, $filter)->
  service=
    model:
      date: $filter('date')(Date.now(), 'yyyy-MM-dd')
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
        type: 'Oro'
        amount: ''
        measure_unit: 'Gramos'
        state: ''
        city: ''
      ## mineral's Buyer info
      buyer:
        type: ''
        company_name: ''
        document_type: '' # can be : NIT, CC, RUT, Aliens Card (foreign identification card)
        document_number: ''
        rucom_record: ''

    #
    # Save model temporal states
    #
    saveState: ->
      sessionStorage.restorestate = 'true'
      sessionStorage.authorizedMinerOriginCertificate = angular.toJson(service.model)
    restoreState: ->
      if(sessionStorage.authorizedMinerOriginCertificate)
        service.model = angular.fromJson(sessionStorage.authorizedMinerOriginCertificate)
      else
        sessionStorage.restorestate = 'false'
    #
    # convert from data:image to Blob
    # convert: ->
  #
  # Listeners
  #
  # console.log(service)
  $rootScope.$on 'saveAuthorizedMinerOriginCertificate', service.saveState
  $rootScope.$on 'restoreAuthorizedMinerOriginCertificate', service.restoreState

  #
  # Return
  #
  service