angular.module('app').controller 'RoyaltiesTabCtrl', ($scope, $mdDialog, CurrentUser, ReportsService, SignatureService) ->
  $scope.signaturePicture = null
  $scope.period = null # 1, 2, 3 , 4 (each one is a group of three months)
  $scope.selectedYear = null # ex. '2016'
  $scope.mineralPresentation = null # ex. 'Amalgama'
  $scope.baseLiquidationPrice = null # ex. 88.823
  $scope.royaltyPercentage = null # ex. 4 which means both 4% or 0.04
  currentUser = null
  useWacomDevice =  null

  CurrentUser.get().success (data) ->
    currentUser = data
    useWacomDevice = data.use_wacom_device
    $scope.response = CurrentUser.can_genearate_royalties_document(data)

  $scope.generatePdfFile= () ->
    if useWacomDevice
      saveSignature()
    ReportsService.generateRoyaltiesDocument($scope.signaturePicture, $scope.period, $scope.selectedYear, $scope.mineralPresentation, $scope.baseLiquidationPrice, $scope.royaltyPercentage, useWacomDevice)

  #
  # Signature services
  #

  #
  # Allows to see if the device is connected.
  $scope.restartSessionDevice = ->
    SignatureService.imageId = 'royalties_signature'
    SignatureService.authorizedProviderName = currentUser.first_name + '' + currentUser.last_name
    SignatureService.restartSession()

  #
  # Captures the signature from the device
  $scope.captureSignature = ->
    SignatureService.Capture()

  #
  # Puts it in a img tag
  saveSignature = ->
    $scope.signaturePicture = document.getElementById('royalties_signature').src
