angular.module('app').controller 'AuthCtrl', ($scope, $alert, $auth,$mdDialog) ->

  $scope.logout = ->
    if !$auth.isAuthenticated()
      return
    $auth.logout().then ->
      $mdDialog.show $mdDialog.alert()
        .title('You have been logged out')
        .content('Bye!')
        .ok('Got it!')
        duration: 3
      return
      
  $scope.login = ->
    $auth.login(
      email: $scope.email
      password: $scope.password).then(->
      $mdDialog.show $mdDialog.alert()
        .title('You have successfully logged in')
        .content('Welcome!')
        .ok('Got it!')
        duration: 3
      return
      
    ).catch (response) ->
      $mdDialog.show $mdDialog.alert()
        .title('Bad Email or password')
        .content('Do you have an account?')
        .ariaLabel('Password notification')
        .ok('Got it!')
      return
    return
  $scope.isAuthenticated = ->
    return $auth.isAuthenticated()
  return