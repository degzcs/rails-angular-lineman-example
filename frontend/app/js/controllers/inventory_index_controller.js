angular.module('app').controller('InventoryIndexCtrl', function($scope, PurchaseService) {
  
  // ------------ Table directive configuration ----------- //
  $scope.toggleSearch = false;
  //Headers of the table
  $scope.headers = [
    {
      name: 'Fecha',
      field: 'created_at'
    },{
      name: 'Proovedor',
      field: 'provider_name'
    }, {
      name: 'Gramos Finos',
      field: 'gold_batch_grams'
    }, {
      name: 'Precio',
      field: 'price'
    },{
      name: 'Gramos Restantes',
      field: 'inventory_remaining_amount'
    }
  ];
  //Filters 
  $scope.sortable = ['created_at','provider_name', 'gold_batch_grams', 'price', 'inventory_remaining_amount'];
  //Variables configuration
  $scope.selectall = false;
  $scope.grams = {
    value: 0
  };
  //Header Styles
  $scope.custom = {
    provider_name: 'grey',
    gold_batch_grams: 'grey',
    price: 'grey',
    created_at: 'bold',
    inventory_remaining_amount: 'bold',
  };

  //---------------- Controller methods -----------------//
  //Purchase service call to api to retrieve all purchases for current user
  PurchaseService.all().success(function(purchases, headers) {
    var content, i, purchase;
    content = [];
    i = 0;
    while (i < purchases.length) {
      purchase = {
        provider_name: purchases[i].provider.first_name,
        gold_batch_grams: purchases[i].gold_batch.grams,
        price: purchases[i].price,
        created_at: purchases[i].created_at,
        inventory_remaining_amount: purchases[i].inventory.remaining_amount
      };
      content.push(purchase);
      i++;
    }
    $scope.count = content.length;
    return $scope.content = content;
  }).error(function(data, status, headers, config) {
    return $scope.infoAlert('EEROR', 'No se pudo realizar la solicitud');
  });
  

  
  return $scope.show = function(item) {
    console.log('selecciona item' + item.selected);
    return InventoryService.setItem(item);
  };
});