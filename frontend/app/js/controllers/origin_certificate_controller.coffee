
angular.module('app').controller 'OriginCertificateCtrl', ($timeout, $scope, $mdDialog, CurrentUser, ProviderService, PdfService) ->

  # $scope.origin_certificate_type = '' # can be 1) barequero_chatarrero 2) beneficiation_plant 3)

  # $scope.barequero_chatarrero_origin_certificate = BarequeroChatarreroOriginCertificateService.model
  # $scope.beneficiation_plant_origin_certificate = BeneficiationPlantOriginCertificateService.model
  # $scope.pawnshops_origin_certificate = HousesBuySellOriginCertificateService.model
  # $scope.authorized_miner_origin_certificate = AuthorizedMinerOriginCertificateService.model
  # $scope.mining_operators = []
  # $scope.invoices = []
  # $scope.allProviders  = []
  # $scope.searchText = null
  # $scope.searchMining = null

  # # Set buyer as a current user
  # CurrentUser.get().success (data) ->
  #   #IMPROVE: Set up Missing values to generate the Purchase invoice
  #   data.company_name = 'TrazOro'
  #   data.document_type = 'NIT'
  #   data.nit = '123456789456123'
  #   data.rucom_record = 6547896321
  #   data.office = 'TrazOro Popayan'
  #   data.city = 'Popayan'
  #   data.address = 'Calle # 123'
  #   data.phone = '3007854214'
  #   # set barequero chatarrero oc
  #   $scope.barequero_chatarrero_origin_certificate.buyer = data
  #   $scope.barequero_chatarrero_origin_certificate.city = data.city
  #   # set beneficiation plant oc
  #   $scope.beneficiation_plant_origin_certificate.buyer = data
  #   $scope.beneficiation_plant_origin_certificate.city = data.city
  #   # set houses buy and sell oc
  #   $scope.pawnshops_origin_certificate.buyer = data
  #   $scope.pawnshops_origin_certificate.city = data.city
  #   # set authorized miner oc
  #   $scope.authorized_miner_origin_certificate.buyer = data
  #   $scope.authorized_miner_origin_certificate.city = data.city

  # #
  # # Set the origin certificate type
  # $scope.setOriginCertificateType = (origin_certificate_type) ->
  #   $scope.origin_certificate_type = origin_certificate_type
  #   $location.path ('new_origin_certificate.barequero_chatarrero')

  # #
  # # Add mining operator field with empty values
  # #
  # $scope.addMiningOperator = ->
  #   if typeof $scope.mining_operators == 'undefined'
  #     $scope.mining_operators = []
  #   $scope.mining_operators.push
  #     data: '' #provider
  #     mineral_type: 'Oro'
  #     amount: ''
  #     measure_unit: 'Gramos'
  #     origin_certificate_number: ''
  #     type: ''

  # #
  # #
  # #
  # $scope.addInvoice = ->
  #   if typeof $scope.invoices == 'undefined'
  #     $scope.invoices = []
  #   $scope.invoices.push
  #     number: '' #provider
  #     date: ''
  #     description: ''
  #     amount: ''

  # #
  # # Search one specific provider into the allProviders array
  # # @return [Array] with the matched options with the query
  # $scope.searchProvider = (query)->
  #   console.log 'query: ' + query
  #   results = if query then $scope.allProviders.filter(createFilterFor(query)) else []
  #   results

  # #
  # # Create filter function for a query string, just filte by document number field
  # #@returns [Function] with the provider
  # createFilterFor = (query) ->
  #   lowercaseQuery = angular.lowercase(query)
  #   (provider) ->
  #     provider.document_number.indexOf(lowercaseQuery) != -1

  # #
  # # all providers
  # $scope.$watch 'origin_certificate_type', ->
  #   switch $scope.origin_certificate_type
  #     when 'barequero_chatarrero'
  #       console.log 'barequero_chatarrero'
  #       ProviderService.retrieve.byTypes {
  #         per_page: 100
  #         page: 1
  #         types: 'barequero_chatarrero'
  #       }, ((providers, headers) ->
  #           provs = setupAllProviders(providers)
  #           $timeout ->
  #             $scope.$apply ->
  #               $scope.allProviders = provs
  #       ), (error) ->
  #         console.log 'Error in Providers query'
  #     else
  #       console.log 'else'
  #       # ProviderService.retrieveProviders.query {
  #       #   per_page: 100
  #       #   page: 1
  #       # }, ((providers, headers) ->
  #       #   provs = setupAllProviders(providers)
  #       #   $timeout ->
  #       #       $scope.$apply ->
  #       #         $scope.allProviders = provs
  #       # ), (error) ->
  #       #   console.log 'Error in Providers query'

  # #
  # # Set all retrieved providers to the current scope
  # setupAllProviders =(providers)->
  #   provs = []
  #   i = 0
  #   while i < providers.length
  #     prov =
  #       id: providers[i].id
  #       document_number: providers[i].document_number
  #       company_name: 'company name test'
  #       document_type: 'nit'
  #       first_name: providers[i].first_name
  #       last_name: providers[i].last_name
  #       address: providers[i].address
  #       email: providers[i].email
  #       phone_number: providers[i].phone_number
  #       photo_file: providers[i].photo_file or 'http://robohash.org/' + providers[i].id
  #       num_rucom: providers[i].rucom.num_rucom
  #       rucom_record: providers[i].rucom.rucom_record
  #       provider_type: providers[i].rucom.provider_type
  #       rucom_status: providers[i].rucom.status
  #       mineral: providers[i].rucom.mineral
  #       name: providers[i].first_name + ' '+ providers[i].last_name
  #       city: 'Popayan'
  #       state: 'Cauca'
  #     provs.push prov
  #     i++
  #   provs

  # window.s = $scope

  # #
  # # Set mining operators properly and get the total  amount of gold
  # $scope.setMiningOperators = (mining_operators) ->
  #   mining_operators.forEach (element, index, array)->
  #     $scope.beneficiation_plant_origin_certificate.total_amount += parseInt(element.amount)
  #     $scope.beneficiation_plant_origin_certificate.mining_operators.push
  #       name: element.data.name
  #       document_type: element.data.document_type
  #       document_number: element.data.document_number
  #       mineral_type: element.mineral_type
  #       amount: element.amount
  #       measure_unit: element.measure_unit
  #       origin_certificate_number: element.origin_certificate_number
  #       type: element.type

  # #
  # # Set  Invoices in the model
  # $scope.setInvoices = (invoices)->
  #   $scope.pawnshops_origin_certificate.invoices =  invoices

  # #
  # # confirm Dialog
  # $scope.showConfirm = (ev, option) ->

  #   confirm = $mdDialog.confirm()
  #                     .title('Centificado de Origen')
  #                     .content('Esta seguro que desea realizar el certificado de origen?')
  #                     .ariaLabel('Lucky day')
  #                     .ok('Si, deseo generarlo')
  #                     .cancel('No, cancelar generacion de certificado')
  #                     .targetEvent(ev)
  #   $mdDialog.show(confirm).then (->
  #     switch option
  #       when 'barequero_chatarrero'
  #         PdfService.createBarequeroChatarreroOriginCertificate($scope.barequero_chatarrero_origin_certificate)
  #       when 'beneficiation_plant'
  #         $scope.setMiningOperators($scope.mining_operators)
  #         PdfService.createBeficiationPlantOriginCertificate($scope.beneficiation_plant_origin_certificate)
  #       when 'pawnshops'
  #         $scope.setInvoices($scope.invoices)
  #         PdfService.createHouseBuySellOriginCertificate($scope.pawnshops_origin_certificate)
  #       when 'authorized_miner'
  #         PdfService.createAutorizedMinerOriginCertificate($scope.authorized_miner_origin_certificate)
  #     $scope.message = 'Su certificado de origen ha sido generado exitosamente'
  #     return
  #   ), ->
  #     console.log 'purchase canceled'
  #     $scope.message = 'El proceso ha sido cancelado '
  #     return