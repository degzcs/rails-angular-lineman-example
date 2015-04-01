angular.module('app').controller('ProvidersEditCtrl', ['$scope', '$stateParams', 'providerService', 'rucomService', function($scope, $stateParams, providerService, rucomService){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  $scope.currentProvider = {};
  if ($stateParams.providerId) {
    providerService.retrieveProviders.get({providerId: $stateParams.providerId}, function(data) {
      $scope.currentProvider = data.provider;
      providerService.setCurrentProv(data.provider);
      console.log('Current provider: ' + data.provider.id);
    });
  }

  $scope.matchingRucoms = [];
  rucomService.retrieveRucoms.get({rucom_attr: 'ARE_PLU-08141'}, function(data) {
    $scope.matchingRucoms = data.result;
    console.log('Matching rucom registries: ' + JSON.stringify(data.result));
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