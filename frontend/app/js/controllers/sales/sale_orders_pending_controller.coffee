angular.module('app').controller 'SaleOrdersPendingCtrl', ($scope, PurchaseService, GoldBatchService, SaleService, $timeout, $q, $mdDialog, CurrentUser, $location,$state, $filter) ->
    # ------------ Table directive configuration ----------- //
  $scope.toggleSearch = false
  $scope.totalAmount = 0


  #*** Loading Variables **** #
  $scope.showLoading = false
  $scope.loadingMode = "indeterminate"
  $scope.loadingMessage = "Enviando..."

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

  SaleService.restoreModel()
  $scope.saleModel =  SaleService.model


  # console.log $scope.saleModel
  $scope.goSaleOrderResume = (saleId) ->
    SaleService.model = $filter('filter')($scope.sales, {id: saleId})[0]
    SaleService.saveModel()
    $state.go 'new_sale.resume_sale_pending'

  # ---------------- Controller methods -----------------//
  # Sale service call to api to retrieve all sales by the state  passed by argument for current user
  SaleService.getAllByState('dispatched').success((sales, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = sales.length
    $scope.sales = sales
  ).error (data, status, headers, config) ->
    $scope.infoAlert 'ERROR', 'No se pudo recuperar las ordenes de ventas pendientes'

  $scope.infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return

  CurrentUser.get().success (data) ->
    $scope.current_user = data
    #$scope.saleModel.use_wacom_device = data.use_wacom_device

