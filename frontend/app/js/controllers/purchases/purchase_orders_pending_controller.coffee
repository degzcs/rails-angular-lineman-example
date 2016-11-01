angular.module('app').controller 'PurchaseOrdersPendingCtrl', ($scope, PurchaseService, GoldBatchService,  SaleService, $timeout, $q, $mdDialog, CurrentUser, $location,$state, $filter) ->
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
      name: 'Id'
      field: 'sale.id'
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
# wacom device
  $scope.chkAgreetmentActive = false
  $scope.saleService = SaleService.restoreModel()
  

  #---------------- Controller methods -----------------//
  #Sale service call to api to retrieve all sales by the state  passed by argument for current user
  SaleService.get_all_by_state('dispatched').success((sales, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = sales.length
    $scope.sales = sales
    console.log 'sales: '
    console.log sales
  ).error (data, status, headers, config) ->
    console.log 'error en get_all_by_state'
    console.log data
    $scope.infoAlert 'ERROR', 'No se pudo recuperar las ordenes de compra pendientes'

  $scope.infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return

  CurrentUser.get().success (data) ->
    console.log 'currentUser data:'
    console.log data
    $scope.current_user = data
    $scope.saleService.use_wacom_device = data.use_wacom_device
    $scope.current_sale_id = null 


# when click the button to see the buy agreetment
  $scope.agreetment = (sale_id)->
    console.log 'sale_id = ' + sale_id
    $scope.current_sale_id = sale_id
    SaleService.model.id = sale_id
    console.log 'ingresa a buy_agreetment'
    SaleService.buy_agreetment().success( (data) ->
      $scope.saleService.fixed_sale_agreetment = data.fixed_sale_agreetment
      SaleService.model.fixed_sale_agreetment = data.fixed_sale_agreetment
      console.log 'fixed_sale_agreetment data:'
      console.log data

      SaleService.saveModel()
      console.log 'SaleService.model.id:'
      console.log SaleService.model.id
      $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Consulta Exitosa').content('Productor si se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
      $state.go 'new_purchase.orders_pending_agreetment', { id: SaleService.model.id }
    )
    .error((error)->
      $scope.showLoading = false
      $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content(error.detail).ariaLabel('Alert Dialog ').ok('ok')
    )  

  $scope.handlerContinue = ->
    res = if $scope.chkAgreetmentActive == true then true else false
    return res

  $scope.handlerReject = ->
    res = if $scope.chkAgreetmentActive == true then true else false
    return res

  $scope.agreeOrCancel = (transition)->
    console.log 'transition: '
    console.log transition
    console.log 'sale id:'
    console.log $scope.saleService.id
    SaleService.trigger_transition($scope.saleService.id, transition).success( (data) ->
      console.log 'sale transaction_state:'
      console.log  data
      $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Orden Actualizada Exitosamente!').content('Productor si se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
    )
    .error((error)->
      $scope.showLoading = false
      $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content(error.detail).ariaLabel('Alert Dialog ').ok('ok')
    )