angular.module('app').controller 'ExternalUserTypeCtrl', ($scope, $state , $mdDialog , ExternalUser) ->
  
  $scope.answer =(answer)->
    console.log answer
    #ExternalUser.modelToCreate.external_user.user_type = answer
    ExternalUser.saveModelToCreate()
    if answer == 0
      $state.go 'create_external_user_type_a'
    else
      $state.go 'create_external_user_type_b'
    return $mdDialog.cancel()
    