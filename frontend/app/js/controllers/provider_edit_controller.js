angular.module('app').controller('ProvidersEditCtrl', ['$scope', '$stateParams', 'ProviderService', 'RucomService', function($scope, $stateParams, ProviderService, RucomService){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  $scope.currentProvider = {};
  if ($stateParams.providerId) {
    ProviderService.retrieveProviderById.get({providerId: $stateParams.providerId}, function(provider) {
      $scope.currentProvider = provider;
      ProviderService.setCurrentProv(provider);
      console.log('Current provider: ' + provider.id);
    });
  }

  $scope.matchingRucoms = [];
  RucomService.retrieveRucoms.query({rucom_query: 'ARE_PLU-08141'}, function(rucoms) {
    $scope.matchingRucoms = rucoms;
    console.log('Matching rucom registries: ' + JSON.stringify(rucoms));
  });

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