angular.module('app').controller 'DashboardCtrl', ($scope, $alert, $auth, CurrentUser, CreditBilling, $mdDialog, $log) ->
  #Get the current user logged!
  $scope.newCreditBilling = {}

  CurrentUser.get().success (data) ->
    $scope.currentUser = data

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

  $scope.submitCreditBilling = ->

    $scope.newCreditBilling = {
      user_id: $scope.currentUser.id
      unit: $scope.unit
    }

    CreditBilling.create($scope.newCreditBilling).success((data) ->
      $mdDialog.show $mdDialog.alert()
        .title('Felicitaciones!')
        .content('Sus creditos han sido solicitados satisfactoriamente, en momentos sera enviado el recibo de consignacion a su correo electronico')
        .ok('hecho!')
        duration: 2
      return
    ).error (data, status, headers, config) ->
      $mdDialog.show $mdDialog.alert()
        .title('EEROR')
        .content('No se pudo realizar la solicitud')
        .ok('hecho!')
        duration: 2
      return
