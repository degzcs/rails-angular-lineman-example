angular.module('app').controller('ProvidersIndexCtrl', ['$scope', 'ProviderService' ,function($scope, ProviderService){
  $scope.toggleSearch = false;   
  $scope.headers = [
    {
      name:'',
      field:'thumb',
      alternateField: 'thumb'
    },{
      name: 'Name', 
      field: 'name',
      alternateField: 'name'
    },{
      name:'Id', 
      field: 'id',
      alternateField: 'id'
    },{
      name: 'Mineral', 
      field: 'mineral',
      alternateField: 'mineral'
    },{
      name: 'RUCOM Number', 
      field: 'num_rucom',
      alternateField: 'rucom_record'
    },{
      name: 'RUCOM Status', 
      field: 'rucom_status',
      alternateField: 'rucom_status'
    },{
      name: 'Provider Type', 
      field: 'provider_type',
      alternateField: 'provider_type'
    },{
      name: 'Last Transaction', 
      field: 'last_transaction_date',
      alternateField: 'last_transaction_date'
    }
  ];
  //Cambiar get por query antes de subir...
  ProviderService.retrieveProviders.get((function(res) {
    return $scope.content = res.list;
  }), function(error) {});
  
  $scope.custom = {name: 'bold', id:'grey', mineral: 'grey', num_rucom: 'grey', rucom_status:'grey', provider_type: 'grey', last_transaction_date: 'grey'};
  $scope.sortable = ['name', 'id', 'mineral', 'num_rucom', 'rucom_status', 'provider_type', 'last_transaction_date'];
  $scope.thumbs = 'thumb';
  $scope.count = 4;
  $scope.currentProvider = ProviderService.getCurrentProv();
  
}]);

angular.module('app').filter('startFrom',function (){
  return function(input, start) {
    if (!input || !input.length) { return; }
      start = +start; //parse to int
      return input.slice(start);
  };
});