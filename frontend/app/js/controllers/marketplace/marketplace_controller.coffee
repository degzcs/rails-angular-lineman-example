angular.module('app').controller 'MarketplaceCtrl', ($scope, $mdDialog, SaleService, CurrentUser) ->
  # send a buyer request to a specific sale order

  CurrentUser.get().success (data) ->
    $scope.currentUser = data

  SaleService.getAllByState('published').success((sales, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = sales.length
    $scope.sales = sales
  ).error (data, status, headers, config) ->
    infoAlert 'ERROR', 'No se pudo recuperar las ordenes de ventas publicadas'

  $scope.sendRequest= (sale_id) ->
    confirm = $mdDialog.confirm()
                      .title('Desea realizar la petición de compra?')
                      .content('Va a ser generada una petición de compra. Esta seguro que desea realizarla?')
                      .ok('Si, deseo comprar')
                      .cancel('No, cancelar compra')
    $mdDialog.show(confirm).then (->
      doRequest(sale_id)
      return
    ), ->
      # process here
      return

  doRequest = (sale_id)->
    SaleService.buyRequest(sale_id, $scope.currentUser.id).success((sales, status, headers, config) ->
      infoAlert 'Feliciataiones', 'Se ha realizada con éxito la petición de compra'
    ).error (data, status, headers, config) ->
      infoAlert('ERROR', 'No se pudo realizar la petición de compra' + data.message)

  infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return