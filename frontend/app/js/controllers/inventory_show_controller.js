angular.module('app').controller('InventoryShowCtrl', function($scope,Inventory) {
  var currentInventory = Inventory.getCurrent()
  console.log(currentInventory);

  
});