angular.module('app')
.controller 'InventoryAmountCtrl', ($scope, $filter, $window, $mdDialog,pickedItem) ->
    #Main scope variables
    $scope.pickedItem = pickedItem
    $scope.total_grams = pickedItem.inventory_remaining_amount
    $scope.gram_options = []
    i = 1
    
    #It creates an array of the posible grams amounts allowed 1 gram by 1
    while i < $scope.total_grams
      $scope.gram_options.push(i)
      i++

    #Then adds the total amount at the end
    $scope.gram_options.push($scope.total_grams)

    #After submit a valid amount it sent back the response to the directive with a hash 
    $scope.submit = ->
      $mdDialog.hide(parseFloat($scope.selected_grams))
  
  return

