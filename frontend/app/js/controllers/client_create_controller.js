angular.module('app').controller('ClientsCreateCtrl', ['$scope', '$state', '$stateParams', '$window', '$mdDialog', 'CameraService', 'RucomService', 'ClientService', 'LocationService', function($scope, $state, $stateParams, $window, $mdDialog, CameraService, RucomService, ClientService, LocationService){
  
  $scope.newClient = ClientService.getCurrentClient();
  $scope.populationCenter = {};
  $scope.abortCreate = false;
  $scope.currentRucom = {};
  $scope.companyInfo = {};
  $scope.companyName = "";
  $scope.saveBtnEnabled = false;
  $scope.rucomIDField = {
    label: 'Número de RUCOM',
    field: 'num_rucom'
  };

  $scope.states = [];
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

  var clnt = {};
  $scope.rucomId = $stateParams.rucomId
  
  if($scope.rucomId){
    console.log("$stateParams.rucomId: " + $stateParams.rucomId); 
    RucomService.getRucom.get({id: $stateParams.rucomId}, function(rucom) {
    $scope.companyName = rucom.name;        
    var clnt = {  
      id_document_number: $scope.newClient.id_document_number,
      id_document_type: $scope.newClient.id_document_type,
      first_name: $scope.newClient.first_name? $scope.newClient.first_name : rucom.name,
      last_name: $scope.newClient.last_name,
      client_type: $scope.newClient.client_type,
      phone_number: $scope.newClient.phone_number,
      email: $scope.newClient.email,
      address: $scope.newClient.address,
      company_name: $scope.newClient.company_name || '',
      nit_company_number: $scope.newClient.company_name || '',
      rucom: {
        id: rucom.id,
        num_rucom: rucom.num_rucom,
        rucom_record: rucom.rucom_record,
        provider_type: rucom.provider_type,
        rucom_status: rucom.status,
        mineral: rucom.mineral
      },
      population_center: {
        id: $scope.newClient.population_center ? $scope.newClient.population_center.id : '',
        name: $scope.newClient.population_center ? $scope.newClient.population_center.name : '',
        population_center_code: $scope.newClient.population_center ? $scope.newClient.population_center.name : ''
      }
    };    

    console.log(clnt.rucom.num_rucom);
    console.log(clnt.rucom.rucom_record);
    if(clnt.rucom.num_rucom) {
      $scope.rucomIDField.label = 'Número deRUCOM';
      $scope.rucomIDField.field = 'num_rucom';
    } else if (clnt.rucom.rucom_record) {
      $scope.rucomIDField.label = 'Número de Expediente';
      $scope.rucomIDField.field = 'rucom_record';
    }

    $scope.newClient = clnt;
    $scope.currentRucom = clnt.rucom;
    ClientService.setCurrentClient(clnt);
    if ($scope.newClient.population_center.id !== '') {
      $scope.loadClientLocation($scope.newClient);
    }

    console.log('client:' + clnt);
    console.log(clnt);
    });
  }

  LocationService.getStates.query({}, function(states) {
    $scope.states = states;
    console.log('States: ' + JSON.stringify(states));
  });

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

  $scope.back = function() {
    ClientService.setCurrentClient({});
    $window.history.back();
  };

  function createFilterFor(query) {
   var lowercaseQuery = angular.lowercase(query);
   return function filterFn(state) {
     return (state.name.toLowerCase().indexOf(lowercaseQuery) === 0);
   };
  }  

  $scope.createClient = function(){  
    console.log($scope.newClient);
    $resource = ClientService.create($scope.newClient);
    if($resource) {
      $resource .save($scope.newClient);
      //$scope.newClient = {};
      ClientService.setCurrentClient({});
      $scope.infoAlert('Crear nuevo cliente', 'El registro ha sido exitoso', false);
      $scope.abortCreate = true;
    } else {
      $scope.infoAlert('Crear nuevo cliente', 'Algo salió mal. Por favor asegurese de diligenciar todos los campos requeridos.', true);
    }
  };

  $scope.infoAlert = function(title, content, error) {
   $mdDialog.show($mdDialog.alert().title(title).content(content).ok('OK'))
   .finally(function() {
      if (!error) {
        $window.history.back();
      }
    });
  };

  // Watchers for listen to changes in editable fields
  $scope.$watch('newClient', 
   function(newVal, oldVal) {
     if (oldVal && newVal !== oldVal) {
       $scope.saveBtnEnabled = true;
     }
     ClientService.setCurrentClient($scope.newClient);
  }, true);

  // end watchers

  // It listens to state changes
  $scope.$on('$stateChangeStart', 
    function(event, toState, toParams, fromState, fromParams){ 
      // console.log('Changing state from: ' + JSON.stringify(fromState) + ' to: ' + JSON.stringify(toState));
      // console.log('Params state from: ' + JSON.stringify(fromParams) + ' to: ' + JSON.stringify(toParams));
      if (toState.url !== "/scanner") {
        if (!$scope.abortCreate) {
          event.preventDefault();
          var confirm;
          confirm = $mdDialog.confirm().title('Cancelar la creación del nuevo cliente').content('¿Desea cancelar la operación actual? Los datos que no haya guardado se perderán').ariaLabel('Lucky day').ok('Aceptar').cancel('Cancelar').targetEvent(event);
          return $mdDialog.show(confirm).then((function() {
            $scope.abortCreate = true;
            ClientService.setCurrentClient({});
            console.log('client create: dismissing operation');
            $state.go(toState, toParams);          
          }), function() {
            
          });
        }
      }
  });

  // end state change listener

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
      $scope.newClient.population_center = {};
      $scope.newClient.population_center.id = population_center.id;
      $scope.newClient.population_center.name = population_center.name;      
      $scope.newClient.population_center.population_center_code = population_center.population_center_code;
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

}]);
