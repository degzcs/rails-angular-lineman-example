angular.module('app').factory 'InventoryService', ($http)-> 
  service =
    
    update_all_inventories: (selectedPurchases)->
      selectedPurchases
      console.log "Cantidades Seleccionadas ***"
      i=0
      while i < selectedPurchases.length
        purchase = selectedPurchases[i]
        inventory_params = {
          remaining_amount: Number((purchase.inventory.remaining_amount - purchase.amount_picked).toFixed(2))
        }
        $http.put("api/v1/inventories/"+purchase.inventory.id, {inventory: inventory_params}).success(() ->
          console.log 'Se actualio el inventario'      
        ).error (data, status, headers, config) ->
          console.log 'EEROR', 'No se pudo realizar la solicitud'
        i++

      #return $http.put("api/v1/inventories/"+id, {inventory: inventory_params});
