angular.module('app').controller('ProvidersEditCtrl', ['$scope', '$stateParams', 'providerService', function($scope, $stateParams, providerService){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  $scope.currentProvider = {};
  if ($stateParams.providerId) {
    providerService.retrieveProviders.get({providerId: $stateParams.providerId}, function(data) {
      $scope.currentProvider = data.provider;
      providerService.setCurrentProv(data.provider);
      console.log('Current provider: ' + data.provider.id);
    });
  }
}]);

angular.module('app').filter('startFrom',function (){
  return function(input, start) {
    if (!input || !input.length) { return; }
      start = +start; //parse to int
      return input.slice(start);
  };
});