angular.module('app').controller 'AuthorizedProviderSearchCtrl', ($scope, $state , $mdDialog, AuthorizedProviderService) ->
  $scope.authorizedProviderService = undefined
  AuthorizedProviderService.clearModel()

  #*** Loading Variables **** #
  $scope.showLoading = false
  $scope.loadingMode = "indeterminate"
  $scope.loadingMessage = "Consultado..."

  ##***************************************************************************************************************************##

  # Search an authorized provider by its id number
  # @param ev [ Event ]
  # @param idNumber [ Integer ]
  # @param rolName [ String ]



  $scope.queryRucomByIdNumber = (ev, idNumber, rolName) ->
    if idNumber 
      AuthorizedProviderService.byIdNumber(idNumber, rolName)
      .success((data, status, headers) ->
        $scope.showLoading = false
        AuthorizedProviderService.model = data
        AuthorizedProviderService.buy_agreetment().success( (data) ->
          AuthorizedProviderService.model.buy_agreetment = data.buy_agreetment
          AuthorizedProviderService.saveModel()
          $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Consulta Exitosa').content('Productor si se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
          $state.go 'term_and_cond_authorized_provider', { id: AuthorizedProviderService.model.id }
        )
        .error((error)->
          $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content(error.detail).ariaLabel('Alert Dialog ').ok('ok')
        )  
      )
      .error((error)->
        $scope.showLoading = false
        $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content(error.detail).ariaLabel('Alert Dialog ').ok('ok')
        )

  #
  # Come back to the previous page (Authorized Provider Index)
  $scope.cancel = ->
    $mdDialog.cancel()

  #
  # Checks if there were any error
  # @return [ Boolean ]
  $scope.anyErrors = ->
    if $scope.prov
      return if $scope.prov.errors == null || $scope.prov.errors == undefined then  false  else true