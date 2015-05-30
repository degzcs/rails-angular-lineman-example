angular.module('app').controller 'SearchRucomCtrl', ($scope, $stateParams, RucomService,$http,$mdDialog)->
  ##****************************************  TABLE HEADERS and initial config variables *****************************************##
  $scope.toggleSearch = true
  $scope.query = ''
  $scope.content = []
  $scope.show_rucoms = false
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
  $scope.count = 5;  

  #********************************************************************************************
  #Watchers for listen to changes in query fields
  $scope.$watch 'queryName', (newVal, oldVal) ->
    if oldVal and newVal != oldVal
      $scope.queryFocus = 'queryName'
      RucomService.query_by_name($scope.queryName).success( (data, status, headers) ->
        #console.log data
        $scope.content = data
        $scope.pages = parseInt(headers().total_pages)
        $scope.show_rucoms = true
      ).error (data, status, headers, config)->
        #console.log data
      return

  # objectEquality = true
  $scope.$watch 'queryRucomNum', (newVal, oldVal) ->
    if oldVal and newVal != oldVal
      $scope.queryFocus = 'queryRucomNum'
      #console.log $scope.queryRucomNum
      RucomService.query_by_rucom_num($scope.queryRucomNum).success( (data, status, headers) ->
        $scope.content = data
        $scope.pages = parseInt(headers().total_pages)
        $scope.show_rucoms = true
      ).error (data, status, headers, config)->
      return

  $scope.cancel = (ev)->
    window.history.back();
    $mdDialog.show $mdDialog.alert()
    .title('Mensaje')
    .content('Has cancelado la seleccion de rucom.')
    .ariaLabel('ok')
    .ok('ok').targetEvent(ev)





    