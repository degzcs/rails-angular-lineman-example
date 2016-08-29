 // 	 id: null
 //      courier_id: null
 //      buyer_id: null
 //      user_id: null
 //      gold_batch_id: null
 //      code: null
 //      price: null
 //      purchase_files_collection: null
 //      proof_of_sale: null
 //      barcode_html: null
 //      selectedPurchases: null #=>  example: {[purchase_id: 1,amount_picked: 2.3]}
 //      totalAmount: null

// seller_name --> no sale, tener en cuenta...

 // atributos index inventory sales:
 // fecha
 // gramos finos
 // proveedor
 // ganancia (utilidad por gramos) (preocio final - precio inicial)/ cantd. de gramos
 // 

angular.module('app').controller('InventorySaleIndexCtrl', function($scope, $mdDialog, SaleService){

	$scope.toggleSearch = false;

	$scope.headers = [
    {
      name: 'Fecha',
      field: 'created_at'
    }, {
      name: 'ID venta',
      field: 'id'
    }, {
      name: 'Cliente',
      field: 'buyer_name'
    }, {
      name: 'Total Gramos Finos',
      field: 'fine_grams'
    }, {
      name: 'Precio venta',
      field: 'price'
    }, {
      name: 'Precio compra',
      field: 'purchases_total_value'
    },{
      name: 'Ganancia',
      field: 'total_gain'
    }
  ];
    //Filters
  $scope.sortable = ['created_at','seller_name', 'gold_batch_grams', 'price', 'purchases_total_value', 'total_gain', 'inventory_remaining_amount'];
  //Variables configuration
  $scope.selectall = false;
  $scope.grams = {
    value: 0
  };
  //Header Styles
  $scope.custom = {
    seller_name: 'grey',
    id: 'bold',
    gold_batch_grams: 'grey',
    price: 'grey',
    created_at: 'bold',
    purchases_total_value: 'grey',
    total_gain: 'bold',
    inventory_remaining_amount: 'bold',
  };

  $scope.pages = 0;
  $scope.currentPage = 1;

  //---------------- Controller methods -----------------//
  //Sale service call to api to retrieve all sales for current user
  SaleService.all_paged().success(function(sales, status, headers, config) {
    var content, i, sale;
    content = [];
    i = 0;
    while (i < sales.length) {
      sale = {
        // Default sale entity parameters
        id: sales[i].id,
        courier_id: sales[i].courier_id,
        buyer_id: sales[i].buyer_id,
        user_id: sales[i].user_id,
        buyer_name: sales[i].buyer.first_name + " " + sales[i].buyer.last_name,
        price: sales[i].price,
        fine_grams: sales[i].fine_grams,
        //purchase_files_collection: sales[i].purchase_files_collection,
        //proof_of_sale: sales[i].proof_of_sale,
        purchases_total_value: sales[i].purchases_total_value,
        total_gain: sales[i].total_gain,
        //origin_certificate_file: sales[i].origin_certificate_file,
        //seller_picture: sales[i].seller_picture,
        //origin_certificate_sequence: sales[i].origin_certificate_sequence,
        created_at: sales[i].created_at,
        //reference_code: sales[i].reference_code,
        access_token: sales[i].access_token,
        seller: sales[i].seller,
        gold_batch_id: sales[i].gold_batch_id,
        //inventory: sales[i].inventory,
        //trazoro:  sales[i].trazoro,
        barcode_html: sales[i].barcode_html,
        code: sales[i].code,
        // Aditional table paramters
        //seller_name: sales[i].seller.first_name + " " + sales[i].seller.last_name,
        //inventory_remaining_amount: sales[i].inventory.remaining_amount,
        gold_batch: sales[i].gold_batch,

      };
      content.push(sale);
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