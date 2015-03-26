angular.module('app').controller('ProvidersIndexCtrl', ['$scope', 'providerService' ,function($scope,providerService){
  $scope.toggleSearch = false;   
  $scope.headers = [
    {
      name:'',
      field:'thumb'
    },{
      name: 'Name', 
      field: 'name'
    },{
      name:'Id', 
      field: 'id'
    },{
      name: 'Mineral', 
      field: 'mineral'
    },{
      name: 'Id RUCOM', 
      field: 'id_rucom'
    },{
      name: 'RUCOM Status', 
      field: 'rucom_status'
    },{
      name: 'Last Transaction', 
      field: 'last_transaction_date'
    }
  ];
  
  providerService.retrieveProviders.query((function(res) {
    return $scope.content = res.list;
  }), function(error) {});
  
  $scope.custom = {name: 'bold', id:'grey', mineral: 'grey', id_rucom: 'grey', rucom_status:'grey', last_transaction_date: 'grey'};
  $scope.sortable = ['name', 'id', 'mineral', 'id_rucom', 'rucom_status', 'last_transaction_date'];
  $scope.thumbs = 'thumb';
  $scope.count = 4;
  $scope.currentProvider = providerService.getCurrentProv();
  
}]);

angular.module('app').filter('startFrom',function (){
  return function(input, start) {
    if (!input || !input.length) { return; }
      start = +start; //parse to int
      return input.slice(start);
  };
});