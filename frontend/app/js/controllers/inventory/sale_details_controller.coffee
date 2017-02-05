angular.module('app').controller 'SaleDetailsCtrl', ($scope, SaleService, $mdDialog, User, $sce, $stateParams, LiquidationService) ->
  #
  # Deletes the last liquidation
  LiquidationService.deleteState()

  SaleService.get($stateParams.id).success((order, status, headers, config) ->
    $scope.order = order
    $scope.barcodeHtml = $sce.trustAsHtml($scope.order.barcode_html)
    getBuyer($scope.order.buyer.id)
    getSeller($scope.order.seller.id)

  ).error (data, status, headers, config) ->
    infoAlert 'ERROR', 'No se pudo recuperar la orden: ' + data.error

  $scope.markAsPaid = ->
    confirm = $mdDialog.confirm().parent(angular.element(document.body)).title('Operación de Cuidado, no tiene reversa!').content('Está seguro que desea MARCAR COMO PAGADA su orden?').ariaLabel('Alert Dialog ').ok('Si').cancel('No')
    $mdDialog.show(confirm).then (->
      SaleService.trigger_transition($scope.order.id, 'end_transaction!').success( (sale) ->
        $scope.order = sale
        $mdDialog.show $mdDialog.alert().title('Ejecución exitosa!').content('La orden ha sido marcada como pagada exitosamente!').ok('ok')
        $state.go 'inventory.sales'
      )
      .error((error)->
        $scope.showLoading = false
        $mdDialog.show $mdDialog.alert().title('Hubo un problema').content(error.detail).ok('ok')
      )
    ), ->
      # cancel process
      return

  getBuyer = (buyerId) ->
    User.get(buyerId).success (buyer)->
      $scope.buyer = buyer

  getSeller = (sellerId)->
    User.get(sellerId).success (seller)->
      $scope.seller = seller

  infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return
