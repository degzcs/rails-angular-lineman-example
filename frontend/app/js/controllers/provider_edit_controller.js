angular.module('app').controller('ProvidersEditCtrl', ['$scope', '$stateParams', 'ProviderService', 'RucomService', 'LocationService', function($scope, $stateParams, ProviderService, RucomService, LocationService){
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

  // Autocomplete for State, City and Population Center fields

  $scope.states = [];
  LocationService.getStates.query({}, function(states) {
    $scope.states = states;
    console.log('States: ' + JSON.stringify(states));
  });
  $scope.cities = [];
  $scope.population_centers = [];
  $scope.selectedState = null;
  $scope.selectedCity = null;
  $scope.selectedPopulationCenter = null;
  $scope.searchState = null;
  $scope.searchCity = null;
  $scope.searchPopulationCenter = null;
  $scope.cityDisabled = true;
  $scope.populationCenterDisabled = true;

  $scope.stateSearch = function(query) {
    var results = query ? $scope.states.filter( createFilterFor(query) ) : [];
    return results;
  };

  $scope.citySearch = function(query) {
    var results = query ? $scope.cities.filter( createFilterFor(query) ) : [];
    return results;
  };

  $scope.populationCenterSearch = function(query) {
    var results = query ? $scope.population_centers.filter( createFilterFor(query) ) : [];
    return results;
  };

  $scope.selectedStateChange = function(state) {
    console.log('State changed to ' + JSON.stringify(state));
    LocationService.getCitiesFromState.query({stateId: state.id}, function(cities) {
      $scope.cities = cities;
      console.log('Cities from ' + state.name + ': ' + JSON.stringify(cities));
    });
    $scope.cityDisabled = false;
  };

  $scope.selectedCityChange = function(city) {
    console.log('City changed to ' + JSON.stringify(city));
    LocationService.getPopulationCentersFromCity.query({cityId: city.id}, function(population_centers) {
      $scope.population_centers = population_centers;
      console.log('Population Centers from ' + city.name + ': ' + JSON.stringify(population_centers));
    });
    $scope.populationCenterDisabled = false;
  };

  $scope.selectedPopulationCenterChange = function(population_center) {
    console.log('Population Center changed to ' + JSON.stringify(population_center));
  };

  $scope.searchTextChange = function(text) {
    console.log('Text changed to ' + text);
  };

  function createFilterFor(query) {
    var lowercaseQuery = angular.lowercase(query);
    return function filterFn(state) {
      return (state.name.toLowerCase().indexOf(lowercaseQuery) === 0);
    };
  }

  $scope.formTabControl = {
    selectedIndex : 0,
    secondUnlocked : true,
    firstLabel : "Basic info",
    secondLabel : "Complementary info"
  };

  // $scope.matchingRucoms = [];
  // RucomService.retrieveRucoms.query({rucom_query: 'ARE_PLU-08141'}, function(rucoms) {
  //   $scope.matchingRucoms = rucoms;
  //   console.log('Matching rucom registries: ' + JSON.stringify(rucoms));
  // });
  // LocationService.getStates.query({}, function(states) {
  //   $scope.states = states;
  //   console.log('States: ' + JSON.stringify(states));
  // });
  // LocationService.getCitiesFromState.query({stateId: '61'}, function(cities) {
  //   $scope.cities = cities;
  //   console.log('Cities from Delaware: ' + JSON.stringify(cities));
  // });
  // LocationService.getPopulationCentersFromCity.query({cityId: '625'}, function(population_centers) {
  //   $scope.population_centers = population_centers;
  //   console.log('Population Centers from Duncanhaven: ' + JSON.stringify(population_centers));
  // });

  $scope.next = function() {
    $scope.formTabControl.selectedIndex = Math.min($scope.formTabControl.selectedIndex + 1, 1) ;
  };

  $scope.previous = function() {
    $scope.formTabControl.selectedIndex = Math.max($scope.formTabControl.selectedIndex - 1, 0);
  };

}]);