angular.module('app').controller 'MarketplaceCtrl', ($scope, $mdDialog, SaleService, CurrentUser) ->
  # send a buyer request to a specific sale order

  CurrentUser.get().success (data) ->
    $scope.currentUser = data

  SaleService.getAllByState('published').success((sales, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = sales.length
    $scope.sales = sales
    markSalesAsRequested(null, null)
  ).error (data, status, headers, config) ->
    infoAlert 'ERROR', 'No se pudo recuperar las ordenes de ventas publicadas'

  $scope.sendRequest= (sale) ->
    confirm = $mdDialog.confirm()
                      .title('Desea realizar la petición de compra?')
                      .content('Va a ser generada una petición de compra. Esta seguro que desea realizarla?')
                      .ok('Si, deseo comprar')
                      .cancel('No, cancelar compra')
    $mdDialog.show(confirm).then (->
      doRequest(sale)
      return
    ), ->
      # process here
      return

  markSalesAsRequested = (selectedSale, buyerId)->
    if buyerId
      for sale in $scope.sales when selectedSale.id is sale.id
       sale.alreadyRequested = true
    else
      for sale in $scope.sales
        for buyerId in sale.buyer_ids when buyerId is $scope.currentUser.id
          sale.alreadyRequested = true
    return

  doRequest = (sale)->
    SaleService.buyRequest(sale.id).success((sale, status, headers, config) ->
      infoAlert 'Feliciataiones', 'Se ha realizada con éxito la petición de compra'
      markSalesAsRequested(sale, $scope.currentUser.id)
    ).error (data, status, headers, config) ->
      infoAlert('ERROR', 'No se pudo realizar la petición de compra: ' + data.details)

  infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return