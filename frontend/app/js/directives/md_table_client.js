angular.module('app').directive('mdTableClient', function () {
  return {
    restrict: 'E',
    scope: { 
      headers: '=', 
      content: '=',
      pages: '=',
      sortable: '=', 
      filters: '=',
      customClass: '=customClass',
      thumbs:'=', 
      count: '=',
      currentClient: '=',
      queryName: '=',
      queryId: '=',
      queryFocus: '='
    },
    controller: function ($scope, $filter, $location, $window, $state, ClientService) {
      var orderBy = $filter('orderBy');
      $scope.tablePage = 0;
      $scope.currentPath = $location.path().substring(1);
      $scope.nbOfPages = function () {
        return $scope.pages || 0;
      };
      $scope.handleSort = function (field) {
        if ($scope.sortable.indexOf(field) > -1) { return true; } else { return false; }
      };
      $scope.order = function(predicate, reverse) {
        $scope.content = orderBy($scope.content, predicate, reverse);
        $scope.predicate = predicate;
      };
      $scope.order($scope.sortable[0],false);
      $scope.getNumber = function (num) {
      	return new Array(num);
      };
      $scope.goToPage = function (pag, queryFocus) {
        $scope.tablePage = pag;
        params = {per_page: $scope.count, page: (pag+1)};
        if (queryFocus && queryFocus === 'name') {
          params.query_name = $scope.queryName;
        } else if (queryFocus && queryFocus === 'id') {
          params.query_id = $scope.queryId;
        }
        ClientService.retrieveClients.query(params, (function(clients, headers) {
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
      };
      $scope.setCurrentClient = function (client) {
        //ClientService.setCurrentClient(client);
        //$scope.currentClient = client;
        console.log('Setting current Client: ' + JSON.stringify($scope.currentClient));
        $state.go("edit_client", {clientId: client.id});
      };
    },
    //template: angular.element(document.querySelector('#md-table-template')).html()
    templateUrl: 'directives/md-table-client.html'
  };
});