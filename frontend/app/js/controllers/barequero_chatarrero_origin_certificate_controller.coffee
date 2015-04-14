angular.module('app').controller 'OriginCertificateCtrl', ($scope, BarequeroChatarreroOriginCertificateService, $mdDialog) ->
  $scope.barequero_chatarrero_origin_certificate = BarequeroChatarreroOriginCertificateService.model

  #
  # confirm Dialog
  $scope.barequeroChatarreroshowConfirm = (ev) ->
    # Appending dialog to document.body to cover sidenav in docs app
    confirm = $mdDialog.confirm()
                      .title('Centificado de Origen')
                      .content('Esta seguro que desea realizar el certificado de origen?')
                      .ariaLabel('Lucky day')
                      .ok('Si, deseo generarlo')
                      .cancel('No, cancelar generacion de certificado')
                      .targetEvent(ev)
    $mdDialog.show(confirm).then (->
      $scope.message = 'Su certificado de origne ha sido generado exitosamente'
      return
    ), ->
      console.log 'purchase canceled'
      $scope.message = 'El proceso ha sido cancelado '
      return