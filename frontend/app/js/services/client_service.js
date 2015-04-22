angular.module('app').factory('ClientService', function($resource,$upload) {

    var currentClient = {};
    var clients = [];

    var setCurrentClient = function(client) {
        currentClient = client;
    };

    var retrieveClients = $resource('/api/v1/clients.json', {per_page: '@per_page', page: '@page', query_id: '@query_id'});

    var retrieveClientById = $resource('/api/v1/clients/:clientId.json', {clientId:'@clientId'});

    var getCurrentClient = function() {
        return currentClient;
    };

    var create = function(client) {      
      return $resource('/api/v1/clients/',
       {},{
          'save': {
            method: 'POST',
            params: client.rucom ? {
              "client[first_name]":client.first_name,
              "client[last_name]":client.last_name,
              "client[id_document_number]":client.id_document_number,
              "client[id_document_type]":client.id_document_type,
              "client[client_type]":client.client_type,
              "client[email]":client.email,
              "client[phone_number]":client.phone_number,
              "client[address]":client.address,
              "client[company_name]":client.company_name,
              "client[nit_company_number]":client.nit_company_number,
              "client[rucom_id]":client.rucom.id,
              "client[population_center_id]":client.population_center.id
            }
            :
            {
              "client[first_name]":client.first_name,
              "client[last_name]":client.last_name,
              "client[id_document_number]":client.id_document_number,
              "client[id_document_type]":client.id_document_type,
              "client[client_type]":client.client_type,
              "client[email]":client.email,
              "client[phone_number]":client.phone_number,
              "client[address]":client.address,
              "client[company_name]":client.company_name,
              "client[nit_company_number]":client.nit_company_number,
              "client[population_center_id]":client.population_center.id
            }
          }
      });  
    };
  //Can call edit like so:
  //$resource = ClientService.edit($scope.currentClient);
  //  if($resource){
   //   $resource .update({ id:$scope.currentClient.id }, $scope.currentClient);
   // }
      var edit = function(client) {
        return $resource('/api/v1/clients/:id',
          {id:'@id'},{
            'update': {
               method: 'PUT',
               params: {
                "client[first_name]":client.first_name,
                "client[last_name]":client.last_name,
                "client[id_document_number]":client.id_document_number,
                "client[id_document_type]":client.id_document_type,
                "client[client_type]":client.client_type,
                "client[email]":client.email,
                "client[phone_number]":client.phone_number,
                "client[address]":client.address,
                "client[company_name]":client.company_name,
                "client[nit_company_number]":client.nit_company_number,
                "client[rucom_id]":client.rucom ? client.rucom.id : '',
                "client[population_center_id]":client.population_center.id
              }
            }
        });
    };
    
    return {
        getCurrentClient: getCurrentClient,
        setCurrentClient: setCurrentClient,
        retrieveClients: retrieveClients,
        create : create,
        edit : edit,
        retrieveClientById: retrieveClientById
    };
});