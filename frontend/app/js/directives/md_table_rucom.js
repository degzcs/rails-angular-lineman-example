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
        //$scope.currentProvider = provider;
        console.log('1. Setting current Rucom: ' + rucom.idrucom);        
        $state.go("create_provider", {rucomId: rucom.idrucom});
      };
    },
    //template: angular.element(document.querySelector('#md-table-template')).html()
    templateUrl: 'directives/md-table-rucom.html'
  };
});