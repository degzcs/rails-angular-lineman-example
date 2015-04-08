angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, MeasureConverterService) ->
  #
  # Instances
  #
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  # $scope.purchase.model = PurchaseService.restoreState
  $scope.totalGrams = '0'
  $scope.gramUnitPrice = $scope.goldBatch.gramUnitPrice

  #
  # Fuctions
  #
  $scope.purchase.model.provider_photo_file=CameraService.getLastScanImage()

  # Watch Measures
  $scope.$watch '[goldBatch.model.castellanos,  goldBatch.model.ozs, goldBatch.model.tomines, goldBatch.model.riales]', ->
    $scope.castellanosToGrams = MeasureConverterService.castellanosToGrams($scope.goldBatch.model.castellanos)
    $scope.ozsToGrams = MeasureConverterService.ozsToGrams($scope.goldBatch.model.ozs)
    $scope.tominesToGrams = MeasureConverterService.tominesToGrams($scope.goldBatch.model.tomines)
    $scope.rialesToGrams = MeasureConverterService.rialesToGrams($scope.goldBatch.model.riales)


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

