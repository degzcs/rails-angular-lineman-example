angular.module('app').controller 'AuthorizedProviderTermCondCtrl',
  ($scope, $sce, $state, $stateParams, AuthorizedProviderService, SignatureService, $mdDialog, CurrentUser) ->
    # var initialize
    $scope.prov = null
    $scope.chkAgreetmentActive = false

    $scope.authorizedProvider = AuthorizedProviderService.restoreModel()

    CurrentUser.get().success (data) ->
      $scope.authorizedProvider.use_wacom_device = data.use_wacom_device

    $scope.continue = ->
        saveSignature()
        AuthorizedProviderService.model = $scope.authorizedProvider
        AuthorizedProviderService.saveModel()
        $state.go 'new_authorized_provider', { id: AuthorizedProviderService.model.id }


    $scope.handlerContinue = ->
    # console.log $scope.chkAgreetmentActive
      res = if $scope.chkAgreetmentActive == true then true else false
      # console.log 'res: ' + res
      return res

    #
    # Signature services
    #

    #
    # Allows to see if the device is connected.
    $scope.restartSessionDevice = ->
      SignatureService.imageId = 'authorized_provider_signature'
      SignatureService.authorizedProviderName = $scope.authorizedProvider.fullName
      SignatureService.restartSession()

    #
    # Captures the signature from the device
    $scope.captureSignature = ->
      window.scope = $scope
      window.ss = SignatureService
      SignatureService.Capture()

    #
    # Puts it in a img tag
    saveSignature = ->
      if $scope.authorizedProvider.use_wacom_device == false
        $scope.authorizedProvider.signature_picture = null
      else
        $scope.authorizedProvider.signature_picture = document.getElementById('authorized_provider_signature').src


