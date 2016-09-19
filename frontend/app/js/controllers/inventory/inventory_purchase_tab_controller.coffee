angular.module('app').controller 'InventoryPurchaseTabCtrl', ($scope, $mdDialog, PurchaseService, LiquidationService) ->
  # ------------ Table directive configuration ----------- //
  $scope.toggleSearch = false
  #Headers of the table
  $scope.headers = [
    {
      name: 'Estado'
      field: 'sold'
    }
    {
      name: 'Fecha'
      field: 'created_at'
    }
    {
      name: 'ID Compra'
      field: 'id'
    }
    {
      name: 'Proveedor'
      field: 'seller_name'
    }
    {
      name: 'Gramos Finos'
      field: 'gold_batch_grams'
    }
    {
      name: 'Precio'
      field: 'price'
    }
  ]
  #Filters
  $scope.sortable = [
    'sold'
    'created_at'
    'seller_name'
    'gold_batch_grams'
    'price'
    'inventory_remaining_amount'
  ]
  #Variables configuration
  $scope.selectall = false
  $scope.grams = value: 0
  #Header Styles
  $scope.custom =
    seller_name: 'grey'
    id: 'bold'
    gold_batch_grams: 'grey'
    price: 'grey'
    created_at: 'bold'
    inventory_remaining_amount: 'bold'
    sold: 'bold'
  $scope.pages = 0
  $scope.currentPage = 1
  #---------------- Controller methods -----------------//
  #Purchase service call to api to retrieve all purchases for current user
  PurchaseService.all().success((purchases, status, headers, config) ->
    content = undefined
    i = undefined
    purchase = undefined
    content = []
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
        seller: purchases[i].seller
        gold_batch: purchases[i].gold_batch
        inventory: purchases[i].inventory
        trazoro: purchases[i].trazoro
        sale_id: purchases[i].sale_id
        barcode_html: purchases[i].barcode_html
        code: purchases[i].code
        seller_name: purchases[i].seller.first_name + ' ' + purchases[i].seller.last_name
        inventory_remaining_amount: purchases[i].inventory.remaining_amount
        gold_batch_grams: purchases[i].gold_batch.grams
        sold: purchases[i].gold_batch.sold
      content.push purchase
      i++
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = content.length
    $scope.content = content
  ).error (data, status, headers, config) ->
    $scope.infoAlert 'ERROR', 'No se pudo realizar la solicitud'

  $scope.infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    # .finally(function() {
    #     $window.history.back();
    #   });
    return

  $scope.show = (item) ->
    console.log 'selecciona item' + item.selected
    InventoryService.setItem item

#************************ from directive logic ***************************************
  $scope.liquidate_selected_items = (ev) ->
        console.log "scope_dialog_liquid..."
        confirm_liquidate($scope.totalAmount, ev)
        # NOTE: this part of code was disable becuase it is not needed to split gold
        #if $scope.selectedItems.length == 0
        #  $mdDialog.show(
        #    $mdDialog.alert()
        #    .title('Mensaje Inventario')
        #    .content('Debe seleccionar al menos una cantidad')
        #    .ariaLabel('Alert Dialog Demo').ok('Ok')
        #    .targetEvent(ev))
        #else
          #enterIngotsNumber(ev)
        
        #return

  $scope.confirm_liquidate = (total_grams,ev)->
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


  $scope.show_inventory_purchase = (item)->
    PurchaseService.model.price = item.price
    PurchaseService.model.seller_picture = item.seller_picture
    PurchaseService.model.origin_certificate_sequence = item.origin_certificate_sequence
    PurchaseService.model.origin_certificate_file = item.origin_certificate_file
    PurchaseService.model.fine_gram_unit_price = item.fine_gram_unit_price
    PurchaseService.model.reference_code = item.reference_code
    PurchaseService.model.barcode_html = item.barcode_html
    PurchaseService.model.code = item.code
    PurchaseService.model.trazoro = item.trazoro
    PurchaseService.model.sale_id = item.sale_id
    PurchaseService.model.seller = item.seller
    PurchaseService.model.gold_batch = item.gold_batch
    PurchaseService.model.barcode_html = item.barcode_html
    PurchaseService.model.code = item.code
    PurchaseService.model.sold = item.sold
    PurchaseService.saveState()
    $state.go('show_inventory')
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
      $scope.totalAmount = Number(($scope.totalAmount * $scope.selectedItems[deleted_item_index].amount_picked).toFixed(2))
      $scope.selectedItems.splice(deleted_item_index, 1)
      item.selected = false
      item.amount_picked = null
      return
    ), ->
      #If the response in negative sets the checkbox to true again
      item.selected = true
      return  

  $scope.selectItem = (item, grams, ev) ->
    if item.selected 
      #Delete selected grams
      $scope.deleteGramsDialog(item, ev)
    else
      #Show a message if there is no remainign grams
      if item.gold_batch_grams == 0
        show_dialog('Mensaje Inventario','No tiene gramos restantes en este lote', ev)
        return
      item.selected = true
      item.sold = item.sold
      item.amount_picked = item.gold_batch_grams
      #Push the hash to the array of selected items
      $scope.selectedItems.push({purchase_id: item.id, amount_picked: item.amount_picked, sold: item.sold})
      $scope.totalAmount = Number(($scope.totalAmount + item.amount_picked).toFixed(2))


  $scope.add_all_items = (inventoryItems)->
    #Clear all the checkboxed and total amount
    $scope.selectall = true
    $scope.totalAmount = 0
    $scope.selectedItems = []
    i=0
    while i < inventoryItems.length
      item = inventoryItems[i]
      unless item.gold_batch_grams == 0
        item.selected = true
        item.amount_picked = item.gold_batch_grams
        item.sold = item.sold
        #Push the hash to the array of selected items
        $scope.selectedItems.push({purchase_id: item.id, amount_picked: item.amount_picked, sold: item.sold})
        $scope.totalAmount = Number(($scope.totalAmount + item.amount_picked).toFixed(2))
      i++
    console.log $scope.selectedItems
    return

  $scope.clean_checkbox_items = (inventoryItems)->
    i=0
    while i < inventoryItems.length
      item = inventoryItems[i]
      item.selected = false
      item.amount_picked = null
      i++
    console.log $scope.selectedItems
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

 # Display a dialog that allows to enter the ingots number
  $scope.enterIngotsNumber = (ev)->
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
