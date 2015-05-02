angular.module('app').factory 'PawnshopsOriginCertificateService', ($rootScope, $upload, $filter)->
  service=
    model:
      type: ''
      date: $filter('date')(Date.now(), 'yyyy-MM-dd')
      certificate_number: ''# NOTE: I think this is a origin certificate number
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
      invoices: [] # Array of Hashes with the next keys:

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
      sessionStorage.housesBuySellOriginCertificate = angular.toJson(service.model)
    restoreState: ->
      if(sessionStorage.housesBuySellOriginCertificate)
        service.model = angular.fromJson(sessionStorage.housesBuySellOriginCertificate)
      else
        sessionStorage.restorestate = 'false'
    #
    # convert from data:image to Blob
    # convert: ->
  #
  # Listeners
  #
  # console.log(service)
  $rootScope.$on 'saveHousesBuySellOriginCertificate', service.saveState
  $rootScope.$on 'restoreHousesBuySellOriginCertificate', service.restoreState

  #
  # Return
  #
  service