
angular.module('app').controller 'SalesCtrl', ($scope, SaleService, GoldBatchService, CameraService, MeasureConverterService, $timeout, $q, $mdDialog, CurrentUser, $location,$state, $filter, AuthorizedProviderService, SignatureService, PurchaseService, LiquidationService) ->
  
  #
  # Instances
  #
  $scope.sale = SaleService
  $scope.chkAgreetmentActive = false

  $scope.toggleSearch = false
  $scope.totalAmount = 0
  #Variables configuration
  $scope.pages = 0
  $scope.currentPage = 1
  $scope.count = 0

# -----------------Step1 ----------------------------------

 # Returns the Fixed Sale Agreetmen from Settings instance
  SaleService.getFixedSaleAgreetment().success ((data)->
    console.log 'OK getFixedSaleAgreetment'
    $scope.sale.model.fixed_sale_agreetment = data.fixed_sale_agreetment
  ), (error) ->
    console.log('Error al tratar de Obtener el texto de fijación del Acuerdo')
 
 # Monitoring the Agreetment check
  $scope.handlerContinue =  ->
    # console.log $scope.chkAgreetmentActive
    res = if $scope.chkAgreetmentActive == true then true else false
    # console.log 'res: ' + res
    return res
# --------------End Step1 ---------------------------------

# ---------------- Step2 ----------------------------------
  # Filter the purchase with state equal to Disponible to be sale
  $scope.purchaseFreeFilter = (purchase) ->
    return  purchase.state == 'Disponible'

  #Headers of the table
  # TODO: made this process more simple, just create a table as people uses to do
  # to avoid the metaprogramming stuff bellow.
  $scope.headers = [
    #{
    #  name: 'Estado'
    #  field: 'purchase.gold_batch.sold'
    #}
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

  #---------------- Controller methods -----------------//
  # Purchase service call to api to retrieve all Free purchases for current user
  PurchaseService.all_free().success((purchases, status, headers, config) ->
    $scope.pages = parseInt(headers().total_pages)
    $scope.count = purchases.length
    $scope.purchases = purchases
  ).error (data, status, headers, config) ->
    console.log 'error: ' + data
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
    if total_grams <= 0
      message = 'Debe seleccionar primero algún Bloque de Oro'
      confirm = $mdDialog.alert()
      .title('Alerta')
      .content(message)
      .ariaLabel('Lucky day').ok('cerrar')
      .targetEvent(ev)
      $mdDialog.show(confirm)
    else
      message = 'Esta seguro de liquidar ' +total_grams.toFixed(3) + ' gramos?'
      confirm = $mdDialog.confirm()
      .title('Confirmar')
      .content(message)
      .ariaLabel('Lucky day').ok('Confirmar').cancel('Cancelar')
      .targetEvent(ev)
      $mdDialog.show(confirm).then (->
        LiquidationService.model.selectedPurchases = $scope.selectedPurchases
        LiquidationService.model.totalAmount = $scope.totalAmount
        LiquidationService.model.ingotsNumber = 1
        LiquidationService.saveState()

        $state.go 'new_sale.step3'
        return
      ), ->
        #If the response in negative sets the checkbox to true again
        return
      return

# ------------End Step2 -------------------------------------