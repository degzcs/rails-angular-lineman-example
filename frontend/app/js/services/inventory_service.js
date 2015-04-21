
angular.module('app').factory('Inventory', function InventoryFactory($http){
  var currentInventory = null;
  var inventorySelectedItems = null;
  return{
    setCurrent: function(inventory) {
      sessionStorage.setItem('currentInventory',JSON.stringify(inventory));
      console.log(inventory);
    },
    getCurrent: function(){
      currentInventory =JSON.parse(sessionStorage.getItem('currentInventory'));
      return currentInventory;
    },
    setSaleInfo: function(sale_info){
      sessionStorage.setItem('saleInfo',JSON.stringify(sale_info));
      console.log(JSON.parse(sessionStorage.getItem('saleInfo')));
    },
    getSaleInfo: function(){
      sale_info =JSON.parse(sessionStorage.getItem('saleInfo'));
      return sale_info;
    }
  };

});