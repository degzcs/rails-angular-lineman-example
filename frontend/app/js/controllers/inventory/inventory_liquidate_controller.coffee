angular.module('app').controller 'InventoryLiquidateCtrl', ($scope, SaleService, PurchaseService,CourierService, $timeout, $mdDialog, $state, LiquidationService, User, $q) ->
  #
  # Redirects to The index inventory if there is no pendinigs liquidations
  #

  
  if sessionStorage.pendingLiquidation == 'false'
    $state.go "inventory"
    return

  liquidationInfo = LiquidationService.restoreState()

  $scope.selectedPurchases = liquidationInfo.selectedPurchases
  $scope.totalAmount = liquidationInfo.totalAmount
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

  $scope.weightedLaw = 0

  $scope.calculateWeight = ->
    $scope.selectedPurchases.forEach( (purchase, index)->
      purchase.gold_batch.percentage = purchase.gold_batch.grams/$scope.totalAmount
      $scope.weightedLaw += (purchase.gold_batch.grade * purchase.gold_batch.percentage)
    )
    
    $scope.selectedWeight = Number(($scope.totalAmount * 999/$scope.selectedGrade).toFixed(2))

  $scope.calculatePrice = ->
    $scope.price = Number(($scope.totalAmount * $scope.perUnitValue).toFixed(2))

  $scope.calculateLaw = ->
    $scope.selectedPurchases.forEach( (purchase, index)->
      purchase.gold_batch.percentage = purchase.gold_batch.grams/$scope.totalAmount
      $scope.weightedLaw += (purchase.gold_batch.grade * purchase.gold_batch.percentage)
    )
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
  #Submit a sale if the sale is valid
  #
  $scope.submitSale = ->
    dialog = $mdDialog.alert()
      .title('Generando Certificado ')
      .content('Espere un momento...')
      #.ok('hecho!')
      duration: 2

    $mdDialog.show dialog
    if $scope.selectedClient == null || $scope.selectedCourier == null
      $scope.infoAlert('Atencion', 'Por favor un transportador y un cliente')
      return
    else
      gold_batch_params = {
        fine_grams: $scope.totalAmount,
        grade: $scope.selectedGrade
      }

      sale_params = {
        courier_id: $scope.selectedCourier.id,
        buyer_id: $scope.selectedClient.id,
        price: $scope.price
      }

      SaleService.create(sale_params,gold_batch_params,$scope.selectedPurchases).success((sale) ->
        $scope.infoAlert('Felicitaciones!', 'La venta ha sido realizada')
        $mdDialog.cancel dialog
        SaleService.model = sale
        SaleService.saveState()
        $state.go('show_sale')
      ).error (data, status, headers, config) ->
        $scope.infoAlert('EEROR', 'No se pudo realizar la solicitud')

  #Dialg alert helper
  $scope.infoAlert = (title,content)->
    $mdDialog.show $mdDialog.alert()
      .title(title)
      .content(content)
      .ok('hecho!')
      duration: 2
    return
