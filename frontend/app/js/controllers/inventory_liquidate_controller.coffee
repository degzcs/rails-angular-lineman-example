angular.module('app').controller 'InventoryLiquidateCtrl', ($scope,SaleService, PurchaseService,ClientService,CourierService) ->
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
  $scope.selectedCouries = null
  
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








