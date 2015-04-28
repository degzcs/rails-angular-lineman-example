angular.module('app').controller 'InventoryLiquidateCtrl', ($scope,SaleService, PurchaseService,ClientService,CourierService,$timeout,$mdDialog,$state,LiquidationService) ->
  #
  # Redirects to The index inventory if there is no pendinigs liquidations
  #
  if sessionStorage.pendingLiquidation == 'false'
    $state.go "index_inventory"
    return

  liquidation_info = LiquidationService.restoreState()
  console.log liquidation_info

  $scope.selectedPurchases = liquidation_info.selectedPurchases
  $scope.totalAmount = liquidation_info.totalAmount
  $scope.selectedGrade = null
  $scope.selectedWeight  = 0

  $scope.searchClientText = null
  $scope.selectedClient = null
  $scope.searchCourierText = null
  $scope.selectedCourier = null

  $scope.validation_messages = null
  $scope.clientVerifiedProgress = false
  
  $scope.calculate_weight = ->
    $scope.selectedWeight  = Number(($scope.totalAmount * 999/$scope.selectedGrade).toFixed(2))

  #
  # Seacrch clients by id
  #
  $scope.searchClients = (query)->
    if query 
      ClientService.retrieveClients.query {
        query_id: query
      }, ((clients, headers) ->
        console.log clients
        clients
      ), (error) ->
    else 
      return []

  #
  # Seacrch couriers by id
  #
  $scope.searchCouriers = (query)->
    console.log query
    if query 
      CourierService.retrieveCouriers.query {
        id_document_number: query
      }, ((couriers, headers) ->
        console.log couriers
        couriers
      ), (error) ->
    else 
      return []

  #
  # After select a client from the list clear the search word inside the autocomplete form and waits 400
  # milliseconds to update the client data just for user interaction purposes
  #
  $scope.setSelectedClient = (selectedClient)->
    $scope.searchClientText = null
    $scope.selectedClient = selectedClient
    $scope.clientVerifiedProgress = true
    $timeout (->
      $scope.clientVerifiedProgress = false
      return
    ), 400

  # Same for the courier autocomplete field
  $scope.setSelectedCourier = (selectedCourier)->
    $scope.searchCourierText = null
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

    if $scope.selectedClient == null || $scope.selectedCourier == null
      $scope.infoAlert('Atencion', 'Por favor un transportador y un cliente')
      return
    else
      gold_batch_params = {
        parent_batches: "",
        grams: $scope.totalAmount,
        grade: $scope.selectedGrade
      }

      sale_params = {
        courier_id: $scope.selectedCourier.id,
        client_id: $scope.selectedClient.id,
        grams: $scope.totalAmount,
        barcode: "hdjashkdjhq"
      }

      SaleService.create(sale_params,gold_batch_params).success((sale) ->
        #$scope.infoAlert('Felicitaciones!', 'La venta ha sido realizada')
        SaleService.model.id = sale.id
        SaleService.model.courier_id = sale.courier_id
        SaleService.model.client_id = sale.client_id
        SaleService.model.user_id = sale.user_id
        SaleService.model.gold_batch_id = sale.gold_batch_id
        SaleService.model.grams = sale.grams
        SaleService.model.barcode = sale.barcode
        SaleService.model.barcode_html = sale.barcode_html
        SaleService.model.selectedPurchases = $scope.selectedPurchases
        SaleService.model.totalAmount = $scope.totalAmount
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








