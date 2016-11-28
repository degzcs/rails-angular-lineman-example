angular.module('app').controller 'RoyaltiesTabCtrl', ($scope, $mdDialog, CurrentUser, ReportsService) ->
  $scope.signaturePicture = null
  $scope.period = null # 1, 2, 3 , 4 (each one is a group of three months)
  $scope.selectedYear = null # ex. '2016'
  $scope.mineralPresentation = null # ex. 'Amalgama'
  $scope.baseLiquidationPrice = null # ex. 88.823
  $scope.royaltyPercentage = null # ex. 4 which means both 4% or 0.04
  useWacomDevice =  null

  CurrentUser.get().success (data) ->
    $scope.currentUser = data
    useWacomDevice = data.use_wacom_device

  $scope.generatePdfFile= () ->
    ReportsService.generateRoyaltiesDocument($scope.signaturePicture, $scope.period, $scope.selectedYear, $scope.mineralPresentation, $scope.baseLiquidationPrice, $scope.royaltyPercentage, useWacomDevice)
