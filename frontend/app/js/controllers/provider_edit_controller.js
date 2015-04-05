angular.module('app').controller('ProvidersEditCtrl', ['$scope', '$stateParams', 'ProviderService', 'RucomService', 'LocationService', function($scope, $stateParams, ProviderService, RucomService, LocationService){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  $scope.currentProvider = null;
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
        },
        population_center: {
          id: provider.population_center.id,
          name: provider.population_center.name,
          population_center_code: provider.population_center.name,
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
      $scope.loadProviderLocation($scope.currentProvider);
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

  $scope.loadProviderLocation = function (provider) {
    if(provider) {
      LocationService.getPopulationCenterById.get({populationCenterId: provider.population_center.id}, function(populationCenter) {
        $scope.selectedPopulationCenter = populationCenter;
        $scope.searchPopulationCenter = populationCenter.name;
        $scope.populationCenterDisabled = false;
        console.log('Current Population Center: ' + JSON.stringify(populationCenter));
        
        currentCity = null;
        LocationService.getCityById.get({cityId: populationCenter.city_id}, function(city) {
          currentCity = city;
          $scope.selectedCity = currentCity;
          $scope.searchCity = currentCity.name;
          $scope.cityDisabled = false;
          console.log('currentCity: ' + JSON.stringify(city));
          LocationService.getPopulationCentersFromCity.query({cityId: currentCity.id}, function(population_centers) {
            $scope.population_centers = population_centers;
            console.log('Population Centers from ' + currentCity.name + ': ' + JSON.stringify(population_centers));
          });

          currentState = null;
          LocationService.getStateById.get({stateId: currentCity.state_id}, function(state) {
            currentState = state;
            $scope.selectedState = currentState;
            $scope.searchState = currentState.name;
            console.log('currentState: ' + JSON.stringify(state));
            LocationService.getCitiesFromState.query({stateId: currentState.id}, function(cities) {
              $scope.cities = cities;
              console.log('Cities from ' + currentState.name + ': ' + JSON.stringify(cities));
            });
          });
        });
      });
    }
  };

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
    if(state){
      console.log('State changed to ' + JSON.stringify(state));
      LocationService.getCitiesFromState.query({stateId: state.id}, function(cities) {
        $scope.cities = cities;
        console.log('Cities from ' + state.name + ': ' + JSON.stringify(cities));
      });
      $scope.cityDisabled = false;
    } else {
      console.log('State changed to none');
      flushFields('state');
    }
  };

  $scope.selectedCityChange = function(city) {
    if(city){
      console.log('City changed to ' + JSON.stringify(city));
      LocationService.getPopulationCentersFromCity.query({cityId: city.id}, function(population_centers) {
        $scope.population_centers = population_centers;
        console.log('Population Centers from ' + city.name + ': ' + JSON.stringify(population_centers));
      });
      $scope.populationCenterDisabled = false;
    } else {
      console.log('City changed to none');
      flushFields('city');
    }
  };

  $scope.selectedPopulationCenterChange = function(population_center) {
    if(population_center){
      console.log('Population Center changed to ' + JSON.stringify(population_center));
    } else {
      console.log('Population Center changed to none');
    }
  };

  $scope.searchTextStateChange = function(text) {
    console.log('Text changed to ' + text);
    if (text==='') {
      flushFields('state');
    }
  };

  $scope.searchTextCityChange = function(text) {
    console.log('Text changed to ' + text);
    if (text==='') {
      flushFields('city');
    }
  };

  $scope.searchTextPopulationCenterChange = function(text) {
    console.log('Text changed to ' + text);
  };

  function createFilterFor(query) {
    var lowercaseQuery = angular.lowercase(query);
    return function filterFn(state) {
      return (state.name.toLowerCase().indexOf(lowercaseQuery) === 0);
    };
  }

  function flushFields(level) {
    $scope.population_centers = [];
    $scope.selectedPopulationCenter = null;
    $scope.searchPopulationCenter = null;
    $scope.populationCenterDisabled = true;
    switch(level) {
      case 'state':
        $scope.cities = [];
        $scope.selectedState = null;
        $scope.selectedCity = null;
        $scope.searchState = null;
        $scope.searchCity = null;
        $scope.cityDisabled = true;
        break;
      case 'city':
        $scope.searchCity = null;
        $scope.selectedCity = null;
        break;
      default:
        break;
    }
    
  }

  // end Autocomplete management

  $scope.formTabControl = {
    selectedIndex : 0,
    secondUnlocked : true,
    firstLabel : "Basic Info",
    secondLabel : "Company Info"
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