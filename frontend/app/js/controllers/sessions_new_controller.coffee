angular.module('app').controller 'SessionsNewCtrl', ($scope, $alert, $auth,$mdDialog) ->

  $scope.logout = ->
    if !$auth.isAuthenticated()
      return
    $auth.logout().then ->
      $mdDialog.show $mdDialog.alert()
        .title('Logout')
        .content('Adios!')
        .ok('Adios!!')
        duration: 2
      return
      
  $scope.login = ->
    $auth.login(
      email: $scope.email
      password: $scope.password).then(->
      $mdDialog.show $mdDialog.alert()
        .title('Login')
        .content('Bienvenido!')
        .ok('hecho!')
        duration: 2
      return
      
    ).catch (response) ->
      $mdDialog.show $mdDialog.alert()
        .title('Datos incorrectos!')
        .content('La informacion ingresada es incorrecta, verifique nuevamente su nomber de usuario y password')
        .ariaLabel('Password notification')
        .ok('trate nuevamente!')
      return
    return
  $scope.isAuthenticated = ->
    return $auth.isAuthenticated()
  return