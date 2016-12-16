angular.module('app').controller 'PurchaseOrdersApprovedCtrl', ($scope, PurchaseService, SaleService, $timeout, $q, $mdDialog, CurrentUser, $location,$state, $filter) ->
    # ------------ Table directive configuration ----------- //
  $scope.toggleSearch = false
  $scope.totalAmount = 0
  #Headers of the table
  # TODO: made this process more simple, just create a table as people uses to do
  # to avoid the metaprogramming stuff bellow.
  $scope.headers = [
    {
      name: 'Estado'
      field: 'purchase.transaction_state'
    }
    {
      name: 'Fecha'
      field: 'purchase.created_at'
    }
    {
      name: 'Vendedor'
      field: "purchase.seller.first_name + ' ' + purchase.seller.last_name"
    }
    {
      name: 'Gramos Finos'
      field: 'purchase.gold_batch.fine_grams'
    }
    {
      name: 'Precio'
      field: 'purchase.price'
    }
    {
      name: 'Tipo de Mineral'
      field: 'purchase.gold_batch.mineral_type'
    }
  ]

  # Variables configuration
  $scope.pages = 0
  $scope.currentPage = 1
  # wacom device
  $scope.chkAgreetmentActive = false

  #---------------- Controller methods -----------------//
  # purchase service call to api to retrieve all purchase by the state passed by argument for current user
  PurchaseService.getAllByState('approved').success((purchases, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = purchases.length
    $scope.purchases = purchases
  ).error (data, status, headers, config) ->
    $scope.infoAlert 'ERROR', 'No se pudo recuperar las ordenes de compra pendientes'

  $scope.infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return

  CurrentUser.get().success (data) ->
    $scope.current_user = data
    # $scope.saleService.use_wacom_device = data.use_wacom_device
    $scope.current_sale_id = null
