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
      queryName: '=',
      queryId: '=',
      queryFocus: '='
    },
    controller: function ($scope, $filter, $location, $window, $state, ProviderService,ExternalUser,$mdDialog) {
      var orderBy = $filter('orderBy');
      $scope.tablePage = 0;
      $scope.currentPath = $location.path().substring(1);
      
      format_index_data = function(data){
        var content = [];
        for (var i=0; i<data.length; i++) {
          var prov = {
            id: data[i].id,
            document_number: data[i].document_number,
            first_name: data[i].first_name,
            last_name: data[i].last_name,
            address: data[i].address,
            email: data[i].email,
            phone_number: data[i].phone_number,
            photo_file: data[i].photo_file || ('http://robohash.org/' + data[i].id),
            num_rucom: data[i].rucom.num_rucom,
            rucom_record: data[i].rucom.rucom_record,
            provider_type: data[i].rucom.provider_type,
            rucom_status: data[i].rucom.status,
            mineral: data[i].rucom.mineral
            };
          content.push(prov);
        }
        return content;
      }

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
        if (queryFocus && queryFocus === 'name') {
          var external_users_petition = ExternalUser.query_by_name($scope.queryName,$scope.count,pag+1);
        } else if (queryFocus && queryFocus === 'id') {
          var external_users_petition = ExternalUser.query_by_name($scope.queryId,$scope.count,pag+1);
        } else{
          var external_users_petition = ExternalUser.all($scope.count,pag+1);
        }
        if(external_users_petition){
          external_users_petition.success(function(data, status ,headers){
            $mdDialog.cancel();
            $scope.content = format_index_data(data);
            $scope.pages = parseInt(headers().total_pages);
          });
        }
      };
      $scope.setCurrentProv = function (external_user) {
        //ProviderService.setCurrentProv(provider);
        //$scope.currentProvider = provider;
        //console.log('Setting current Provider: ' + JSON.stringify($scope.currentProvider));
        $state.go("show_external_user", {id: external_user.id});
      };
    },
    //template: angular.element(document.querySelector('#md-table-template')).html()
    templateUrl: 'directives/md-table-provider.html'
  };
});