angular.module('app').directive 'mdTableInventory', ($mdDialog,LiquidationService,$state) ->
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
      pages: '='
      currentPage: '='

    controller: ($scope, $filter, $window, PurchaseService)->
      orderBy = $filter('orderBy')
      $scope.tablePage = 0
      $scope.selectedItems = []
      $scope.totalAmount = 0
      $scope.count = 0
      $scope.liquidate_selected_items = (ev)->
        
        if $scope.selectedItems.length == 0
          $mdDialog.show(
            $mdDialog.alert()
            .title('Mensaje Inventario')
            .content('Debe seleccionar al menos una cantidad')
            .ariaLabel('Alert Dialog Demo').ok('Ok')
            .targetEvent(ev))
        else
          #enterIngotsNumber(ev)
          confirm_liquidate($scope.totalAmount,ev)
        return
        

      $scope.show_inventory = (item)->
        PurchaseService.setCurrent(item)
        $state.go('show_inventory')
        return


      $scope.nbOfPages = ->
        # if $scope.content
        #   Math.ceil $scope.content.length / $scope.count
        # else
        #   1
        $scope.pages || 0

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

      $scope.loadMore = ->
        if $scope.pages > 0
          #i.e. if it's not the first time we retreve data from the API
          $scope.currentPage = $scope.currentPage + 1
          if $scope.currentPage <= $scope.pages
            return PurchaseService.all($scope.currentPage).success((purchases, status, headers, config) ->
              i = undefined
              purchase = undefined
              i = 0
              while i < purchases.length
                purchase =
                  id: purchases[i].id
                  user_id: purchases[i].user_id
                  price: purchases[i].price
                  origin_certificate_file: purchases[i].origin_certificate_file
                  seller_picture: purchases[i].seller_picture
                  origin_certificate_sequence: purchases[i].origin_certificate_sequence
                  created_at: purchases[i].created_at
                  reference_code: purchases[i].reference_code
                  access_token: purchases[i].access_token
                  provider: purchases[i].provider
                  gold_batch: purchases[i].gold_batch
                  inventory: purchases[i].inventory
                  provider_name: purchases[i].provider.first_name + ' ' + purchases[i].provider.last_name
                  inventory_remaining_amount: purchases[i].inventory.remaining_amount
                  gold_batch_grams: purchases[i].gold_batch.grams
                $scope.content.push purchase
                i++
              $scope.pages = parseInt(headers().total_pages)
              $scope.count = $scope.content.length
            ).error((data, status, headers, config) ->
              $scope.infoAlert 'ERROR', 'No se pudo realizar la solicitud'
            )
        return

      #selects a single item in the inventory list
      #@params item [Object]

      $scope.selectItem = (item, grams, ev) ->
        if item.selected
          #Delete selected grams
          $scope.deleteGramsDialog(item, ev)
        else
          #Show a message if there is no remainign grams
          if item.inventory_remaining_amount == 0
            show_dialog('Mensaje Inventario','No tiene gramos restantes en este lote', ev)
            return
          #Check if the remaining amount is lowe than 1
          if item.inventory_remaining_amount <= 1
            item.selected = true
            item.amount_picked = item.inventory_remaining_amount
            #Push the hash to the array of selected items
            $scope.selectedItems.push({purchase_id: item.id, amount_picked: item.amount_picked})
            $scope.totalAmount = Number(($scope.totalAmount + item.amount_picked).toFixed(2))
          else
            enterGramsDialog(item, ev)

      # Display a dialog that allows to enter the grams amount
      enterGramsDialog = (item,ev)->
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
          #Push the hash to the array of selected items
          $scope.selectedItems.push({purchase_id: item.id, amount_picked: item.amount_picked})
          $scope.totalAmount = Number(($scope.totalAmount + answer).toFixed(2))
          return
        ), ->
          #if the response is negative set the checkbox to false
          item.selected = false
          return
        return          


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
          #Then we check if there are already items selected, 
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

      add_all_items = (inventoryItems)->
        #Clear all the checkboxed and total amount
        $scope.selectall = true
        $scope.totalAmount = 0
        $scope.selectedItems = []
        i=0
        while i < inventoryItems.length
          item = inventoryItems[i]
          unless item.inventory_remaining_amount == 0
            item.selected = true
            item.amount_picked = item.inventory_remaining_amount
            #Push the hash to the array of selected items
            $scope.selectedItems.push({purchase_id: item.id, amount_picked: item.amount_picked})
            $scope.totalAmount = Number(($scope.totalAmount + item.amount_picked).toFixed(2))
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
            if item.id == $scope.selectedItems[i].purchase_id
              deleted_item_index = i
            i++
          #Then deletes the item from the array and from the total
          $scope.totalAmount = Number(($scope.totalAmount - $scope.selectedItems[deleted_item_index].amount_picked).toFixed(2))
          $scope.selectedItems.splice(deleted_item_index, 1)
          item.selected = false
          item.amount_picked = null
          return
        ), ->
          #If the response in negative sets the checkbox to true again
          item.selected = true
          return


      # Display a dialog that allows to enter the ingots number
      enterIngotsNumber = (ev)->
        $mdDialog.show(
          controller: 'InventoryIngotsCtrl'
          templateUrl: 'partials/ingots_number_form.html'
          targetEvent: ev).then ((answer) ->
          
          LiquidationService.model.selectedPurchases = $scope.selectedItems
          LiquidationService.model.totalAmount = $scope.totalAmount
          LiquidationService.model.ingotsNumber = answer
          LiquidationService.saveState()

          $state.go 'liquidate_inventory'
          return
        ), ->
          return
        return

      confirm_liquidate = (total_grams,ev)->
        confirm = $mdDialog.confirm()
        .title('Confirmar')
        .content('Esta seguro de liquidar ' +total_grams + ' gramos?')
        .ariaLabel('Lucky day').ok('Confirmar').cancel('Cancelar')
        .targetEvent(ev)

        $mdDialog.show(confirm).then (->
          LiquidationService.model.selectedPurchases = $scope.selectedItems
          LiquidationService.model.totalAmount = $scope.totalAmount
          LiquidationService.model.ingotsNumber = 1
          LiquidationService.saveState()

          $state.go 'liquidate_inventory'
          return
        ), ->
          #If the response in negative sets the checkbox to true again
          return
        return

      #Show simple information dialog
      show_dialog = (title, message, ev)->
        $mdDialog.show(
          $mdDialog.alert()
          .title(title)
          .content(message)
          .ariaLabel('Alert Dialog Demo').ok('Ok')
          .targetEvent(ev))
      return

    
    templateUrl: 'directives/md-table-inventory.html'
    link: (scope, element, attrs)->

  }
