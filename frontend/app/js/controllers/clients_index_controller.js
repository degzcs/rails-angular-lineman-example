angular.module('app').controller('ClientsIndexCtrl', ['$scope', 'ClientService' ,function($scope, ClientService){
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
      field: 'id_document_number',
      alternateField: 'id_document_number'
    },{
      name: 'Mineral', 
      field: 'mineral',
      alternateField: 'mineral'
    },{
      name: 'Número RUCOM', 
      field: 'num_rucom',
      alternateField: 'rucom_record'
    },{
      name: 'Tipo de Cliente', 
      field: 'client_type',
      alternateField: 'client_type'
    },{
      name: 'Última Transacción', 
      field: 'last_transaction_date',
      alternateField: 'last_transaction_date'
    }
  ];

  $scope.count = 4;
  $scope.pages = 0;
  ClientService.retrieveClients.query({per_page: $scope.count, page: 1}, (function(clients, headers) {
    var content = [];
    for (var i=0; i<clients.length; i++) {
      var client = {
        id: clients[i].id,
        id_document_number: clients[i].id_document_number,
        id_document_type: clients[i].id_document_type,
        first_name: clients[i].first_name,
        last_name: clients[i].last_name,
        address: clients[i].address,
        email: clients[i].email,
        phone_number: clients[i].phone_number,
        client_type: clients[i].client_type,
        mineral: clients[i].rucom.mineral
      };

      if(clients[i].rucom) {
        client.num_rucom = clients[i].rucom.num_rucom;
      }
      content.push(client);
    }
    $scope.pages = parseInt(headers().total_pages);
    return $scope.content = content;
  }), function(error) {});
  
  $scope.custom = {first_name: 'bold', last_name: 'bold', id_document_number:'grey', mineral: 'grey', num_rucom: 'grey', client_type: 'grey', last_transaction_date: 'grey'};
  $scope.sortable = ['first_name', 'last_name', 'id_document_number', 'mineral', 'num_rucom', 'client_type', 'last_transaction_date'];
  $scope.thumbs = 'photo_file';
  $scope.currentClient = ClientService.getCurrentClient();

  // Watchers for listen to changes in query fields

  $scope.$watch('queryName', 
    function(newVal, oldVal) {
      if (oldVal && newVal !== oldVal) {
        $scope.queryFocus = 'name';
        ClientService.retrieveClients.query({per_page: $scope.count, page: 1, query_name: $scope.queryName}, (function(clients, headers) {
          var content = [];
          for (var i=0; i<clients.length; i++) {
            var client = {
              id: clients[i].id,
              id_document_number: clients[i].id_document_number,
              id_document_type: clients[i].id_document_type,
              first_name: clients[i].first_name,
              last_name: clients[i].last_name,
              address: clients[i].address,
              email: clients[i].email,
              phone_number: clients[i].phone_number,
              client_type: clients[i].client_type,
              mineral: clients[i].rucom.mineral
            };

            if(clients[i].rucom) {
              client.num_rucom = clients[i].rucom.num_rucom;
            }
            content.push(client);
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
        ClientService.retrieveClients.query({per_page: $scope.count, page: 1, query_id: $scope.queryId}, (function(clients, headers) {
          var content = [];
          for (var i=0; i<clients.length; i++) {
            var client = {
              id: clients[i].id,
              id_document_number: clients[i].id_document_number,
              id_document_type: clients[i].id_document_type,
              first_name: clients[i].first_name,
              last_name: clients[i].last_name,
              address: clients[i].address,
              email: clients[i].email,
              phone_number: clients[i].phone_number,
              client_type: clients[i].client_type,
              mineral: clients[i].rucom.mineral
            };

            if(clients[i].rucom) {
              client.num_rucom = clients[i].rucom.num_rucom;
            }
            content.push(client);
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
