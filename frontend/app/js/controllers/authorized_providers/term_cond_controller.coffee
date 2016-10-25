angular.module('app').controller 'AuthorizedProviderTermCondCtrl',
  ($scope, $sce, $state, $stateParams, AuthorizedProviderService, SignatureService, $mdDialog) ->
    # var initialize
    $scope.authorizedProvider = null
    $scope.prov = null
    $scope.chkAgreetmentActive = false
        
    $scope.authorizedProvider = AuthorizedProviderService.restoreModel()

    #window.scope = $scope
    hp = $scope
    $scope.continue = ->
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
      SignatureService.authorizedProviderName = hp.authorizedProvider.first_name
      SignatureService.restartSession()

    #
    # Captures the signature from the device
    $scope.captureSignature = ->
      SignatureService.Capture()

    #
    # Puts it in a img tag
    $scope.saveSignature = ->
      $scope.authorizedProviderService.model.signature_picture = document.getElementById('authorized_provider_signature').src


