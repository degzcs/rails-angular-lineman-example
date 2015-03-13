angular.module('app').controller 'LoginCtrl', ($scope, $alert, $auth) ->

  $scope.login = ->
    $auth.login(
      email: $scope.email
      password: $scope.password).then(->
      $alert
        content: 'You have successfully logged in'
        animation: 'fadeZoomFadeDown'
        type: 'material'
        duration: 3
      return
    ).catch (response) ->
      $alert
        content: response.data.message
        animation: 'fadeZoomFadeDown'
        type: 'material'
        duration: 3
      return
    return
  return