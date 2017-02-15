angular.module('app').controller 'PurchasesTabCtrl', ($scope, $mdDialog, PurchaseService, $filter, $window, $state, ReportsService) ->
  # ------------ Table directive configuration ----------- //
  $scope.toggleSearch = false
  $scope.totalAmount = 0

  #Variables configuration
  $scope.selected = [];
  $scope.query = {
    order: 'created_at',
    limit: 5,
    page: 1
  }

  $scope.getPurchases = (page)->
    response = PurchaseService.all($scope.query).success((purchases, status, headers, config) ->
      $scope.pages = parseInt(headers().total_pages)
      $scope.count = purchases.length
      $scope.purchases = purchases
    ).error (data, status, headers, config) ->
      $scope.infoAlert 'ERROR', 'No se pudo realizar la solicitud'
    return response.$promise

  $scope.getPurchases()

  $scope.infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return

  $scope.showPurchase = (purchase)->
    if purchase.type == 'purchase'
      $state.go('inventory.purchase_details', {id: purchase.id})
    else
      $state.go('inventory.purchase_from_trader_details', {id: purchase.id})
    return

  #-------------------Generate the Transaction Movements File -----------//
  $scope.generateReport = (purchase) ->
    ReportsService.generateTransactionMovements(purchase.id).success((data) ->
      purchase.report_url = data.base_file_url
      $scope.infoAlert 'Reporte Tributario', 'El archivo plano CSV se generó satisfactoriamente con los movimientos contables de la transacción'
    ).error (data) ->
      $scope.infoAlert 'ERROR', 'No se pudo generar y descargar el Archivo con los movimientos de la transacción'
    return
