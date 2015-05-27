angular.module('app').controller 'ExternalUserTypeCtrl', ($scope, $state , $mdDialog , ExternalUser) ->
  
  $scope.answer =(answer)->
    console.log answer
    if answer == 0
      $state.go 'create_external_user_type_1'
    else
      $state.go 'create_external_user_type_2'
    return $mdDialog.cancel()
    