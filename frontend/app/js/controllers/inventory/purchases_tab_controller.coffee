angular.module('app').controller 'PurchasesTabCtrl', ($scope, $mdDialog, PurchaseService, LiquidationService, $filter, $window, $state, ReportsService) ->
  # ------------ Table directive configuration ----------- //
  $scope.toggleSearch = false
  $scope.totalAmount = 0
  # $scope.report_url = null;

  #Headers of the table
  # TODO: made this process more simple, just create a table as people uses to do
  # to avoid the metaprogramming stuff bellow.
  $scope.headers = [
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
      field: 'purchase.gold_batch.fine_grams.toFixed(3)'
    }
    {
      name: 'Precio'
      field: 'purchase.price.toFixed(3)'
    }
    {
      name: 'Tipo de Mineral'
      field: 'purchase.gold_batch.mineral_type'
    }
    {
      name: 'Vendido'
      field: 'purchase.gold_batch.sold'
    }
    {
      name: 'Responsable'
      field: "purchase.performer.first_name + ' ' + purchase.performer.last_name"
    }
    {
      name: 'Estado'
      field: "purchase.transaction_state"
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
    $scope.purchases = purchases
  ).error (data, status, headers, config) ->
    $scope.infoAlert 'ERROR', 'No se pudo realizar la solicitud'

  $scope.infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return

    ##Checkboxes behavior #####

  $scope.selectedPurchases = []

  $scope.toggle = (purchase) ->
    selectedPurchaseId = $scope.selectedPurchases.indexOf(purchase);
    if ( selectedPurchaseId > -1)
      $scope.selectedPurchases.splice( selectedPurchaseId, 1)
      $scope.totalAmount -= purchase.gold_batch.grams
    else
      $scope.selectedPurchases.push(purchase)
      $scope.totalAmount += purchase.gold_batch.grams

  $scope.alreadySelected = (purchase) ->
    return $scope.selectedPurchases.indexOf(purchase) > -1

  $scope.liquidateSelectedPurchases = (ev) ->
        confirmLiquidate($scope.totalAmount, ev)

  confirmLiquidate = (total_grams,ev)->
      confirm = $mdDialog.confirm()
      .title('Confirmar')
      .content('Esta seguro de liquidar ' +total_grams + ' gramos?')
      .ariaLabel('Lucky day').ok('Confirmar').cancel('Cancelar')
      .targetEvent(ev)

      $mdDialog.show(confirm).then (->
        LiquidationService.model.selectedPurchases = $scope.selectedPurchases
        LiquidationService.model.totalAmount = $scope.totalAmount
        LiquidationService.model.ingotsNumber = 1
        LiquidationService.saveState()

        $state.go 'liquidate_inventory'
        return
      ), ->
        #If the response in negative sets the checkbox to true again
        return
      return

  $scope.showPurchase = (purchase)->
    PurchaseService.model = purchase
    PurchaseService.saveState()
    # TODO: create a generic way to reuse sale details view.
    #if purchase.type == 'purchase'
    $state.go('inventory.purchase_details')
    #else
    #  $state.go('inventory.sale_details')
    #return

  #-------------------Generate the Transaction Movements File -----------//
  $scope.generateReport = (purchase) ->
    ReportsService.generateTransactionMovements(purchase.id).success((data) ->
      purchase.report_url = data.base_file_url
      $scope.infoAlert 'Reporte Tributario', 'El archivo plano CSV se generó satisfactoriamente con los movimientos contables de la transacción'
    ).error (data) ->
      $scope.infoAlert 'ERROR', 'No se pudo generar y descargar el Archivo con los movimientos de la transacción'
    return