angular.module('app').controller 'SaleOrdersMarketplaceCtrl', ($scope, $state, SaleService) ->
  #Headers of the table
  # TODO: made this process more simple, just create a table as people uses to do
  # to avoid the metaprogramming stuff bellow.
  $scope.headers = [
    {
      name: 'Estado'
      field: 'sale.transaction_state'
    }
    {
      name: 'Fecha'
      field: 'sale.created_at'
    }
    {
      name: 'Comprador'
      field: "sale.buyer.first_name + ' ' + sale.buyer.last_name"
    }
    {
      name: 'Gramos Finos'
      field: 'sale.fine_grams.toFixed(3)'
    }
    {
      name: 'Precio'
      field: 'sale.price'
    }
    {
      name: 'Tipo de Mineral'
      field: 'sale.mineral_type'
    }
  ]

  SaleService.getAllByState('published').success((sales, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = sales.length
    $scope.sales = sales
  ).error (data, status, headers, config) ->
    $scope.infoAlert 'ERROR', 'No se pudo recuperar las ordenes de ventas publicadas en el Marketplace'

  $scope.goSaleOrderResume = (saleId) ->
    $state.go('new_sale.order_marketplace', {id: saleId})
