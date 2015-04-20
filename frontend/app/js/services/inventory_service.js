
angular.module('app').factory('Inventory', function InventoryFactory($http){
  var currentInventory = null;
  return{
    setCurrent: function(inventory) {
      localStorage.setItem('currentInventory',JSON.stringify(inventory));
      console.log(inventory);
    },
    getCurrent: function(){
      currentInventory =JSON.parse(localStorage.getItem('currentInventory'));
      return currentInventory;
    }
  };
});