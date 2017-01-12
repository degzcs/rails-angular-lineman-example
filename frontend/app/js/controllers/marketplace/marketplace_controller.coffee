angular.module('app').controller 'MarketplaceCtrl', ($scope, SaleService) ->
  # get sale orders with status 'published'
  # send a buyer request to a specific sale order

  SaleService.getAllByState('published').success((sales, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = sales.length
    $scope.sales = sales
  ).error (data, status, headers, config) ->
    $scope.infoAlert 'ERROR', 'No se pudo recuperar las ordenes de ventas publicadas'