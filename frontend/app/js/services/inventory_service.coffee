angular.module('app').factory 'InventoryService', ($http)-> 
  service =
    
    update_all_inventories: (selectedPurchases, sale_id)->
      selectedPurchases
      console.log "Cantidades Seleccionadas ***"
      i=0
      while i < selectedPurchases.length
        purchase = selectedPurchases[i]
        $http.put("api/v1/inventories/"+purchase.inventory.id, {sale_id: sale_id,amount_picked: purchase.amount_picked}).success(() ->
          console.log 'Se actualio el inventario'      
        ).error (data, status, headers, config) ->
          console.log 'EEROR', 'No se pudo realizar la solicitud'
        i++

      #return $http.put("api/v1/inventories/"+id, {inventory: inventory_params});
