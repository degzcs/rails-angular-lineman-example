angular.module('app').controller 'SaleDetailsCtrl', ($scope, SaleService, GoldBatchService, $mdDialog, CurrentUser, LiquidationService, User, CourierService, PurchaseService, $sce) ->
  #
  # Deletes the last liquidation
  LiquidationService.deleteState()

  #
  #
  #Get info
  $scope.currentSale = SaleService.restoreState()
  $scope.barcode_html = $sce.trustAsHtml($scope.currentSale.barcode_html)
  $scope.currentBuyer = null
  $scope.currentUser = null
  $scope.currentCourier = null

  #
  # get Client (buyer)
  User.get($scope.currentSale.buyer.id).success (buyer)->
    $scope.currentBuyer = buyer

  #
  # get current user info
  CurrentUser.get().success (user) ->
    $scope.currentUser = user
  #
  # get Courier
  CourierService.retrieveCourierById($scope.currentSale.courier_id).success (courier)->
    $scope.currentCourier = courier

  $scope.markAsPaid = ->
    confirm = $mdDialog.confirm().parent(angular.element(document.body)).title('Operación de Cuidado, no tiene reversa!').content('Está seguro que desea MARCAR COMO PAGADA su orden?').ariaLabel('Alert Dialog ').ok('Si').cancel('No')
    $mdDialog.show(confirm).then (->
      SaleService.trigger_transition($scope.currentSale.id, 'end_transaction!').success( (sale) ->
        $scope.currentSale = sale
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
