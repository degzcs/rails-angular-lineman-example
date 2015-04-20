angular.module('app').directive 'mdTableInventory', ($mdDialog,Inventory,$state) ->
  {
    restrict: 'E'
    scope:
      headers: '='
      content: '='
      sortable: '='
      filters: '='
      customClass: '=customClass'
      thumbs: '='
      count: '='
      grams: '='
      selectall: '='

    controller: ($scope, $filter, $window)->
      orderBy = $filter('orderBy')
      $scope.tablePage = 0
      $scope.selectedItems = []
      $scope.totalAmount = 0
      $scope.show_inventory = (item)->
        Inventory.setCurrent(item)
        $state.go('show_inventory')
        return


      $scope.nbOfPages = ->
        if $scope.content
          Math.ceil $scope.content.length / $scope.count
        else
          1

      $scope.handleSort = (field) ->
        if $scope.sortable.indexOf(field) > -1
          true
        else
          false

      $scope.order = (predicate, reverse) ->
        $scope.content = orderBy($scope.content, predicate, reverse)
        $scope.predicate = predicate
        return

      $scope.order $scope.sortable[0], false

      $scope.getNumber = (num) ->
        new Array(num)

      $scope.goToPage = (page) ->
        $scope.tablePage = page
        return

      #selects a single item in the inventory list
      #@params item [Object]

      $scope.selectItem = (item, grams, ev) ->

        $scope.pickedItem = item
        if item.selected
          $scope.deleteGramsDialog(item, ev)
        else
          $scope.enterGramsDialog(item, ev)
          
        
      #updates all checkboxes in the inventory list
      
      $scope.selectAll = (inventoryItems, grams, selectall,ev) ->
        #First we check if the all select box is pressed
        if $scope.selectall
          #if its already pressed then we clean the variables and the items
          $scope.totalAmount = 0
          $scope.selectall = false
          $scope.selectedItems = []
          clean_checkbox_items(inventoryItems)
        else
          #The we check if there are already items selected, 
          if $scope.selectedItems.length != 0
            confirm = $mdDialog.confirm()
            .title('Confirmar')
            .content('Si selecciona esta opcion descartara las cantidades que ya especifico y seran adicionados todos los lotes')
            .ariaLabel('Lucky day').ok('Estoy seguro').cancel('Cancelar')
            .targetEvent(ev)

            $mdDialog.show(confirm).then (->
              #If the response is positive then clenans the previous values and recreate the arrays
              add_all_items(inventoryItems)
            ), ->
              $scope.selectall = false
              return
          else
            add_all_items(inventoryItems)
        return

      # Display a dialog that allows to enter the grams amount
      $scope.enterGramsDialog = (item,ev)->
        $mdDialog.show(
          controller: 'InventoryAmountCtrl'
          resolve: 
            pickedItem: -> 
              return item;
          templateUrl: 'partials/inventory_amount_form.html'
          targetEvent: ev).then ((answer) ->
          #It catches the answer and push it to the array selectItems, it also adds the amount to the total
          item.selected = true
          item.amount_picked = answer
          $scope.selectedItems.push(item)
          $scope.totalAmount = $scope.totalAmount + answer
          return
        ), ->
          #if the response is negative set the checkbox to false
          item.selected = false
          return
        return

      #Launches a dialog to ask the user if wants to delete the amount 
      $scope.deleteGramsDialog= (item,ev)->
        confirm = $mdDialog.confirm()
        .title('Confirmar')
        .content('Desea quitar estos gramos de la liquidacion?')
        .ariaLabel('Lucky day').ok('Si').cancel('No')
        .targetEvent(ev)

        $mdDialog.show(confirm).then (->
          $scope.selectall = false
          #If the response is positive then it finds the index of the item in the selectedItems array
          deleted_item_index = null
          i=0
          while i < $scope.selectedItems.length
            if item == $scope.selectedItems[i]
              deleted_item_index = i
            i++
          #Then deletes the item from the array and from the total
          $scope.totalAmount = $scope.totalAmount - $scope.selectedItems[deleted_item_index].amount_picked
          $scope.selectedItems.splice(deleted_item_index, 1)
          item.selected = false
          item.amount_picked = null
          return
        ), ->
          #If the response in negative sets the checkbox to true again
          item.selected = true
          return

      add_all_items = (inventoryItems)->
        $scope.selectall = true
        $scope.totalAmount = 0
        $scope.selectedItems = []
        i=0
        while i < inventoryItems.length
          item = inventoryItems[i]
          item.selected = true
          item.amount_picked = item.inventory_remaining_amount
          $scope.selectedItems.push(item)
          $scope.totalAmount = $scope.totalAmount + item.amount_picked
          i++
        console.log $scope.selectedItems
        return
      clean_checkbox_items = (inventoryItems)->
        i=0
        while i < inventoryItems.length
          item = inventoryItems[i]
          item.selected = false
          item.amount_picked = null
          i++
        console.log $scope.selectedItems
        return
      return
    
    templateUrl: 'directives/md-table-inventory.html'
    link: (scope, element, attrs)->

  }
