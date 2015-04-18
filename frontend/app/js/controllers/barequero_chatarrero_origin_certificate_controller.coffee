
angular.module('app').controller 'OriginCertificateCtrl', ($scope, BarequeroChatarreroOriginCertificateService, $mdDialog, CurrentUser, ProviderService, PdfService) ->

  $scope.barequero_chatarrero_origin_certificate = BarequeroChatarreroOriginCertificateService.model
  $scope.allProviders  = []
  $scope.searchText = null


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
  $scope.barequeroChatarreroshowConfirm = (ev) ->

    confirm = $mdDialog.confirm()
                      .title('Centificado de Origen')
                      .content('Esta seguro que desea realizar el certificado de origen?')
                      .ariaLabel('Lucky day')
                      .ok('Si, deseo generarlo')
                      .cancel('No, cancelar generacion de certificado')
                      .targetEvent(ev)
    $mdDialog.show(confirm).then (->
      window.oc  = $scope.barequero_chatarrero_origin_certificate
      # provider = $scope.barequero_chatarrero_origin_certificate.provider
      # provider.name = provider.first_name + ' ' + provider.last_name
      #$scope.barequero_chatarrero_origin_certificate.provider = provider
      PdfService.createBarequeroChatarreroOriginCertificate($scope.barequero_chatarrero_origin_certificate)
      $scope.message = 'Su certificado de origen ha sido generado exitosamente'
      return
    ), ->
      console.log 'purchase canceled'
      $scope.message = 'El proceso ha sido cancelado '
      return