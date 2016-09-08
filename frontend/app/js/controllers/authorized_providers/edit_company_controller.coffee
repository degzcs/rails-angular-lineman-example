angular.module('app').controller 'AuthorizedProviderCompanyEditCtrl', ($scope, $state, $stateParams, $window, AuthorizedProvider, RucomService, LocationService,$mdDialog) ->
  # *********************************** VARIABLES **********************************#
  $scope.currentAuthorizedProvider = null
  $scope.company = null
  $scope.saveBtnEnabled = false
  $scope.rucomIDField =
    label: 'Número de RUCOM'
    field: 'num_rucom'
  # ********************************************************************************#
  if $stateParams.id
    AuthorizedProvider.get($stateParams.id).success (data)->
      $mdDialog.cancel()
      $scope.company = data.company
      $scope.currentAuthorizedProvider = data

  #****** Watchers for listen to changes in editable fields *************************
  $scope.$watch 'currentAuthorizedProvider', ((newVal, oldVal) ->
    if oldVal and newVal != oldVal
      $scope.saveBtnEnabled = true
    return
  ), true


  $scope.save = ->
    #PUT Request:
    AuthorizedProvider.modelToUpdate.company.phone_number = $scope.currentAuthorizedProvider.company.phone_number
    AuthorizedProvider.modelToUpdate.company.email = $scope.currentAuthorizedProvider.company.email

    AuthorizedProvider.update_external_user_company($scope.currentAuthorizedProvider.id).success (data)->
      $mdDialog.cancel()
      $mdDialog.show $mdDialog.alert().title('Mensaje').content('Información actualizada correctamente.').ariaLabel('Alert Dialog Demo').ok('ok!')


    return

  $scope.back = ->
    $window.history.back()
    return