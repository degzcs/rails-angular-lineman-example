angular.module('app').controller 'LogoutCtrl', ($auth, $alert,$mdDialog) ->
  if !$auth.isAuthenticated()
    return
  $auth.logout().then ->
    $mdDialog.show $mdDialog.alert()
      .title('You have been logged out')
      .content('Bye!')
      .ok('Got it!')
      duration: 3
    return
  return