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

angular.module('app').controller('InventorySaleIndexCtrl', function($scope, $mdDialog, SaleService, $state){

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
    total_gain: 'grey',
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
        buyer_id: sales[i].buyer.id,
        user_id: sales[i].user_id,
        buyer_name: sales[i].buyer.first_name + " " + sales[i].buyer.last_name,
        price: sales[i].price,
        totalAmount: sales[i].fine_grams,
        associatedPurchases: sales[i].associated_purchases,
        purchase_files_collection: sales[i].purchase_files_collection,
        proof_of_sale: sales[i].proof_of_sale,
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

  // SaleService.create(sale_params,gold_batch_params,$scope.selectedPurchases).success((sale) ->
  //       $scope.infoAlert('Felicitaciones!', 'La venta ha sido realizada')
  //       $mdDialog.cancel dialog
  //       SaleService.model.id = sale.id
  //       SaleService.model.courier_id = sale.courier_id
  //       SaleService.model.buyer_id = sale.buyer_id
  //       SaleService.model.user_id = sale.user_id
  //       SaleService.model.gold_batch_id = sale.gold_batch_id
  //       SaleService.model.fine_grams = sale.fine_grams
  //       SaleService.model.code = sale.code
  //       SaleService.model.barcode_html = sale.barcode_html
  //       SaleService.model.selectedPurchases = $scope.selectedPurchases
  //       SaleService.model.totalAmount = $scope.totalAmount
  //       SaleService.model.price = sale.price
  //       SaleService.model.purchase_files_collection = sale.purchase_files_collection
  //       SaleService.model.proof_of_sale = sale.proof_of_sale
  //       SaleService.saveState()
  //       $state.go('show_sale')
  //     ).error (data, status, headers, config) ->
  //       $scope.infoAlert('EEROR', 'No se pudo realizar la solicitud')

  $scope.showInventorySale = function(item) {
    SaleService.model.id = item.id;
    SaleService.model.courier_id = item.courier_id
    SaleService.model.buyer_id = item.buyer_id
    SaleService.model.user_id = item.user_id
    SaleService.model.associatedPurchases = item.associatedPurchases
    SaleService.model.gold_batch_id = item.gold_batch_id
    //SaleService.model.fine_grams = item.fine_grams
    SaleService.model.code = item.code
    SaleService.model.barcode_html = item.barcode_html
    SaleService.model.selectedPurchases = item.selectedPurchase
    SaleService.model.totalAmount = item.totalAmount
    SaleService.model.gold_batch = item.gold_batch
    SaleService.model.price = item.price //no secure
    SaleService.model.purchase_files_collection = item.purchase_files_collection
    SaleService.model.proof_of_sale = item.proof_of_sale;
    SaleService.saveState();    
    $state.go('show_inventory_sale');
    };
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