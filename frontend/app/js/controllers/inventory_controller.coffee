angular.module('app').controller 'InventoryController', ($scope, InventoryService) ->

  # get the list value from server response ans setup the list
  InventoryService.query ((res) ->
    $scope.list = res.list
  ), (error) ->
    # Error handler code

  # define scope values
  $scope.select_all = false
  $scope.finalGrams = ''

  #
  # Functions
  #

  # updates all checkboxes in the inventory list
  # @params inventoryList [Array]
  $scope.selectAll = (inventoryList) ->
    i = 0
    while i < inventoryList.length
      if $scope.select_all
        inventoryList[i].selected = false
      else
        inventoryList[i].selected = true
      i++
    console.log 'select all value ' + $scope.select_all
    console.log 'rows selected number' + inventoryList.length

  # selects a single item in the inventory list
  # @params item [Object]
  $scope.selectItem = (item) ->
    console.log 'selecciona item' + item.selected

