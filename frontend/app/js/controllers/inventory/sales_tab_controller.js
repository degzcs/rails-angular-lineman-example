angular.module('app').controller('SalesTabCtrl', function($scope, $mdDialog, SaleService, $state){

	$scope.toggleSearch = false;

	$scope.headers = [
    {
      name: 'Fecha',
      field: 'sale.created_at'
    }, {
      name: 'Comprador',
      field: "sale.buyer.first_name + ' ' + sale.buyer.last_name"
    }, {
      name: 'Total Gramos Finos',
      field: 'sale.fine_grams'
    }, {
      name: 'Precio venta',
      field: 'sale.price'
    }, {
      name: 'Precio compra',
      field: 'sale.purchases_total_value'
    },{
      name: 'Ganancia',
      field: 'sale.total_gain'
    }
  ];

  $scope.pages = 0;
  $scope.currentPage = 1;

  //---------------- Controller methods -----------------//
  //Sale service call to api to retrieve all sales for current user
  SaleService.all_paged().success(function(sales, status, headers, config) {
    $scope.pages = parseInt(headers().total_pages);
    $scope.count = sales.length;
    return $scope.sales = sales;
  }).error(function(data, status, headers, config) {
    return $scope.infoAlert('ERROR', 'No se pudo realizar la solicitud');
  });

  $scope.showSale = function(sale) {
    SaleService.model = sale;
    SaleService.saveState();
    $state.go('inventory.sale_details');
    };

  $scope.infoAlert = function(title, content) {
    $mdDialog.show($mdDialog.alert().title(title).content(content).ok('OK'));
  };

});