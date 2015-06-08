angular.module('app').controller 'ExternalUserTypeCtrl', ($scope, $state , $mdDialog , ExternalUser) ->
  ExternalUser.clearModelToCreate()
  $scope.answer =(answer)->
    console.log answer
    ExternalUser.modelToCreate.user_type = answer
    ExternalUser.saveModelToCreate()
    if answer == 'Barequero'
      $state.go 'create_external_user_type_a'
    else
      $state.go 'create_external_user_type_b'
    return $mdDialog.cancel()
  $scope.cancel = ->
    $mdDialog.cancel()