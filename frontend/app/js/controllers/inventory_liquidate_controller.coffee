angular.module('app').controller 'InventoryLiquidateCtrl', ($scope,SaleService, PurchaseService,ClientService,CourierService,$timeout,$mdDialog) ->
  sale_info = SaleService.restoreState()
  console.log sale_info

  $scope.selectedPurchases = sale_info.selectedPurchases
  $scope.totalAmount = sale_info.totalAmount
  $scope.selectedGrams = null
  $scope.selectedGrade = null
  $scope.selectedTotalAmount = 0

  $scope.searchClientText = null
  $scope.selectedClient = null
  $scope.searchCourierText = null
  $scope.selectedCourier = null

  $scope.validation_messages = null
  $scope.clientVerifiedProgress = false
  
  $scope.calculate_total_amount = ->
    $scope.selectedTotalAmount = Number(($scope.selectedGrams * $scope.selectedGrade/999).toFixed(2))
    if $scope.selectedTotalAmount == $scope.totalAmount
      $scope.validation_messages = {valid: true}
    else
      $scope.validation_messages = {invalid: true}
    
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

    if $scope.validation_messages.invalid || $scope.selectedClient == null || $scope.selectedCourier == null
      $scope.infoAlert('Atencion', 'Por favor ingrese todos los campos correctamente')
      return
    else
      gold_batch = {
        parent_batches: "",
        grams: $scope.totalAmount,
        grade: $scope.selectedGrade
      }

      sale = {
        courier_id: $scope.selectedCourier.id,
        client_id: $scope.selectedClient.id,
        grams: $scope.totalAmount,
        barcode: "hdjashkdjhq"
      }

      SaleService.create(sale,gold_batch).success((data) ->
        $scope.infoAlert('Felicitaciones!', 'La venta ha sido realizada')
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








