angular.module('app')
.controller 'InventoryAmountCtrl', ($scope, $filter, $window, $mdDialog,pickedItem) ->
    #Main scope variables
    $scope.pickedItem = pickedItem
    $scope.total_grams = pickedItem.inventory_remaining_amount
    $scope.selected_grams = null
    $scope.ingots_number = 1
    $scope.remaining_amount = $scope.total_grams 

    validate_inventory = ->
      if ($scope.remaining_amount > 0) && ($scope.remaining_amount < 1)
        return {invalid: true}
      else
        return {invalid: false}

    $scope.inventory_validation_messages = validate_inventory()

    $scope.calculate_remaining = ->
      $scope.remaining_amount = Number(($scope.total_grams - $scope.selected_grams).toFixed(2))
      $scope.inventory_validation_messages = validate_inventory()
  
    #After submit a valid amount it sent back the response to the directive with the selected grams
    $scope.submit = ->
      unless $scope.inventory_validation_messages.invalid
        $mdDialog.hide(parseFloat($scope.selected_grams))

    ### SELECT OPTIONS 
      $scope.gram_options = []
      i = 1
      #It creates an array of the posible grams amounts allowed 1 gram by 1
      while i < $scope.total_grams
        $scope.gram_options.push(i)
        i++

      #Then adds the total amount at the end
      $scope.gram_options.push($scope.total_grams)
    ###

  return

