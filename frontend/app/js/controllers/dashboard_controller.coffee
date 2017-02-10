angular.module('app').controller 'DashboardCtrl', ($scope, $alert, $auth, CurrentUser, CreditBilling, $mdDialog, $log, $filter) ->
  #*** Loading Variables **** #
  $scope.showLoading = true
  $scope.loadingMode = "indeterminate"
  $scope.loadingMessage = "Cargando datos personales ..."
  # Get the current user logged!

  $scope.newCreditBilling = {}
  $scope.quantity = null
  $scope.available_credits = null
  CurrentUser.get().success (data) ->
    $scope.currentUser = data
    $scope.available_credits = Number(data.available_credits.toFixed(2))
    $scope.unit_price = data.unit_price # TODO: temporal fix.
    $scope.showLoading = false

  # Shows a form that allows to the user choose an amount of credits
  $scope.showCreditBillingForm = (ev) ->
    $mdDialog.show(
      controller: "DashboardCtrl"
      templateUrl: 'partials/credit_billing_form.html'
      targetEvent: ev).then ((answer) ->
      $scope.alert = 'You said the information was "' + answer + '".'
      return
    ), ->
      $scope.alert = 'You cancelled the dialog.'
      return
    return

  # Ask if the ammount chosen was correct and prevents an empty value
  $scope.confirmCreditBilling = ->
    if($scope.quantity != null && $scope.unit_price != null)
      price = $scope.quantity * $scope.unit_price
      formatted_quantity = $filter('number')($scope.quantity, 0)
      formatted_price = $filter('currency')(price, '$', 2)
      confirm = $mdDialog.confirm()
        .title('Confirmacion solicitud de creditos')
        .content("Esta seguro de comprar #{formatted_quantity} por un total de #{formatted_price} COP")
        .ariaLabel('Lucky day').ok('Solicitar Factura').cancel('Cancelar')

      $mdDialog.show(confirm).then (->
        $scope.submitCreditBilling()
        return
      ), ->
        $scope.alert = 'None value chosen.'
        return

    else
      $scope.infoAlert('Hubo un problema',"No selecciono una cantidad de creditos")

  # Submit the credit billing and if it gets saved shows a dialog alert
  $scope.submitCreditBilling = ->
    $scope.newCreditBilling = {
      user_id: $scope.currentUser.id
      quantity: $scope.quantity
    }

    CreditBilling.create($scope.newCreditBilling).success((data) ->
      $scope.infoAlert('Felicitaciones!', 'Sus creditos han sido solicitados satisfactoriamente, en momentos sera enviado el recibo de consignacion a su correo electronico')
    ).error (data, status, headers, config) ->
      $scope.infoAlert('EEROR', 'No se pudo realizar la solicitud')


  #Dialgo alert helper
  $scope.infoAlert = (title,content)->
    $mdDialog.show $mdDialog.alert()
      .title(title)
      .content(content)
      .ok('hecho!')
      duration: 2
    return

  $scope.cancel = ->
    $mdDialog.cancel()
