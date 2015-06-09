angular.module('app').controller 'ClientTypeCtrl', ($scope, $state , $mdDialog , ClientService) ->
  ClientService.clearModelToCreate()
  $scope.answer =(answer)->
    console.log answer
    ClientService.modelToCreate.user_type = answer
    ClientService.modelToCreate.activity = answer
    ClientService.saveModelToCreate()
    if answer == 'Comercializadores'
      $state.go 'create_external_user_type_b'
    else
      $state.go 'create_client_no_rucom'
    return $mdDialog.cancel()
  $scope.cancel = ->
    $mdDialog.cancel()