angular.module('app').controller 'InventoryLiquidateCtrl', ($scope,Inventory, PurchaseService,ClientService,CourierService) ->
  sale_info = Inventory.getSaleInfo()
  $scope.selectedInventoryItems = sale_info.selected_items
  $scope.ingots_number = sale_info.ingots_number
  $scope.total_amount = sale_info.total_amount
  $scope.ingots = []
  $scope.searchClientText = null
  $scope.selectedClient = null
  $scope.searchCourierText = null
  $scope.selectedCouries = null
  $scope.divide_by_equal_amounts = false
  


  #It creates an array of ingots based on the ingots_number selected by the user
  i=0
  while i < $scope.ingots_number
    item = {
      law: null,
      grams: null
    }
    $scope.ingots.push(item)
    i++

  #If the amount of ingots is lowe than 1 it doesn`t permit to divide by equal
  if $scope.ingots_number > 1
    $scope.allow_equal_divider = true
  else
    $scope.allow_equal_divider = false
    $scope.ingots[0].grams = $scope.total_amount
    
  #Seacrch clients by id
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

  #Seacrch couriers by id
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
  $scope.divideIngots = ->
    i=0
    while i < $scope.ingots.length
      if $scope.divide_by_equal_amounts
        $scope.ingots[i].grams = $scope.total_amount/$scope.ingots_number 
      else
        $scope.ingots[i].grams = null
      i++
    console.log "Ingots Divided"


