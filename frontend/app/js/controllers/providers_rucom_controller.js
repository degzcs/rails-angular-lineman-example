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

  $scope.custom = {num_rucom: 'bold', provider_type: 'gray', name: 'gray', status: 'gray'};
  $scope.sortable = ['num_rucom', 'provider_type', 'name', 'status'];  
  $scope.thumbs = 'thumb';
  $scope.count = 10;  
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
    mineral: ''    
  };  

  $scope.search_rucom = function(query) {
    console.log(query);    
    //$scope.query = 'ARE_PLU-08141';
    RucomService.retrieveRucoms.query({rucom_query: query}, function(data) {
  //RucomService.retrieveRucoms.get(function(data) {
    console.log('Matching rucom registries: ' + JSON.stringify(data));
    $scope.query = '';  
    $scope.content = data;    
    return true;
    });
  };  
  
}]);

angular.module('app').filter('startFrom',function (){
  return function(input, start) {
    if (!input || !input.length) { return; }
      start = +start; //parse to int
      return input.slice(start);
  };
});
