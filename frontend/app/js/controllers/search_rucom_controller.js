angular.module('app').controller('SearchRucomCtrl', ['$scope', '$stateParams', 'RucomService' ,function($scope, $stateParams, RucomService){
  
  $scope.toggleSearch = true;  
  $scope.query = '';
  $scope.type = $stateParams.type;
  $scope.capType = $stateParams.type === 'client' ? 'Cliente' : 'Proveedor';
  $scope.content = []; 
  $scope.headers = [
    {
      name: 'Número de RUCOM', 
      field: 'num_rucom',
      alternateField: 'rucom_record'
    },{
      name: 'Tipo de Proveedor', 
      field: 'provider_type',
      alternateField: 'provider_type'
    },{
      name: 'Nombre', 
      field: 'name',
      alternateField: 'name'
    },{
      name: 'Estado del RUCOM', 
      field: 'status',
      alternateField: 'status'
    },{
      name: 'Mineral', 
      field: 'mineral',
      alternateField: 'mineral'
    }
  ];

  if ($scope.type === 'client') {
    RucomService.retrieveRucoms.query({per_page: 100, page: 1, query_provtype: 'Comercializadores'}, function(rucoms) {
      $scope.content = rucoms;    
    });
  } else {
    RucomService.retrieveRucoms.query({per_page: 100, page: 1}, function(rucoms) {
      $scope.content = rucoms;    
    });
  }

  $scope.custom = {num_rucom: 'bold', provider_type: 'gray', name: 'gray', status: 'gray'};
  $scope.sortable = ['num_rucom', 'provider_type', 'name', 'status'];  
  $scope.thumbs = 'thumb';
  $scope.count = 8;  
  //$scope.currentRucom = ProviderService.getCurrentProv();
  //Cambiar get por query antes de subir...
  //RucomService.retrieveRucoms.get((function(res) {
  // RucomService.retrieveRucom.get((function(res) {
  //   return $scope.content = res.list;
  // }), function(error) {});
  
  $scope.searchRucom = {        
    num_rucom: '',
    provider_type: '' ,  
    name: '',
    status: '',
    mineral: '',
    rucom_record: ''    
  };

  $scope.$watch('searchRucom', 
    function(newVal, oldVal) {
      if (oldVal && newVal !== oldVal) {
        $scope.search_rucom($scope.searchRucom);
      }
  }, true);  

  $scope.search_rucom = function(query) {
    console.log(query);    
    //$scope.query = 'ARE_PLU-08141';
    if(query.rucom_record.length > 3 || query.name.length > 3) {
      RucomService.retrieveRucoms.query({rucom_query: query.rucom_record, name_query: query.name}, function(rucoms) {
    //RucomService.retrieveRucoms.get(function(rucoms) {
      console.log('Matching rucom registries: ' + JSON.stringify(rucoms));
      $scope.query = '';  
      $scope.content = rucoms;    
      return true;
      });
    } else {
      if ($scope.type === 'client') {
        RucomService.retrieveRucoms.query({per_page: 100, page: 1, query_provtype: 'Comercializadores'}, function(rucoms) {
          $scope.content = rucoms;    
        });
        return true;
      } else {
        RucomService.retrieveRucoms.query({per_page: 100, page: 1}, function(rucoms) {
          $scope.content = rucoms;    
        });
        return true;
      }
    }
  };
  $scope.comeBack = function() {
    window.history.back();
  };  
  
}]);

angular.module('app').filter('startFrom',function (){
  return function(input, start) {
    if (!input || !input.length) { return; }
      start = +start; //parse to int
      return input.slice(start);
  };
});
