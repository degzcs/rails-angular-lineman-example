angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, CameraService) ->
  #
  # Instances
  #
  $scope.purchase = PurchaseService
  # $scope.purchase.model = PurchaseService.restoreState

  #
  # Fuctions
  #
  $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()

  $scope.saveState= ->
    console.log('saving purchase state on sessionStore ... ')
    $scope.purchase.saveState()
    $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()

  # $scope.formCreateTabCtrl = {
  #   selectedIndex : 0,
  #   secondUnlocked : true,
  #   firstLabel : "Provedor y Certificado de Origen",
  #   secondLabel : "Pesaje y Compra"
  # };

  # It sends the information when the file is selected
  $scope.create = (data) ->
    PurchaseService.create $scope.purchase

