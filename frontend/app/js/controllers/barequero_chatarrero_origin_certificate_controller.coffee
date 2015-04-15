angular.module('app').controller 'OriginCertificateCtrl', ($scope, BarequeroChatarreroOriginCertificateService, $mdDialog, PdfService) ->
  $scope.barequero_chatarrero_origin_certificate = BarequeroChatarreroOriginCertificateService.model

  #
  # confirm Dialog
  $scope.barequeroChatarreroshowConfirm = (ev) ->

    confirm = $mdDialog.confirm()
                      .title('Centificado de Origen')
                      .content('Esta seguro que desea realizar el certificado de origen?')
                      .ariaLabel('Lucky day')
                      .ok('Si, deseo generarlo')
                      .cancel('No, cancelar generacion de certificado')
                      .targetEvent(ev)
    $mdDialog.show(confirm).then (->
      # window.oc  = $scope.barequero_chatarrero_origin_certificate
      provider = $scope.barequero_chatarrero_origin_certificate.provider
      provider.name = provider.first_name + ' ' + provider.last_name
      $scope.barequero_chatarrero_origin_certificate.provider = provider
      PdfService.createBarequeroChatarreroOriginCertificate($scope.barequero_chatarrero_origin_certificate)
      $scope.message = 'Su certificado de origne ha sido generado exitosamente'
      return
    ), ->
      console.log 'purchase canceled'
      $scope.message = 'El proceso ha sido cancelado '
      return