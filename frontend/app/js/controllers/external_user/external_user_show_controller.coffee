angular.module('app').controller 'ExternalUserShowCtrl', ($scope, $state, $stateParams, $window, ExternalUser, RucomService, LocationService,$mdDialog) ->

  $scope.currentExternalUser = null
  $scope.company = null
  $scope.rucomIDField =
    label: 'Numero'
    field: 'num_rucom'

  if $stateParams.id
    ExternalUser.get($stateParams.id).success (data)->
      $mdDialog.cancel()
      $scope.currentExternalUser = data
      console.log data