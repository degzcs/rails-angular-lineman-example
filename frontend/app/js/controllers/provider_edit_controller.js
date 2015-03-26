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

  $scope.data = {
    selectedIndex : 0,
    secondLocked : false,
    secondLabel : "Complementary info"
  };
  $scope.next = function() {
    $scope.data.selectedIndex = Math.min($scope.data.selectedIndex + 1, 1) ;
  };
  $scope.previous = function() {
    $scope.data.selectedIndex = Math.max($scope.data.selectedIndex - 1, 0);
  };

}]);