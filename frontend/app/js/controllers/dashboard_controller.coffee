angular.module('app').controller 'DashboardCtrl', ($scope, $alert, $auth, CurrentUser, CreditBilling, $mdDialog, $log) ->
  
  # Get the current user logged!
  
  $scope.newCreditBilling = {}
  $scope.unit = null
  CurrentUser.get().success (data) ->
    $scope.currentUser = data
    console.log "Current user"
    console.log data

  
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
    if($scope.unit != null)
      confirm = $mdDialog.confirm()
        .title('Confirmacion solicitud de creditos')
        .content("Esta seguro de comprar #{$scope.unit} por un total de #{$scope.unit*500} pesos")
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
      unit: $scope.unit
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
