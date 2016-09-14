
angular.module('app').controller 'AuthorizedMinerOriginCertificateCtrl', ($timeout, $scope, AuthorizedMinerOriginCertificateService, $mdDialog, CurrentUser, AuthorizedProviderService, PdfService, $state, $q) ->

  $scope.tab = 3

  $scope.authorized_miner_origin_certificate = AuthorizedMinerOriginCertificateService.model
  $scope.allProviders  = []
  $scope.searchText = null
  $scope.searchMining = null

  # Set buyer as a current user
  CurrentUser.get().success (data) ->
    #IMPROVE: Set up Missing values to generate the Purchase invoice
    data.document_type = 'NIT'
    # set authorized miner oc
    $scope.authorized_miner_origin_certificate.buyer = data
    $scope.authorized_miner_origin_certificate.city = data.city_name
    $scope.authorized_miner_origin_certificate.buyer.type = "Comercializador"


  #
  # Search one specific provider into the allProviders array
  # @return [Array] with the matched options with the query


  query_for_providers = (query) ->
    # perform some asynchronous operation, resolve or reject the promise when appropriate.
    $q (resolve, reject) ->
      AuthorizedProviderService.queryById.success (providers)->
        $scope.allProviders = []

        provs = $scope.setupAllProviders(providers)
        $scope.allProviders = provs
        resolve $scope.allProviders

      return

  $scope.searchProvider = (query)->
    if query
      promise = query_for_providers(query)
      promise.then ((providers) ->
        return providers

      ), (reason) ->
        console.log 'Failed: ' + reason
        return
    else
      return []


  # $scope.searchProvider = (query)->
  #   console.log 'query: ' + query
  #   results = if query then $scope.allProviders.filter(createFilterFor(query)) else []
  #   results

  #
  # Create filter function for a query string, just filte by document number field
  #@returns [Function] with the provider
  createFilterFor = (query) ->
    lowercaseQuery = angular.lowercase(query)
    (provider) ->
      provider.document_number.indexOf(lowercaseQuery) != -1


    #
  # all providers
  # ProviderService.retrieve.byTypes {
  #   per_page: 100
  #   page: 1
  #   types: 'solicitantes'
  # }, ((providers, headers) ->
  #     provs = setupAllProviders(providers)
  #     $timeout ->
  #       $scope.$apply ->
  #         $scope.allProviders = provs
  # ), (error) ->
  #   console.log 'Error in Providers query'

  #
  # Set all retrieved providers to the current scope
  $scope.setupAllProviders =(providers)->
    provs = []
    i = 0
    while i < providers.length
      #TODO: obtain company name for providers
      company_name  = providers[i].first_name + " " + providers[i].last_name
      if providers[i].company
        company_name = providers[i].company.name
      prov =
        id: providers[i].id
        document_number: providers[i].document_number
        company_name: company_name
        document_type: 'NIT'
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
        city: providers[i].city.name || 'Popayan'
        state: providers[i].state.name || 'Cauca'
      provs.push prov
      i++
    provs

  # window.s = $scope

  #
  # confirm Dialog
  $scope.showConfirm = (ev, option) ->
    confirm = $mdDialog.confirm()
                      .title('Centificado de Origen')
                      .content('Esta seguro que desea realizar el certificado de origen?')
                      .ariaLabel('Lucky day')
                      .ok('Si, deseo generarlo')
                      .cancel('No, cancelar generacion de certificado')
                      .targetEvent(ev)
    $mdDialog.show(confirm).then (->
      PdfService.createAutorizedMinerOriginCertificate($scope.authorized_miner_origin_certificate)
      $scope.message = 'Su certificado de origen ha sido generado exitosamente'
      return
    ), ->
      console.log 'purchase canceled'
      $scope.message = 'El proceso ha sido cancelado '
      return

  $scope.createProvider = ->
    AuthorizedProviderService.setCallerState('new_origin_certificate.authorized_miner')
    $state.go('search_rucom',{type: 'provider'})