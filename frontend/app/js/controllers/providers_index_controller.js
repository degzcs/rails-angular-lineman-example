angular.module('app').controller('ProvidersIndexCtrl', ['$scope', 'ProviderService' ,function($scope, ProviderService){
  $scope.toggleSearch = false;   
  $scope.headers = [
    {
      name:'',
      field:'photo_file',
      alternateField: 'photo_file'
    },{
      name: 'First Name', 
      field: 'first_name',
      alternateField: 'first_name'
    },{
      name: 'Last Name', 
      field: 'last_name',
      alternateField: 'last_name'
    },{
      name:'ID Number', 
      field: 'document_number',
      alternateField: 'document_number'
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
  
  ProviderService.retrieveProviders.query((function(providers) {
    var content = [];
    for (var i=0; i<providers.length; i++) {
      var prov = {
        id: providers[i].id,
        document_number: providers[i].document_number,
        first_name: providers[i].first_name,
        last_name: providers[i].last_name,
        address: providers[i].address,
        email: providers[i].email,
        phone_number: providers[i].phone_number,
        photo_file: providers[i].photo_file || ('http://robohash.org/' + providers[i].id),
        num_rucom: providers[i].rucom.num_rucom,
        rucom_record: providers[i].rucom.rucom_record,
        provider_type: providers[i].rucom.provider_type,
        rucom_status: providers[i].rucom.status,
        mineral: providers[i].rucom.mineral
      };
      content.push(prov);
    }
    return $scope.content = content;
  }), function(error) {});
  
  $scope.custom = {first_name: 'bold', last_name: 'bold', document_number:'grey', mineral: 'grey', num_rucom: 'grey', rucom_status:'grey', provider_type: 'grey', last_transaction_date: 'grey'};
  $scope.sortable = ['first_name', 'last_name', 'document_number', 'mineral', 'num_rucom', 'rucom_status', 'provider_type', 'last_transaction_date'];
  $scope.thumbs = 'photo_file';
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