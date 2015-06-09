angular.module('app').controller 'ExternalUserCompanyEditCtrl', ($scope, $state, $stateParams, $window, ExternalUser, RucomService, LocationService,$mdDialog) ->
  # *********************************** VARIABLES **********************************#
  $scope.currentExternalUser = null
  $scope.company = null
  $scope.saveBtnEnabled = false
  $scope.rucomIDField =
    label: 'Número de RUCOM'
    field: 'num_rucom'
  # ********************************************************************************#
  if $stateParams.id
    ExternalUser.get($stateParams.id).success (data)->
      $mdDialog.cancel()
      $scope.company = data.company
      $scope.currentExternalUser = data
      
  #****** Watchers for listen to changes in editable fields *************************
  $scope.$watch 'currentExternalUser', ((newVal, oldVal) ->
    if oldVal and newVal != oldVal
      $scope.saveBtnEnabled = true
    return
  ), true


  $scope.save = ->
    #PUT Request:
    ExternalUser.modelToUpdate.company.phone_number = $scope.currentExternalUser.company.phone_number
    ExternalUser.modelToUpdate.company.email = $scope.currentExternalUser.company.email
    
    ExternalUser.update_external_user_company($scope.currentExternalUser.id).success (data)->
      $mdDialog.cancel()
      $mdDialog.show $mdDialog.alert().title('Mensaje').content('Información actualizada correctamente.').ariaLabel('Alert Dialog Demo').ok('ok!')


    return

  $scope.back = ->
    $window.history.back()
    return