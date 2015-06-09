angular.module('app').controller 'ClientIndexCtrl', ($scope,ClientService,$mdDialog,$state) ->
  #*** Loading Variables **** #
  $scope.showLoading = true
  $scope.loadingMode = "indeterminate"
  $scope.loadingMessage = "Cargando ..."
  ##****************************************  TABLE HEADERS and initial config variables *****************************************##
  $scope.count = 10
  $scope.content = []
  $scope.toggleSearch = false
  $scope.queryName = ''
  $scope.queryId = ''
  $scope.queryFocus = ''

  $scope.headers = [
    {
      name: ''
      field: 'photo_file'
      alternateField: 'photo_file'
    }
    {
      name: 'Nombre'
      field: 'first_name'
      alternateField: 'first_name'
    }
    {
      name: 'Apellido'
      field: 'last_name'
      alternateField: 'last_name'
    }
    {
      name: 'Número de Identificación'
      field: 'document_number'
      alternateField: 'document_number'
    }
    {
      name: 'Mineral'
      field: 'mineral'
      alternateField: 'mineral'
    }
    {
      name: 'Número de RUCOM'
      field: 'num_rucom'
      alternateField: 'rucom_record'
    }
    {
      name: 'Estado del RUCOM'
      field: 'rucom_status'
      alternateField: 'rucom_status'
    }
    {
      name: 'Tipo de Proveedor'
      field: 'provider_type'
      alternateField: 'provider_type'
    }
    # {
    #   name: 'Última Transacción'
    #   field: 'last_transaction_date'
    #   alternateField: 'last_transaction_date'
    # }
  ]
  $scope.custom =
    first_name: 'bold'
    last_name: 'bold'
    document_number: 'grey'
    mineral: 'grey'
    num_rucom: 'grey'
    rucom_status: 'grey'
    provider_type: 'grey'
    last_transaction_date: 'grey'
  $scope.sortable = [
    'first_name'
    'last_name'
    'document_number'
    'mineral'
    'num_rucom'
    'rucom_status'
    'provider_type'
    'last_transaction_date'
  ]
  $scope.thumbs = 'photo_file'


  # method to format the content acording the table headers
  formated_content = (data)->
    content = []
    i = 0
    while i < data.length
      external_user = 
        id: data[i].id
        document_number: data[i].document_number
        first_name: data[i].first_name
        last_name: data[i].last_name
        address: data[i].address
        email: data[i].email
        phone_number: data[i].phone_number
        photo_file: data[i].photo_file or 'http://robohash.org/' + data[i].id
        num_rucom: data[i].rucom.num_rucom if data[i].rucom
        rucom_record: data[i].rucom.rucom_record if data[i].rucom
        provider_type: data[i].rucom.provider_type if data[i].rucom
        rucom_status: data[i].rucom.status if data[i].rucom
        mineral: data[i].rucom.mineral if data[i].rucom
      content.push external_user
      i++
    return content
  ##***************************************************************************************************************************##

  ClientService.all($scope.count).success( (data, status, headers)->
    $scope.showLoading = false
  
    $scope.content = formated_content(data)
    $scope.pages = parseInt(headers().total_pages)
    
  ).error (data, status, headers, config)->
    $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content('Compruebe su conexion a intenet.').ariaLabel('Alert Dialog ').ok('ok')
    return


  #Watchers for listen to changes in query fields
  $scope.$watch 'queryName', (newVal, oldVal) ->
    if oldVal and newVal != oldVal
      $scope.queryFocus = 'name'
      ClientService.query_by_name($scope.queryName).success( (data, status, headers) ->
        $mdDialog.cancel()
        $scope.content = formated_content(data)
        $scope.pages = parseInt(headers().total_pages)
      ).error (data, status, headers, config)->
      return

  # objectEquality = true
  $scope.$watch 'queryId', (newVal, oldVal) ->
    if oldVal and newVal != oldVal
      $scope.queryFocus = 'id'
      ClientService.query_by_id($scope.queryId).success( (data, status, headers) ->
        $mdDialog.cancel()
        $scope.content = formated_content(data)
        $scope.pages = parseInt(headers().total_pages)
      ).error (data, status, headers, config)->
      return

  #Launch External user type selection
  $scope.new_external_user = (ev) ->
    #$state.go 'create_external_user_type_a'
    $mdDialog.show
      controller: 'ExternalUserTypeCtrl'
      templateUrl: 'partials/user-type-selection.html'
      targetEvent: ev
    return


