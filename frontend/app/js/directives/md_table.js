angular.module('app').directive('mdTable', function () {
  return {
    restrict: 'E',
    scope: { 
      headers: '=', 
      content: '=', 
      sortable: '=', 
      filters: '=',
      customClass: '=customClass',
      thumbs:'=', 
      count: '=',
      currentProvider: '='
    },
    controller: function ($scope, $filter, $location, $window, $state, providerService) {
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
      $scope.setCurrentProv = function (provider) {
        providerService.setCurrentProv(provider);
        //$scope.currentProvider = provider;
        console.log('Setting current Provider: ' + JSON.stringify($scope.currentProvider));
        $state.go("edit_provider", {providerId: provider.id});
      };
    },
    //template: angular.element(document.querySelector('#md-table-template')).html()
    templateUrl: 'directives/md-table.html'
  };
});