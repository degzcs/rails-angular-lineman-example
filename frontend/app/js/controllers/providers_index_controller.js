angular.module('app').controller('ProvidersIndexCtrl', ['$scope', 'ProviderService' ,function($scope, ProviderService){
  $scope.toggleSearch = false;
  $scope.queryName = '';
  $scope.queryId = '';
  $scope.queryFocus = '';
  $scope.headers = [
    {
      name:'',
      field:'photo_file',
      alternateField: 'photo_file'
    },{
      name: 'Nombre', 
      field: 'first_name',
      alternateField: 'first_name'
    },{
      name: 'Apellido', 
      field: 'last_name',
      alternateField: 'last_name'
    },{
      name:'Número de Identificación', 
      field: 'document_number',
      alternateField: 'document_number'
    },{
      name: 'Mineral', 
      field: 'mineral',
      alternateField: 'mineral'
    },{
      name: 'Número de RUCOM', 
      field: 'num_rucom',
      alternateField: 'rucom_record'
    },{
      name: 'Estado del RUCOM', 
      field: 'rucom_status',
      alternateField: 'rucom_status'
    },{
      name: 'Tipo de Proveedor', 
      field: 'provider_type',
      alternateField: 'provider_type'
    },{
      name: 'Última Transacción', 
      field: 'last_transaction_date',
      alternateField: 'last_transaction_date'
    }
  ];

  $scope.count = 4;
  $scope.pages = 0;
  ProviderService.retrieveProviders.query({per_page: $scope.count, page: 1}, (function(providers, headers) {
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
    $scope.pages = parseInt(headers().total_pages);
    return $scope.content = content;
  }), function(error) {});
  
  $scope.custom = {first_name: 'bold', last_name: 'bold', document_number:'grey', mineral: 'grey', num_rucom: 'grey', rucom_status:'grey', provider_type: 'grey', last_transaction_date: 'grey'};
  $scope.sortable = ['first_name', 'last_name', 'document_number', 'mineral', 'num_rucom', 'rucom_status', 'provider_type', 'last_transaction_date'];
  $scope.thumbs = 'photo_file';
  $scope.currentProvider = ProviderService.getCurrentProv();

  // Watchers for listen to changes in query fields

  $scope.$watch('queryName', 
    function(newVal, oldVal) {
      if (oldVal && newVal !== oldVal) {
        $scope.queryFocus = 'name';
        ProviderService.retrieveProviders.query({per_page: $scope.count, page: 1, query_name: $scope.queryName}, (function(providers, headers) {
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
          $scope.pages = parseInt(headers().total_pages);
          return $scope.content = content;
        }), function(error) {});
      }
  }, true); // objectEquality = true

  $scope.$watch('queryId', 
    function(newVal, oldVal) {
      if (oldVal && newVal !== oldVal) {
        $scope.queryFocus = 'id';
        ProviderService.retrieveProviders.query({per_page: $scope.count, page: 1, query_id: $scope.queryId}, (function(providers, headers) {
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
          $scope.pages = parseInt(headers().total_pages);
          return $scope.content = content;
        }), function(error) {});
      }
  }, true); // objectEquality = true

    
  // end Watchers
  
}]);

// angular.module('app').filter('startFrom',function (){
//   return function(input, start) {
//     if (!input || !input.length) { return; }
//       start = +start; //parse to int
//       return input.slice(start);
//   };
// });
