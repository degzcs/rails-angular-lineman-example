angular.module('app').controller 'LogoutCtrl', ($auth, $alert) ->
  if !$auth.isAuthenticated()
    return
  $auth.logout().then ->
    $alert
      content: 'You have been logged out'
      animation: 'fadeZoomFadeDown'
      type: 'material'
      duration: 3
    return
  return