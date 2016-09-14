angular.module('app').controller 'InventoryLiquidateCtrl', ($scope, SaleService, PurchaseService,CourierService, $timeout, $mdDialog, $state, LiquidationService, User, $q) ->
  #
  # Redirects to The index inventory if there is no pendinigs liquidations
  #

  if sessionStorage.pendingLiquidation == 'false'
    $state.go "index_inventory"
    return

  liquidation_info = LiquidationService.restoreState()

  $scope.selectedPurchases = liquidation_info.selectedPurchases
  $scope.totalAmount = liquidation_info.totalAmount
  $scope.selectedGrade = null
  $scope.selectedWeight  = 0
  $scope.price = 0
  $scope.per_unit_value = null

  $scope.searchClientText = null
  $scope.selectedClient = null
  $scope.searchCourierText = null
  $scope.selectedCourier = null

  $scope.validation_messages = null
  $scope.clientVerifiedProgress = false

  $scope.calculate_weight = ->
    $scope.selectedWeight  = Number(($scope.totalAmount * 999/$scope.selectedGrade).toFixed(2))

  $scope.calculate_price = ->
    $scope.price = Number(($scope.totalAmount * $scope.per_unit_value).toFixed(2))

  $scope.calculate_law_
  #
  # Seacrch clients by id
  #

  query_for_clients = (query) ->
    # perform some asynchronous operation, resolve or reject the promise when appropriate.
    $q (resolve, reject) ->
      User.query_by_id(query).success (clients,config)->
        resolve clients
      return




  $scope.searchClients = (query)->
    if query
      promise = query_for_clients(query)
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


  query_for_couriers = (query) ->
    # perform some asynchronous operation, resolve or reject the promise when appropriate.
    $q (resolve, reject) ->
      CourierService.query_by_id(query).success (couriers,config)->
        resolve couriers
      return

  $scope.searchCouriers = (query)->
    if query
      promise = query_for_couriers(query)
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
        SaleService.model.id = sale.id
        SaleService.model.courier_id = sale.courier_id
        SaleService.model.buyer_id = sale.buyer_id
        SaleService.model.user_id = sale.user_id
        SaleService.model.gold_batch_id = sale.gold_batch_id
        SaleService.model.fine_grams = sale.fine_grams
        SaleService.model.code = sale.code
        SaleService.model.barcode_html = sale.barcode_html
        SaleService.model.selectedPurchases = $scope.selectedPurchases
        SaleService.model.totalAmount = $scope.totalAmount
        SaleService.model.price = sale.price
        SaleService.model.purchase_files_collection = sale.purchase_files_collection
        SaleService.model.proof_of_sale = sale.proof_of_sale
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











  #$scope.ingotsNumber = sale_info.ingotsNumber
  #$scope.ingots = []
  #$scope.divide_by_equal_amounts = false


  #
  #It creates an array of ingots based on the ingots_number selected by the user
  ###
  i=0
  while i < $scope.ingotsNumber
    item = {
      law: null,
      grams: null
    }
    $scope.ingots.push(item)
    i++
  ###

  ###
  #If the amount of ingots is lowe than 1 it doesn`t permit to divide by equal
  #
  if $scope.ingotsNumber > 1
    $scope.allow_equal_divider = true
  else
    $scope.allow_equal_divider = false
    $scope.ingots[0].grams = $scope.totalAmount
  ###

  #
  ###
  $scope.divideIngots = ->
    i=0
    while i < $scope.ingots.length
      if $scope.divide_by_equal_amounts
        $scope.ingots[i].grams = $scope.totalAmount/$scope.ingotsNumber
      else
        $scope.ingots[i].grams = null
      i++
    console.log "Ingots Divided"
  ###








