angular.module('app').controller 'PurchasesTabCtrl', ($scope, $mdDialog, PurchaseService, LiquidationService, $filter, $window, $state, ReportsService) ->
  # ------------ Table directive configuration ----------- //
  $scope.toggleSearch = false
  $scope.totalAmount = 0

  #Variables configuration
  $scope.selected = [];
  $scope.query = {
    order: 'created_at',
    limit: 10,
    page: 1
  }
  #---------------- Controller methods -----------------//
  #Purchase service call to api to retrieve all purchases for current user

  $scope.getPurchases = ->
    response = PurchaseService.all().success((purchases, status, headers, config) ->
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
