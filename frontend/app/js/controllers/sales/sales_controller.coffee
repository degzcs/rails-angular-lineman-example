angular.module('app').controller 'SalesCtrl', ($scope, SaleService, GoldBatchService, CameraService, MeasureConverterService, $timeout, $q, $mdDialog, CurrentUser, ScannerService, $location,$state, $filter, AuthorizedProviderService, SignatureService, PurchaseService) ->
  
  #
  # Instances
  #
  $scope.sale = SaleService
  $scope.chkAgreetmentActive = false


# -----------------Step1 ----------------------------------
 # Returns the Fixed Sale Agreetmen from Settings instance
  SaleService.getFixedSaleAgreetment().success ((data)->
    console.log 'OK getFixedSaleAgreetment'
    $scope.sale.model.fixed_sale_agreetment = data.fixed_sale_agreetment
  ), (error) ->
    console.log('Error al tratar de Obtener el texto de fijación del Acuerdo')
 
 # Monitoring the Agreetment check
  $scope.handlerContinue =  ->
    console.log $scope.chkAgreetmentActive
    res = if $scope.chkAgreetmentActive == true then true else false
    console.log 'res: ' + res
    return res
# --------------End Step1 ---------------------------------

# ---------------- Step2 ----------------------------------
  $scope.toggleSearch = false
  $scope.totalAmount = 0 
  #Headers of the table
  # TODO: made this process more simple, just create a table as people uses to do
  # to avoid the metaprogramming stuff bellow.
  $scope.headers = [
    {
      name: 'Estado'
      field: 'purchase.gold_batch.sold'
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
      field: 'purchase.gold_batch.grams'
    }
    {
      name: 'Precio'
      field: 'purchase.price'
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
# ------------End Step2 -------------------------------------