angular.module('app').controller 'SettingsCtrl', (CurrentUser, $scope) ->

  #
  # Model
  #

  $scope.currentUser = null
  # $scope.RUCOM_TYPES_MAPPING = [
  #   { key: 'Personal', value: 'personal'},
  #   { key: 'Empresa', value: 'company'}
  # ]
  # $scope.rucomType = 'company'

  #
  #  Functions
  #

  # # Gets the current logged in user
  # CurrentUser.get().success (data) ->
  #   $scope.currentUser = data

  # # Getter
  # $scope.rucomType = CurrentUser.settings.get('rucomType')

  # # Setter
  # $scope.$watch '[rucomType]', ->
  #   CurrentUser.settings.set({ rucomType: $scope.rucomType })


