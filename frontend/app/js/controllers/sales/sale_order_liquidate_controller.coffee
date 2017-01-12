angular.module('app').controller 'SaleOrderLiquidateCtrl', ($scope, SaleService, PurchaseService,CourierService, $timeout, $mdDialog, $state, LiquidationService,   CurrentUser,User, $q) ->
  #
  # Redirects to The index sale if there is no pendinigs liquidations
  #

  if sessionStorage.pendingLiquidation == 'false'
    $state.go "new_sale.sale_home"
    return

  liquidationInfo = LiquidationService.restoreState()
  saleOrderInfo = SaleService.restoreState()

  $scope.weightedLaw = liquidationInfo.weightedLaw || 0
  $scope.selectedPurchases = liquidationInfo.selectedPurchases
  $scope.totalAmount = liquidationInfo.totalAmount || 1
  $scope.mineral_type = liquidationInfo.selectedPurchases[0].gold_batch.mineral_type
  $scope.calculateLaw = ->
    $scope.selectedPurchases.forEach( (purchase, index)->
      purchase.gold_batch.percentage = purchase.gold_batch.grams/$scope.totalAmount
      $scope.weightedLaw += (purchase.gold_batch.grade * purchase.gold_batch.percentage)
    )

  $scope.selectedGrade = null
  $scope.selectedSaleType = null
  $scope.selectedWeight  = 0
  $scope.price = 0
  $scope.perUnitValue = null

  $scope.searchClientText = null
  $scope.selectedClient = null
  $scope.searchCourierText = null
  $scope.selectedCourier = null

  $scope.validationMessages = null
  $scope.clientVerifiedProgress = false
  $scope.saleOrder = saleOrderInfo

  CurrentUser.get().success (user) ->
   $scope.currentUser = user

  $scope.calculateWeight = ->
    $scope.selectedPurchases.forEach( (purchase, index)->
      purchase.gold_batch.percentage = purchase.gold_batch.grams/$scope.totalAmount
      $scope.weightedLaw += (purchase.gold_batch.grade * purchase.gold_batch.percentage)
    )

    ##$scope.selectedWeight = Number(($scope.totalAmount * 999/$scope.selectedGrade).toFixed(2))
    $scope.selectedWeight = Number(($scope.totalAmount * 999/$scope.weightedLaw).toFixed(2))

  $scope.calculatePrice = ->
    $scope.price = Number(($scope.totalAmount * $scope.perUnitValue).toFixed(2))

  #
  # Seacrch clients by id
  #

  queryForClients = (query) ->
    # perform some asynchronous operation, resolve or reject the promise when appropriate.
    $q (resolve, reject) ->
      User.query_by_id(query).success (clients,config)->
        resolve clients
      return

  $scope.searchClients = (query)->
    if query
      promise = queryForClients(query)
      promise.then ((clients) ->
        return clients

      ), (reason) ->
        console.log 'Failed: ' + reason
        return
    else
      return []

  #
  # After select a client from the list clear the search word inside the autocomplete form and waits 400
  # milliseconds to update the client data just for user interaction purposes
  #
  $scope.setSelectedClient = (selectedClient)->
    #$scope.searchClientText = null
    $scope.selectedClient = selectedClient
    $scope.clientVerifiedProgress = true
    $timeout (->
      $scope.clientVerifiedProgress = false
      return
    ), 400

  #
  # Submit a sale Order if the sale is valid
  #
  $scope.submitSale = ->
    dialog = $mdDialog.alert()
      .title('Generando Certificado ')
      .content('Espere un momento...')
      duration: 2
    if validatePresenceOfValues()
      $mdDialog.show dialog

      sale_params = {}
      sale_params['price'] = $scope.price
      sale_params['buyer_id'] = $scope.selectedClient.id if $scope.selectedSaleType == 'directly_buyer'

      gold_batch_params = {
        fine_grams: $scope.totalAmount,
        grade: $scope.weightedLaw
        mineral_type: $scope.mineral_type
      }
      createSale(sale_params, gold_batch_params, dialog)

  # @return [ Boolean ]
  validatePresenceOfValues = ->
    if $scope.selectedClient == null && $scope.selectedSaleType == 'directly_buyer'
      $scope.infoAlert('Atencion', 'Por favor elija un cliente para su Orden de Venta')
      return false
    else if $scope.price == 0 || $scope.price == null
      $scope.infoAlert('Atencion', 'Por favor debe ingresar el precio a Fijar para la orden de Venta')
      return false
    return true

  # Call the service incharged to create a Sale
  createSale = (sale_params, gold_batch_params, dialog)->
    SaleService.create(sale_params, gold_batch_params, $scope.selectedPurchases, $scope.selectedSaleType).success((sale) ->
      $scope.infoAlert('Felicitaciones!', 'La orden de venta ha sido creada')
      $mdDialog.cancel dialog

      LiquidationService.model.selectedPurchases = $scope.selectedPurchases
      LiquidationService.model.totalAmount = $scope.totalAmount
      #LiquidationService.model.weightedLaw = $scope.weightedLaw
      LiquidationService.saveState()

      SaleService.model = sale
      SaleService.model.weightedLaw = $scope.weightedLaw
      SaleService.saveState()

      $state.go('new_sale.step4')
    ).error (data, status, headers, config) ->
      $scope.infoAlert('ERROR', 'No se pudo realizar la solicitud' + data.message)

  $scope.newSaleOrder = ->
    LiquidationService.deleteState()
    SaleService.deleteState()
    $state.go('new_sale.step1')

  #Dialg alert helper
  $scope.infoAlert = (title,content)->
    $mdDialog.show $mdDialog.alert()
      .title(title)
      .content(content)
      .ok('Continuar')
      duration: 2
    return

  $scope.DownloadSaleFiles =->
    window.open($scope.saleOrder.purchase_files_collection.file.url, "_blank")
    window.open($scope.saleOrder.proof_of_sale.file.url, "_blank")
    window.open($scope.saleOrder.shipment.file.url, "_blank")
    return true
