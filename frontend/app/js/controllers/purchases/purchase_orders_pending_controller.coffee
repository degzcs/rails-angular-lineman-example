angular.module('app').controller 'PurchaseOrdersPendingCtrl', ($scope, PurchaseService, GoldBatchService, SaleService, $timeout, $q, $mdDialog, CurrentUser, $location,$state, $filter) ->
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
      field: 'purchase.transaction_state'
    }
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
      field: 'purchase.gold_batch.fine_grams'
    }
    {
      name: 'Precio'
      field: 'purchase.price'
    }
    {
      name: 'Tipo de Mineral'
      field: 'purchase.gold_batch.mineral_type'
    }
  ]

  # Variables configuration
  $scope.pages = 0
  $scope.currentPage = 1
  # wacom device
  $scope.chkAgreetmentActive = false

  #PurchaseService.restoreModel() # TODO: separe this controller for each view
  $scope.purchaseModel = PurchaseService.model

  # console.log $scope.purchaseModel
  $scope.goPurchaseOrder = (purchaseId) ->
    PurchaseService.model = $filter('filter')($scope.purchases, {id: purchaseId})[0]
    PurchaseService.saveState()
    $state.go 'new_purchase.orders_details_agreetment'

  # ---------------- Controller methods -----------------//
  # purchase service call to api to retrieve all purchases by the state  passed by argument for current user
  PurchaseService.getAllByState('dispatched').success((purchases, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = purchases.length
    $scope.purchases = purchases
  ).error (data, status, headers, config) ->
    $scope.infoAlert 'ERROR', 'No se pudo recuperar las ordenes de compra pendientes'

  $scope.infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return

  CurrentUser.get().success (data) ->
    $scope.current_user = data
    #$scope.purchaseModel.use_wacom_device = data.use_wacom_device
    $scope.current_purchase_id = null

  $scope.handlerContinue = ->
    res = if $scope.chkAgreetmentActive == true then false else true
    return res

  $scope.handlerReject = ->
    res = if $scope.chkAgreetmentActive == true then true else false
    return res

  $scope.agreeOrCancel = (transition)->
    if transition == 'cancel!' || 'agree!'
      if can_exec_transition()
        if transition == 'cancel!'
          confirm = $mdDialog.confirm().parent(angular.element(document.body)).title('Operación de Cuidado, no tiene reversa!').content('Está seguro que desea realmente Rechazar su orden de Compra?').ariaLabel('Alert Dialog ').ok('Si').cancel('No')
          $mdDialog.show(confirm).then (->
            exec_transition(transition, 'new_purchase.purchase_home')
            #'new_purchase.orders_approved'
          ), ->
            #console.log 'You decided don\'t change the order state to canceled.'
            return
        else
          exec_transition(transition, 'new_purchase.purchase_home')
      else
        $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Alerta!').content('Su Orden ya se encuentra Actualizada!').ariaLabel('Alert Dialog ').ok('ok')
#
# This funtion executes the method to call the purchase end-point called transition trought the SaleService
#
  exec_transition = (transition_name, viewToGo)->
    $scope.showLoading = true
    SaleService.trigger_transition($scope.purchaseModel.id, transition_name).success( (data) ->
      $scope.showLoading = false
      $scope.purchaseModel.transaction_state = data.transaction_state
      $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Ejecución exitosa!').content('Orden Actualizada Exitosamente!').ariaLabel('Alert Dialog ').ok('ok')
      $state.go viewToGo
    )
    .error((error)->
      $scope.showLoading = false
      $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content(error.detail).ariaLabel('Alert Dialog ').ok('ok')
    )

  can_exec_transition = ->
    if  $scope.purchaseModel.transaction_state == 'canceled' || $scope.purchaseModel.transaction_state == 'approved'
      return false
    else
      return true