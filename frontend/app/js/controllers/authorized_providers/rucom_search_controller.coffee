angular.module('app').controller 'AuthorizedProviderSearchCtrl', ($scope, $state , $mdDialog, AuthorizedProviderService, ProviderService) ->
  $scope.authorizedProviderService = undefined
  AuthorizedProviderService.clearModel()

  #
  # Formats the content acording the table headers
  # @param producer [ Object ]
  # @return [ Object ]
  formattedContent = (producer)->
    authorized_provider =
      id: producer.id
      document_number: producer.document_number
      first_name: producer.first_name
      last_name: producer.last_name
      address: producer.address
      email: producer.email
      city: producer.city
      state: producer.state
      phone_number: producer.phone_number
      photo_file: producer.photo_file
      identification_number_file: producer.identification_number_file
      mining_register_file: producer.mining_register_file
      rut_file: producer.rut_file
      rucom:
        id: producer.rucom.id
        num_rucom: producer.rucom.rucom_number
        provider_type: producer.rucom.producer_type
        rucom_status: if producer.rucom.status then producer.rucom.status else if producer.rucom.id then 'Inscrito' else 'No Inscrito'
        mineral: producer.rucom.minerals
    return authorized_provider

  ##***************************************************************************************************************************##

  # Search an authorized provider by its id number
  # @param ev [ Event ]
  # @param idNumber [ Integer ]
  $scope.queryRucomByIdNumber = (ev, idNumber) ->
    if idNumber
      AuthorizedProviderService.byIdNumber(idNumber)
      .success((data, status, headers) ->
        $scope.showLoading = false
        $scope.authorizedProvider = formattedContent(data)
        # AuthorizedProviderService.response = $scope.authorized_provider
        # AuthorizedProviderService.model.user_type = 'Barequero'
        AuthorizedProviderService.saveModel()
        $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Consulta Exitosa').content('Productor si se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
        $state.go 'new_authorized_provider', { id: $scope.authorizedProvider.id, content: $scope.authorizedProvider }
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