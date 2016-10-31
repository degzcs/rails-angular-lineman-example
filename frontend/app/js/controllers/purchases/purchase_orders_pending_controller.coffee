angular.module('app').controller 'PurchaseOrdersPendingCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, MeasureConverterService, SaleService, $timeout, $q, $mdDialog, CurrentUser, ScannerService, $location,$state, $filter, AuthorizedProviderService, SignatureService) ->
    # ------------ Table directive configuration ----------- //
  $scope.toggleSearch = false
  $scope.totalAmount = 0 
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
      name: 'Vendedor'
      field: "sale.seller.first_name + ' ' + sale.seller.last_name"
    }
    {
      name: 'Gramos Finos'
      field: 'sale.gold_batch.grams'
    }
    {
      name: 'Precio'
      field: 'sale.price'
    }
  ] 

  #Variables configuration
  $scope.pages = 0
  $scope.currentPage = 1
  #---------------- Controller methods -----------------//
  #Purchase service call to api to retrieve all purchases for current user
  PurchaseService.all().success((purchases, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = purchases.length
    $scope.sales = purchases
  ).error (data, status, headers, config) ->
    $scope.infoAlert 'ERROR', 'No se pudo realizar la solicitud'

  $scope.infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return