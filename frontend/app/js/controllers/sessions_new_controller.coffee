angular.module('app').controller 'SessionsNewCtrl', ($scope, $alert, $auth,$mdDialog,SessionService, $stateParams, $location) ->

  #
  # Instances
  #
  $scope.email = $stateParams.email || ''
  $scope.password = ''
  $scope.password_confirmation = ''

  #
  # Functions
  #

  $scope.logout = ->
    if !$auth.isAuthenticated()
      return
    $auth.logout().then ->
      # NOTE: this dialog is annoying but it could be actived if it is needed
      # $mdDialog.show $mdDialog.alert()
      #   .title('Logout')
      #   .content('Adios!')
      #   .ok('Adios!!')
      #   duration: 2
      return

   $scope.activateNewPassword = ->
    #TODO: save password  SessionService
    confirm = $mdDialog.confirm().title('Recuperar contraseña')
                                        .content('Se ha actualizado la contraseña')
                                        .ariaLabel('Lucky day')
                                        .ok('Ok')
    $mdDialog.show(confirm).then(->
      SessionService.resetPassword($scope.email, $scope.password, $scope.password_confirmation)
      $location.path '/login'
      return
    )

  $scope.sendToken = ->
  #TODO: SEND TOKEN SessionService
    console.log("send link");
    confirm = $mdDialog.confirm().title('Recuperar contraseña')
      .content('Se ha enviado un enlace para recuperar contraseña')
      .ariaLabel('Lucky day')
      .ok('Ok')
    $mdDialog.show(confirm).then( ->
      SessionService.forgotPassword($scope.email)
      window.history.back()
      return
    )#, ->
    #   console.log 'Intentalo de nuevo!'
    #   return

  $scope.login = ->
    $auth.login(
      email: $scope.email
      password: $scope.password).then(->
      # NOTE: this dialog is annoying but it could be actived if it is needed
      # $mdDialog.show $mdDialog.alert()
      #   .title('Login')
      #   .content('Bienvenido!')
      #   .ok('hecho!')
      #   duration: 2
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