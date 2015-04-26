angular.module('app').factory 'BeneficiationPlantOriginCertificateService', ($rootScope, $filter)->
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
      mining_operators: [] # Array of Hashes with the next keys:  type, name, identification_type, identification_number, origin_certificate_number, amount, measure_unit and mineral_type
      total_amount: 0
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
      sessionStorage.beneficiationPlantOriginCertificate = angular.toJson(service.model)
    restoreState: ->
      if(sessionStorage.beneficiationPlantOriginCertificate)
        service.model = angular.fromJson(sessionStorage.beneficiationPlantOriginCertificate)
      else
        sessionStorage.restorestate = 'false'
    #
    # convert from data:image to Blob
    # convert: ->
  #
  # Listeners
  #
  # console.log(service)
  $rootScope.$on 'saveBeneficiationPlantOriginCertificate', service.saveState
  $rootScope.$on 'restoreBeneficiationPlantOriginCertificate', service.restoreState

  #
  # Return
  #
  service