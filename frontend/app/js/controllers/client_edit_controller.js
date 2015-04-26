angular.module('app').controller('ClientsEditCtrl', ['$scope', '$stateParams', '$window', 'ClientService', 'RucomService', 'LocationService', function($scope, $stateParams, $window, ClientService, RucomService, LocationService){
  //$scope.currentClient = clientService.getCurrentProv() ? ;
  $scope.currentClient = null;
  $scope.companyInfo = null;
  $scope.saveBtnEnabled = false;
  $scope.rucomIDField = {
    label: 'Número de RUCOM',
    field: 'num_rucom'
  };
  
  if ($stateParams.clientId) {
    ClientService.retrieveClientById.get({clientId: $stateParams.clientId}, function(client) {
      var clnt = {
        id: client.id,
        id_document_number: client.id_document_number,
        id_document_type: client.id_document_type,
        first_name: client.first_name,
        last_name: client.last_name,
        address: client.address,
        email: client.email,
        phone_number: client.phone_number,
        client_type: client.client_type,
        rucom: {
          num_rucom: client.rucom.num_rucom,
          rucom_record: client.rucom.rucom_record,
          provider_type: client.rucom.provider_type,
          rucom_status: client.rucom.status,
          mineral: client.rucom.mineral
        },
        population_center: {
          id: client.population_center.id,
          name: client.population_center.name,
          population_center_code: client.population_center.population_center_code,
        },
        company_name: client.company_name,
        nit_company_number: client.nit_company_number
      };
      
      $scope.currentClient = clnt;
      //ClientService.setCurrentProv(prov);
      if(clnt.rucom.num_rucom) {
        $scope.rucomIDField.label = 'Número de RUCOM';
        $scope.rucomIDField.field = 'num_rucom';
      } else if (clnt.rucom.rucom_record) {
        $scope.rucomIDField.label = 'Número de Expediente';
        $scope.rucomIDField.field = 'rucom_record';
      }
      console.log('Current client: ' + clnt.id);
      $scope.loadClientLocation($scope.currentClient);
    });
  }

  // Watchers for listen to changes in editable fields

  $scope.$watch('currentClient', 
    function(newVal, oldVal) {
      if (oldVal && newVal !== oldVal) {
        $scope.saveBtnEnabled = true;
      }
  }, true); // objectEquality = true
    
  // end Watchers

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

  $scope.loadClientLocation = function (client) {
    if(client) {
      LocationService.getPopulationCenterById.get({populationCenterId: client.population_center.id}, function(populationCenter) {
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
      $scope.currentClient.population_center.id = population_center.id;
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
    firstLabel : "Información Básica",
    secondLabel : "Información de la Compañía"
  };

  $scope.save = function() {
    //PUT Request:
    $resource = ClientService.edit($scope.currentClient);
    if($resource){
      $resource.update({ id:$scope.currentClient.id }, $scope.currentClient);
    }
    $window.history.back();
  };

  $scope.back = function() {
    $window.history.back();
  };

  $scope.next = function() {
    $scope.formTabControl.selectedIndex = Math.min($scope.formTabControl.selectedIndex + 1, 1) ;
  };

  $scope.previous = function() {
    $scope.formTabControl.selectedIndex = Math.max($scope.formTabControl.selectedIndex - 1, 0);
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

}]);