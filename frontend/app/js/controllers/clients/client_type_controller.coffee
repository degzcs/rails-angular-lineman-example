angular.module('app').controller 'ClientTypeCtrl', ($scope, $state , $mdDialog , ClientService, ExternalUser) ->
  $scope.answer =(answer)->
    console.log answer
    if answer == 'Comercializadores'
      ExternalUser.clearModelToCreate()
      ExternalUser.modelToCreate.user_type = answer
      ExternalUser.saveModelToCreate()
      $state.go 'create_external_user_type_b'
    else
      ClientService.clearModelToCreate()
      ClientService.modelToCreate.user_type = answer
      ClientService.modelToCreate.activity = answer
      ClientService.saveModelToCreate()
      $state.go 'create_client_no_rucom'
    return $mdDialog.cancel()
  $scope.cancel = ->
    $mdDialog.cancel()