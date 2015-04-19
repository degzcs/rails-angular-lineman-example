
angular.module('app').controller 'OriginCertificateCtrl', ($scope, BarequeroChatarreroOriginCertificateService, BeneficiationPlantOriginCertificateService, $mdDialog, CurrentUser, ProviderService, PdfService) ->

  $scope.origin_certificate_type = '' # can be 1) barequero_chatarrero 2) beneficiation_plant 3)

  $scope.barequero_chatarrero_origin_certificate = BarequeroChatarreroOriginCertificateService.model
  $scope.beneficiation_plant_origin_certificate = BeneficiationPlantOriginCertificateService.model
  $scope.mining_operators = []
  $scope.allProviders  = []
  $scope.searchText = null
  $scope.searchMining = null

  window.s= $scope

  # Set buyer as a current user
  CurrentUser.get().success (data) ->
    #IMPROVE: Set up Missing values to generate the Purchase invoice
    data.company_name = 'TrazOro'
    data.document_type = 'nit'
    data.nit = '123456789456123'
    data.rucom_record = 6547896321
    data.office = 'TrazOro Popayan'
    data.address = 'Calle falsa 123'
    data.phone = '3007854214'
    $scope.barequero_chatarrero_origin_certificate.buyer = data

  #
  # Set the origin certificate type
  $scope.setOriginCertificateType = (origin_certificate_type) ->
    $scope.origin_certificate_type = origin_certificate_type

  #
  #
  #
  $scope.addMiningOperator = ->
    if typeof $scope.mining_operators == 'undefined'
      $scope.mining_operators = []
    $scope.mining_operators.push
      data: '' #provider

  #
  # Search one specific provider into the allProviders array
  # @return [Array] with the matched options with the query
  $scope.searchProvider = (query)->
    console.log 'query: ' + query
    results = if query then $scope.allProviders.filter(createFilterFor(query)) else []
    results

  #
  # Create filter function for a query string, just filte by document number field
  #@returns [Function] with the provider
  createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (provider) ->
      provider.document_number.indexOf(lowercaseQuery) != -1

  #
  # all providers
  ProviderService.retrieveProviders.query {
    per_page: 100
    page: 1
  }, ((providers, headers) ->
    i = 0
    while i < providers.length
      prov =
        id: providers[i].id
        document_number: providers[i].document_number
        company_name: 'company name test'
        dicument_type: 'nit'
        first_name: providers[i].first_name
        last_name: providers[i].last_name
        address: providers[i].address
        email: providers[i].email
        phone_number: providers[i].phone_number
        photo_file: providers[i].photo_file or 'http://robohash.org/' + providers[i].id
        num_rucom: providers[i].rucom.num_rucom
        rucom_record: providers[i].rucom.rucom_record
        provider_type: providers[i].rucom.provider_type
        rucom_status: providers[i].rucom.status
        mineral: providers[i].rucom.mineral
        name: providers[i].first_name + ' '+ providers[i].last_name
        city: 'Popayan'
        state: 'Cauca'
      $scope.allProviders.push prov
      i++
  ), (error) ->

  #
  # confirm Dialog
  $scope.barequeroChatarreroshowConfirm = (ev, model) ->

    confirm = $mdDialog.confirm()
                      .title('Centificado de Origen')
                      .content('Esta seguro que desea realizar el certificado de origen?')
                      .ariaLabel('Lucky day')
                      .ok('Si, deseo generarlo')
                      .cancel('No, cancelar generacion de certificado')
                      .targetEvent(ev)
    $mdDialog.show(confirm).then (->
      switch model
        when 'barequero_chatarrero'
          PdfService.createBarequeroChatarreroOriginCertificate(model)
        when 'beneficiation_plant'
          PdfService.createBeficiationPlantOriginCertificate(model)
        when 'another'
          ''

      $scope.message = 'Su certificado de origen ha sido generado exitosamente'
      return
    ), ->
      console.log 'purchase canceled'
      $scope.message = 'El proceso ha sido cancelado '
      return