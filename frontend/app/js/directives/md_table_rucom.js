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
      currentRucom: '='
    },
    controller: function ($scope, $filter, $location, $window, $state, RucomService) {
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
        RucomService.setCurrentRucom(rucom);        
        console.log(rucom.provider_type);
        var type = $scope.setProviderType(rucom.provider_type);
        console.log('1. Setting current Rucom: ' + rucom.id);        
        $state.go(type, {rucomId: rucom.id});
      };

      $scope.setProviderType = function (provider_type){
        if (provider_type === 'Comercializador' || provider_type === 'Barequero' || provider_type === 'Consumidor'){
          console.log("Type A");
          return "type_1";
        } else if (provider_type === 'Solicitante Legalización De Minería' || provider_type === 'Titular' || provider_type === 'Beneficiario Área Reserva Especial' || provider_type === 'Subcontrato de formalización'){
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