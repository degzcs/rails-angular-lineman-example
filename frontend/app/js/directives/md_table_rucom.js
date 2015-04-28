angular.module('app').directive('mdTableRucom', function () {
  return {
    restrict: 'E',
    scope: { 
      headers: '=', 
      content: '=', 
      sortable: '=', 
      filters: '=',
      customClass: '=customClass',      
      count: '=',
      currentRucom: '=',
      type: '='
    },
    controller: function ($scope, $filter, $location, $window, $state, $mdDialog, RucomService, ProviderService, ClientService) {
      var orderBy = $filter('orderBy');
      $scope.tablePage = 0;
      $scope.currentPath = $location.path().substring(1);
      $scope.nbOfPages = function () {
        return $scope.content ? Math.ceil(($scope.content.length) / $scope.count) : 0;
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

      $scope.goToPage = function (page) {
        $scope.tablePage = page;
      };

      $scope.setCurrentRucom = function (rucom) {
        if ($scope.type === 'provider') {
          if (rucom.status === 'Rechazado') {
            var title = 'RUCOM';
            var text = 'No es posible crear un proveedor con un estado de RUCOM \'Rechazado\'';
            $mdDialog.show($mdDialog.alert().title(title).content(text).ok('OK'));
          } else {
           ProviderService.retrieveProviders.query({query_rucomid: rucom.id}, (function(providers, headers) {
              if (providers.length > 0) {
                var title = 'RUCOM';
                var text = 'Ya existe un proveedor asociado a este registro del RUCOM';
                $mdDialog.show($mdDialog.alert().title(title).content(text).ok('OK'));
              } else {
                console.log('setCurrentRucom' + JSON.stringify(rucom));
                RucomService.setCurrentRucom(rucom);        
                console.log(rucom.provider_type);
                var type = $scope.setProviderType(rucom.provider_type);
                console.log('1. Setting current Rucom: ' + rucom.id);        
                $state.go(type, {rucomId: rucom.id});
              }
            }), function(error) {});
         }
        } else if ($scope.type === 'client') {
          if (rucom.status === 'Rechazado') {
            var title = 'RUCOM';
            var text = 'No es posible crear un cliente con un estado de RUCOM \'Rechazado\'';
            $mdDialog.show($mdDialog.alert().title(title).content(text).ok('OK'));
          } else {
            ClientService.retrieveClients.query({query_rucomid: rucom.id}, (function(clients, headers) {
              if (clients.length > 0) {
                var title = 'RUCOM';
                var text = 'Ya existe un cliente asociado a este registro del RUCOM';
                $mdDialog.show($mdDialog.alert().title(title).content(text).ok('OK'));
              } else {
                console.log('setCurrentRucom' + JSON.stringify(rucom));
                RucomService.setCurrentRucom(rucom);                      
                $state.go('create_client', {rucomId: rucom.id});
              }
            }), function(error) {});
          }
        }
      };

      $scope.setProviderType = function (provider_type){
        if (provider_type === 'Barequero'){
          console.log("Type A");
          return "type_1";
        } else if (provider_type === 'Comercializadores' || provider_type === 'Solicitante Legalización De Minería' || provider_type === 'Titular' || provider_type === 'Beneficiario Área Reserva Especial' || provider_type === 'Subcontrato de formalización' || provider_type === 'Consumidor'){
          console.log("Type B");
          return "type_2";
        } else if (provider_type === 'Planta de Beneficio'){
          console.log("Type C");
          return "type_3";
        }
      };
    },
    //template: angular.element(document.querySelector('#md-table-template')).html()
    templateUrl: 'directives/md-table-rucom.html'
  };
});