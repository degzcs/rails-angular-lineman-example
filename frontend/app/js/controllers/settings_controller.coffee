angular.module('app').controller 'SettingsCtrl', (CurrentUser, $scope) ->

  #
  # Model
  #


  $scope.currentUser = null
  $scope.PERSON_TYPE_MAPPING = [
    { key: 'Persona Natural', value: 'natural'},
    { key: 'Persona Juridica', value: 'legal'}
  ]
  $scope.personType = null
  window.scope = $scope

  #
  #  Functions
  #

  # Gets the current logged in user
  CurrentUser.get().success (data) ->
    $scope.currentUser = data

  # Getter
  $scope.personType = CurrentUser.settings.get('personType')

  # Setter
  $scope.$watch '[personType]', ->
    CurrentUser.settings.set({ personType: $scope.personType })


