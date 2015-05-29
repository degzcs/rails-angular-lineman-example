angular.module('app').controller 'SearchRucomCtrl', ($scope, $stateParams, RucomService,$http,$mdDialog)->
  ##****************************************  TABLE HEADERS and initial config variables *****************************************##
  $scope.toggleSearch = true
  $scope.query = ''
  $scope.content = []
  $scope.headers = [
    {
      name: 'Número de RUCOM'
      field: 'num_rucom'
      alternateField: 'rucom_record'
    }
    {
      name: 'Tipo de Proveedor'
      field: 'provider_type'
      alternateField: 'provider_type'
    }
    {
      name: 'Nombre'
      field: 'name'
      alternateField: 'name'
    }
    {
      name: 'Estado del RUCOM'
      field: 'status'
      alternateField: 'status'
    }
    {
      name: 'Mineral'
      field: 'mineral'
      alternateField: 'mineral'
    }
  ]

  $scope.custom = {num_rucom: 'bold', provider_type: 'gray', name: 'gray', status: 'gray'};
  $scope.sortable = ['num_rucom', 'provider_type', 'name', 'status'];  
  $scope.thumbs = 'thumb';
  $scope.count = 8;  

  ##***************************************************************************************************************************##

  RucomService.all($scope.count).success( (data, status, headers)->
    $mdDialog.cancel()
    $scope.content = data
    $scope.pages = parseInt(headers().total_pages)
    
  ).error (data, status, headers, config)->
    console.log data
    $mdDialog.show $mdDialog.alert().parent(angular.element(document.body)).title('Hubo un problema').content('Compruebe su conexion a intenet.').ariaLabel('Alert Dialog ').ok('ok')
    return


    