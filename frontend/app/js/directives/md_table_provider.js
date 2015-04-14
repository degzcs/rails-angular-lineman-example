angular.module('app').directive('mdTableProvider', function () {
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
      currentProvider: '='
    },
    controller: function ($scope, $filter, $location, $window, $state, ProviderService) {
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
      $scope.goToPage = function (pag) {
        $scope.tablePage = pag;
        ProviderService.retrieveProviders.query({per_page: $scope.count, page: (pag+1)}, (function(providers, headers) {
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
      };
      $scope.setCurrentProv = function (provider) {
        //ProviderService.setCurrentProv(provider);
        //$scope.currentProvider = provider;
        console.log('Setting current Provider: ' + JSON.stringify($scope.currentProvider));
        $state.go("edit_provider", {providerId: provider.id});
      };
    },
    //template: angular.element(document.querySelector('#md-table-template')).html()
    templateUrl: 'directives/md-table-provider.html'
  };
});