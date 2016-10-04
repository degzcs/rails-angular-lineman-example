angular.module('app').controller 'SaleOrderLiquidateCtrl', ($scope, SaleService, PurchaseService,CourierService, $timeout, $mdDialog, $state, LiquidationService,   CurrentUser,User, $q) ->
  #
  # Redirects to The index sale if there is no pendinigs liquidations
  #


  if sessionStorage.pendingLiquidation == 'false'
    $state.go "new_sale"
    return

  liquidationInfo = LiquidationService.restoreState()
  saleOrderInfo = SaleService.restoreState()

  $scope.weightedLaw = liquidationInfo.weightedLaw || 0
  $scope.selectedPurchases = liquidationInfo.selectedPurchases
  $scope.totalAmount = liquidationInfo.totalAmount || 1
  $scope.calculateLaw = ->
    $scope.selectedPurchases.forEach( (purchase, index)->
      purchase.gold_batch.percentage = purchase.gold_batch.grams/$scope.totalAmount
      $scope.weightedLaw += (purchase.gold_batch.grade * purchase.gold_batch.percentage)
    )

  #calculateLaw()
  $scope.selectedGrade = null
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

  console.log 'saleOrder: '
  console.log $scope.saleOrder


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
  # Seacrch couriers by id
  #

  queryForCouriers = (query) ->
    # perform some asynchronous operation, resolve or reject the promise when appropriate.
    $q (resolve, reject) ->
      CourierService.query_by_id(query).success (couriers,config)->
        resolve couriers
      return

  $scope.searchCouriers = (query)->
    if query
      promise = queryForCouriers(query)
      promise.then ((couriers) ->
        return couriers

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
    console.log 'selectedClient: '
    console.log selectedClient
    $scope.clientVerifiedProgress = true
    $timeout (->
      $scope.clientVerifiedProgress = false
      return
    ), 400

  # Same for the courier autocomplete field
  $scope.setSelectedCourier = (selectedCourier)->
    #$scope.searchCourierText = null
    $scope.selectedCourier = selectedCourier
    $scope.courierVerifiedProgress = true
    $timeout (->
      $scope.courierVerifiedProgress = false
      return
    ), 400

  #
  #Submit a sale Order if the sale is valid
  #
  $scope.submitSale = ->
    dialog = $mdDialog.alert()
      .title('Generando Certificado ')
      .content('Espere un momento...')
      #.ok('hecho!')
      duration: 2

    $mdDialog.show dialog
    if $scope.selectedClient == null # || $scope.selectedCourier == null
      $scope.infoAlert('Atencion', 'Por favor elija un cliente para su Orden de Venta')
      return
    else
      gold_batch_params = {
        fine_grams: $scope.totalAmount,
        ##grade: $scope.selectedGrade
        grade: $scope.weightedLaw
      }

      sale_params = {
        #courier_id: $scope.selectedCourier.id,
        buyer_id: $scope.selectedClient.id,
        price: $scope.price
      }

      SaleService.create(sale_params,gold_batch_params,$scope.selectedPurchases).success((sale) ->
        $scope.infoAlert('Felicitaciones!', 'La orden de venta ha sido creada')
        $mdDialog.cancel dialog
        console.log 'Sale Object: '
        console.log sale

        LiquidationService.model.selectedPurchases = $scope.selectedPurchases
        LiquidationService.model.totalAmount = $scope.totalAmount
        LiquidationService.saveState()

        SaleService.model = sale
        SaleService.saveState()

        $state.go('new_sale.step4')
      ).error (data, status, headers, config) ->
        $scope.infoAlert('ERROR', 'No se pudo realizar la solicitud')

  $scope.newSaleOrder = ->
    LiquidationService.deleteState()
    SaleService.deleteState()
    $state.go('new_sale.step1')

  #Dialg alert helper
  $scope.infoAlert = (title,content)->
    $mdDialog.show $mdDialog.alert()
      .title(title)
      .content(content)
      .ok('hecho!')
      duration: 2
    return

  $scope.DownloadSaleFiles =->
    window.open($scope.saleOrder.purchase_files_collection.file.url, "_blank")
    window.open($scope.saleOrder.proof_of_sale.file.url, "_blank")
    window.open($scope.saleOrder.shipment.file.url, "_blank")
    return true
