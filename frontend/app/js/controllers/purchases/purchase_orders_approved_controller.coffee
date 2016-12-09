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
      field: 'sale.fine_grams'
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

  #Variables configuration
  $scope.pages = 0
  $scope.currentPage = 1
# wacom device
  $scope.chkAgreetmentActive = false
  $scope.saleService =  SaleService.model


  #---------------- Controller methods -----------------//
  #Sale service call to api to retrieve all sales by the state  passed by argument for current user
  SaleService.getAllByStateAsBuyer('approved').success((sales, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = sales.length
    $scope.sales = sales
  ).error (data, status, headers, config) ->
    $scope.infoAlert 'ERROR', 'No se pudo recuperar las ordenes de compra pendientes'

  $scope.infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return

  CurrentUser.get().success (data) ->
    $scope.current_user = data
    #$scope.saleService.use_wacom_device = data.use_wacom_device
    $scope.current_sale_id = null 
