angular.module('app').controller('ProvidersRucomCtrl', ['$scope', '$stateParams', '$window', 'CameraService', 'RucomService', 'ProviderService', 'LocationService', function($scope, $stateParams, $window, CameraService, RucomService, ProviderService, LocationService){
  
  $scope.newProvider = {};  
  $scope.populationCenter = {};
  $scope.currentRucom = {};
  $scope.companyInfo = null;
  $scope.newProvider.company_info = true;
    $scope.rucomIDField = {
    label: 'RUCOM Number',
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

  var prov = {};

  if ($stateParams.rucomId) {    
    RucomService.getRucom.get({id: $stateParams.rucomId}, function(rucom) {      
      console.log(rucom); 
      RucomService.setCurrentRucom(rucom);
      $scope.currentRucom = {
        id: rucom.id,
        num_rucom: rucom.num_rucom,
        rucom_record: rucom.rucom_record,
        provider_type: rucom.provider_type,
        subcontract_number: rucom.subcontract_number,
        rucom_status: rucom.status,
        mineral: rucom.mineral
      };
      console.log('Current rucom: ');
      console.log(rucom);
    });
  }
  
  if($stateParams.rucomId){      
    console.log("$stateParams.rucomId: " + $stateParams.rucomId); 
    RucomService.getRucom.get({id: $stateParams.rucomId}, function(rucom) {
    var prov = {
      // id: provider.id,
      document_number: $scope.newProvider.document_number,
      first_name: $scope.newProvider.first_name,
      last_name: $scope.newProvider.last_name,        
      email: $scope.newProvider.email,
      address: $scope.newProvider.address,
      city: $scope.selectedCity,
      state: $scope.selectedState,
      phone_number: $scope.newProvider.phone_number,
      photo_file: $scope.newProvider.photo_file || ('http://robohash.org/'),
      rucom: {
        id: rucom.id,
        num_rucom: rucom.num_rucom,
        rucom_record: rucom.rucom_record,
        provider_type: rucom.provider_type,
        rucom_status: rucom.status,
        mineral: rucom.mineral
      },
      population_center: {
        id: '',
        name: '',
        population_center: '',
        population_center_code: ''
      }
    };
    if ($scope.newProvider.company_info) {
      prov.company_info = {
        // id: provider.company_info.id,
        nit_number: $scope.companyInfo.nit_number,
        name: $scope.companyInfo.company_info.name,
        legal_representative: $scope.companyInfo.legal_representative,
        id_type_legal_rep: $scope.companyInfo.id_type_legal_rep,
        id_number_legal_rep: $scope.companyInfo.id_number_legal_rep,
        email: $scope.companyInfo.email,
        phone_number: $scope.companyInfo.phone_number
      };
    }

    $scope.newProvider = prov;
    ProviderService.setCurrentProv(prov);

    if(prov.num_rucom) {
      $scope.rucomIDField.label = 'RUCOM Number';
      $scope.rucomIDField.field = 'num_rucom';
    } else if (prov.rucom_record) {
      $scope.rucomIDField.label = 'RUCOM Record';
      $scope.rucomIDField.field = 'rucom_record';
    }

    //$scope.loadProviderLocation($scope.newProvider);

    console.log('provider:' + prov);
    console.log(prov);
    });
  }

  $scope.photo=CameraService.getLastScanImage();
  if($scope.photo){
    $scope.provider.photo_file=CameraService.getLastScanFile();
  }

  LocationService.getStates.query({}, function(states) {
    $scope.states = states;
    console.log('States: ' + JSON.stringify(states));
  });

  $scope.id_type_legal_rep = [    
    { type: 3, name: 'CC' },
    { type: 2, name: 'Cédula de extranjería' }
  ];

  $scope.formTabControl = {
    selectedIndex : 0,
    secondUnlocked : true,
    firstLabel : "Provider info",
    secondLabel : "Company info"
  };

  $scope.formValidateRucom = {    
    rucomValidated : false,    
  };

  $scope.isCompany = function() { 
    if(!$scope.newCompany.status){
      $scope.newCompany.name = $scope.newProvider.name;
      $scope.newProvider.name = '';
      console.log("isCompany: " + $scope.newCompany.name);            
    }else if($scope.newProvider.name === '' && $scope.newCompany.status) {
      $scope.newProvider.name = $scope.newCompany.name;
      $scope.newCompany.name = '';
      console.log("isCompany: " + $scope.newCompany.name);
    }
  };

  $scope.save = function() {
    console.log($scope.newProvider);
    $window.history.back();
  };

  $scope.back = function() {
    $window.history.back();
  };

  $scope.next = function() {
    $scope.formTabControl.selectedIndex = Math.min($scope.formTabControl.selectedIndex + 1, 1) ;
    console.log("type: " + $scope.newProvider);            
  };
  
  $scope.previous = function() {
    $scope.formTabControl.selectedIndex = Math.max($scope.formTabControl.selectedIndex - 1, 0);    
  };

  $scope.create = function(){
    ProviderService.create($scope.provider);
  };

  function createFilterFor(query) {
   var lowercaseQuery = angular.lowercase(query);
   return function filterFn(state) {
     return (state.name.toLowerCase().indexOf(lowercaseQuery) === 0);
   };
  }  

  // Watchers for listen to changes in editable fields
  $scope.$watch('newProvider', 
    function(newVal, oldVal) {
      if (oldVal && newVal !== oldVal) {
        $scope.saveBtnEnabled = true;
      }
  }, true);

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
      $scope.newProvider.population_center.id = population_center.id;
      $scope.newProvider.population_center.name = population_center.name;      
      $scope.newProvider.population_center.population_center_code = population_center.population_center_code;
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
