angular.module('app').controller('ProvidersEditCtrl', ['$scope', '$stateParams', 'ProviderService', function($scope, $stateParams, ProviderService){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  $scope.currentProvider = {};
  if ($stateParams.providerId) {
    ProviderService.retrieveProviders.get({providerId: $stateParams.providerId}, function(data) {
      $scope.currentProvider = data.provider;
      ProviderService.setCurrentProv(data.provider);
      console.log('Current provider: ' + data.provider.id);
    });
  }

  $scope.formTabControl = {
    selectedIndex : 0,
    secondUnlocked : true,
    firstLabel : "Basic info",
    secondLabel : "Complementary info"
  };
  
  $scope.next = function() {
    $scope.formTabControl.selectedIndex = Math.min($scope.formTabControl.selectedIndex + 1, 1) ;
  };
  $scope.previous = function() {
    $scope.formTabControl.selectedIndex = Math.max($scope.formTabControl.selectedIndex - 1, 0);
  };

}]);