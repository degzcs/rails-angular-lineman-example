angular.module('app').controller 'SaleOrderMarketplaceCtrl', ($scope, $mdDialog, $state, SaleService, $stateParams) ->

  SaleService.get($stateParams.id).success((sale, status, headers, config) ->
    $scope.sale = sale
    $scope.buyersCount = sale.buyers.length
  ).error (data, status, headers, config) ->
    infoAlert 'ERROR', 'No se pudo recuperar la venta'

  $scope.acceptRequest = (buyer)->
    confirm = $mdDialog.confirm().title('Operación de Cuidado, no tiene reversa!').content('Está seguro que desea ACEPTAR esta petición de compra?').ok('Si').cancel('No')
    $mdDialog.show(confirm).then (->
      SaleService.acceptBuyer($scope.sale.id, buyer.id).success( (sale) ->
        $scope.sale = sale
        $mdDialog.show $mdDialog.alert().title('Ejecución exitosa!').content('La orden de venta ha sido aceptada exitosamente!').ok('ok')
        $state.go 'new_sale.tab.orders_marketplace'
      )
      .error((error)->
        $mdDialog.show $mdDialog.alert().title('Húbo un problema').content(error.detail).ok('ok')
      )
    ), ->
      # cacel accion process

  $scope.rejectRequest = (buyer)->
    confirm = $mdDialog.confirm().title('Operación de Cuidado, no tiene reversa!').content('Está seguro que desea RECHAZAR esta petición de compra?').ok('Si').cancel('No')
    $mdDialog.show(confirm).then (->
      SaleService.rejectBuyer($scope.sale.id, buyer.id).success( (sale) ->
        $scope.sale = sale
        $mdDialog.show $mdDialog.alert().title('Ejecución exitosa!').content('La orden de venta ha sido rechazada exitosamente!').ok('ok')
        $state.go 'new_sale.tab.orders_marketplace'
      )
      .error((error)->
        $mdDialog.show $mdDialog.alert().title('Húbo un problema').content(error.detail).ok('ok')
      )
    ), ->
      # cacel accion process


  infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return
