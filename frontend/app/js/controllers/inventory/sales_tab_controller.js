angular.module('app').controller('SalesTabCtrl', function($scope, $mdDialog, SaleService, $state, ReportsService){

	$scope.toggleSearch = false;
  //$scope.report_url = null;

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
    },{
      name: 'Tipo de Mineral',
      field: 'sale.mineral_type'
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
    return infoAlert('ERROR', 'No se pudo realizar la solicitud');
  });

  $scope.showSale = function(sale) {
    SaleService.model = sale;
    SaleService.saveState();
    $state.go('inventory.sale_details');
    };

  $scope.infoAlert = function(title, content) {
    $mdDialog.show($mdDialog.alert().title(title).content(content).ok('OK'));
  };
  
  $scope.generateReport = function(sale) {
    ReportsService.generateTransactionMovements(sale.id).success(function(data) {
      sale.report_url = data.base_file_url;
      return $scope.infoAlert('El archivo plano CSV se generó satisfactoriamente con los movimientos contables de la transacción');
    }).error(function(data) {
      return $scope.infoAlert('ERROR', 'No se pudo generar y descargar el Archivo con los movimientos de la transacción');
    });
  };


});