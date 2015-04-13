angular.module('app').controller('SearchRucomCtrl', ['$scope', 'RucomService' ,function($scope, RucomService){
  
  $scope.toggleSearch = true;  
  $scope.query = '';
  $scope.content = []; 
  $scope.headers = [
    {
      name: 'RUCOM Number', 
      field: 'num_rucom',
      alternateField: 'rucom_record'
    },{
      name: 'Provider type', 
      field: 'provider_type',
      alternateField: 'provider_type'
    },{
      name: 'Name', 
      field: 'name',
      alternateField: 'name'
    },{
      name: 'RUCOM Status', 
      field: 'status',
      alternateField: 'status'
    },{
      name: 'Mineral', 
      field: 'mineral',
      alternateField: 'mineral'
    }
  ];

  RucomService.retrieveRucoms.query({per_page: 100, page: 1}, function(rucoms) {
    $scope.content = rucoms;    
  });

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
        $scope.search_rucom($scope.searchRucom.rucom_record);
      }
  }, true);  

  $scope.search_rucom = function(query) {
    console.log(query);    
    //$scope.query = 'ARE_PLU-08141';
    if(query.length > 3) {
      RucomService.retrieveRucoms.query({rucom_query: query}, function(rucoms) {
    //RucomService.retrieveRucoms.get(function(rucoms) {
      console.log('Matching rucom registries: ' + JSON.stringify(rucoms));
      $scope.query = '';  
      $scope.content = rucoms;    
      return true;
      });
    } else {
      RucomService.retrieveRucoms.query({per_page: 100, page: 1}, function(rucoms) {
        $scope.content = rucoms;    
      });
      return true;
    }
  };  
  
}]);

angular.module('app').filter('startFrom',function (){
  return function(input, start) {
    if (!input || !input.length) { return; }
      start = +start; //parse to int
      return input.slice(start);
  };
});
