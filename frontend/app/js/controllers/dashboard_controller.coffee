angular.module('app').controller 'DashboardCtrl', ($scope, $alert, $auth, CurrentUser) ->
  #Get the current user logged!
  CurrentUser.get().success (data) ->
    $scope.currentUser = data