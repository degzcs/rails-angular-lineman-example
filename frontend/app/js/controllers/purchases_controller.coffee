angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, GoldBatchService, CameraService) ->
  #
  # Instances
  #
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  # $scope.purchase.model = PurchaseService.restoreState
  window.scope = $scope
  $scope.totalGrams = 0

  #
  # Fuctions
  #
  $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()

  #Total Grams
  # $scope.$watch 'goldBatch.model.castellanos', ->
  #   console.log 'whatching...'

  $scope.$apply= ->
    $scope.totalGrams = $scope.goldBatch.castellanosToGrams +  $scope.goldBatch.ozsToGrams + $scope.goldBatch.tominesToGrams + $scope.goldBatch.rialesToGrams

  #Total Price
  $scope.totalPrice= ->
    $scope.goldBatch.priceBasedOnCastellanos + $scope.goldBatch.priceBasedOnOzs +$scope.goldBatch.priceBasedOnTomines +$scope.goldBatch.priceBasedOnRials

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

  # Create a new purschase in the server
  $scope.create = (data) ->
    PurchaseService.create $scope.purchase.model, $scope.goldBatch.model

