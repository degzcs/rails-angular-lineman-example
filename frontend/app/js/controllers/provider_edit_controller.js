angular.module('app').controller('ProvidersEditCtrl', ['$scope', '$stateParams', 'ProviderService', 'RucomService', function($scope, $stateParams, ProviderService, RucomService){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  $scope.currentProvider = {};
  $scope.rucomIDField = {
    label: 'RUCOM Number',
    field: 'num_rucom'
  };
  if ($stateParams.providerId) {
    ProviderService.retrieveProviderById.get({providerId: $stateParams.providerId}, function(provider) {
      var prov = {
        id: provider.id,
        document_number: provider.document_number,
        first_name: provider.first_name,
        last_name: provider.last_name,
        address: provider.address,
        email: provider.email,
        phone_number: provider.phone_number,
        photo_file: {
          url: provider.photo_file.url || ('http://robohash.org/' + provider.id)
        },
        rucom: {
          num_rucom: provider.rucom.num_rucom,
          rucom_record: provider.rucom.rucom_record,
          provider_type: provider.rucom.provider_type,
          rucom_status: provider.rucom.status,
          mineral: provider.rucom.mineral
        }
      };
      $scope.currentProvider = prov;
      ProviderService.setCurrentProv(prov);
      if(prov.num_rucom) {
        $scope.rucomIDField.label = 'RUCOM Number';
        $scope.rucomIDField.field = 'num_rucom';
      } else if (prov.rucom_record) {
        $scope.rucomIDField.label = 'RUCOM Record';
        $scope.rucomIDField.field = 'rucom_record';
      }
      console.log('Current provider: ' + prov.id);
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