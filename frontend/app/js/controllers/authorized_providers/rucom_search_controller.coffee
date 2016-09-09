angular.module('app').controller 'AuthorizedProviderSearchCtrl', ($scope, $state , $mdDialog , AuthorizedProvider, ProviderService) ->
  $scope.prov = undefined
  AuthorizedProvider.clearModelToCreate()

  # method to format the content acording the table headers
  formatted_content = (producer)->
    prov =
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
    return prov
  ##***************************************************************************************************************************##

  $scope.queryRucomByIdNumber = (ev, idNumber) ->
    console.log('ingresa al envento - idNumber: ' + idNumber)
    if idNumber
      ProviderService.basicProvider.get {
        id_number: idNumber
      }, ((data, status, headers) ->
          $scope.showLoading = false
          $scope.prov = formatted_content(data)
          AuthorizedProvider.response = $scope.prov
          AuthorizedProvider.modelToCreate.user_type = 'Barequero'
          AuthorizedProvider.saveModelToCreate()
          $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Consulta Exitosa').content('Productor si se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
          $state.go 'new_authorized_provider', { id: $scope.prov.id, content: $scope.prov}

      ), (error) ->
          $scope.prov = error
          $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content('Productor no se encuentra en el RUCOM').ariaLabel('Alert Dialog ').ok('ok')
          return

  $scope.cancel = ->
    window.back
  $scope.anyErrors = ->
    return if $scope.prov.errors == null || $scope.prov.errors == undefined then  false  else true