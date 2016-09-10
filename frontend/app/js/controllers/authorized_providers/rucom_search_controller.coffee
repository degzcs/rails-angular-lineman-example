angular.module('app').controller 'AuthorizedProviderSearchCtrl', ($scope, $state , $mdDialog, AuthorizedProviderService, ProviderService) ->
  $scope.authorizedProviderService = undefined
  AuthorizedProviderService.clearModel()

  ##***************************************************************************************************************************##

  # Search an authorized provider by its id number
  # @param ev [ Event ]
  # @param idNumber [ Integer ]
  $scope.queryRucomByIdNumber = (ev, idNumber) ->
    if idNumber
      AuthorizedProviderService.byIdNumber(idNumber)
      .success((data, status, headers) ->
        $scope.showLoading = false
        AuthorizedProviderService.model = data
        $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Consulta Exitosa').content('Productor si se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
        $state.go 'new_authorized_provider', { id: AuthorizedProviderService.model.id }
      )
      .error((error)->
        $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content('Productor no se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
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