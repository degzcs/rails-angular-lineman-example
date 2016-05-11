angular.module('app').controller('InventoryIndexCtrl', function($scope, $mdDialog, PurchaseService) {

  // ------------ Table directive configuration ----------- //
  $scope.toggleSearch = false;
  //Headers of the table
  $scope.headers = [
    {
      name: 'Fecha',
      field: 'created_at'
    },{
      name: 'ID Compra',
      field: 'id'
    },{
      name: 'Proveedor',
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
    id: 'bold',
    gold_batch_grams: 'grey',
    price: 'grey',
    created_at: 'bold',
    inventory_remaining_amount: 'bold',
  };

  $scope.pages = 0;
  $scope.currentPage = 1;

  //---------------- Controller methods -----------------//
  //Purchase service call to api to retrieve all purchases for current user
  PurchaseService.all().success(function(purchases, status, headers, config) {
    var content, i, purchase;
    content = [];
    i = 0;
    while (i < purchases.length) {
      purchase = {
        // Default purchase entity parameters
        id: purchases[i].id,
        user_id: purchases[i].user_id,
        price: purchases[i].price,
        origin_certificate_file: purchases[i].origin_certificate_file,
        seller_picture: purchases[i].seller_picture,
        origin_certificate_sequence: purchases[i].origin_certificate_sequence,
        created_at: purchases[i].created_at,
        reference_code: purchases[i].reference_code,
        access_token: purchases[i].access_token,
        provider: purchases[i].provider,
        gold_batch: purchases[i].gold_batch,
        inventory: purchases[i].inventory,
        trazoro:  purchases[i].trazoro,
        sale_id: purchases[i].sale_id,
        barcode_html: purchases[i].barcode_html,
        code: purchases[i].code,
        // Aditional table paramters
        provider_name: purchases[i].provider.first_name + " " + purchases[i].provider.last_name,
        inventory_remaining_amount: purchases[i].inventory.remaining_amount,
        gold_batch_grams: purchases[i].gold_batch.grams,

      };
      content.push(purchase);
      i++;
    }
    $scope.pages = parseInt(headers().total_pages);
    $scope.count = content.length;
    return $scope.content = content;
  }).error(function(data, status, headers, config) {
    return $scope.infoAlert('ERROR', 'No se pudo realizar la solicitud');
  });

  $scope.infoAlert = function(title, content) {
    $mdDialog.show($mdDialog.alert().title(title).content(content).ok('OK'));
    // .finally(function() {
    //     $window.history.back();
    //   });
  };



  return $scope.show = function(item) {
    console.log('selecciona item' + item.selected);
    return InventoryService.setItem(item);
  };
});