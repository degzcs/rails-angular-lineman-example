angular.module('app').controller('ProvidersRucomCtrl', ['$scope', '$state', '$stateParams', '$window', '$mdDialog', 'CameraService', 'RucomService', 'ProviderService', 'LocationService', 'ScannerService', function($scope, $state, $stateParams, $window, $mdDialog, CameraService, RucomService, ProviderService, LocationService,ScannerService){

  $scope.newProvider = ProviderService.getCurrentProv();
  $scope.populationCenter = {};
  $scope.abortCreate = false;
  $scope.currentRucom = {};
  $scope.companyInfo = {};
  $scope.companyName = "";
  $scope.newProvider.has_company = $scope.newProvider.has_company || false;
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

  var prov = {};

  $scope.rucomId = $stateParams.rucomId;

  if($scope.rucomId){
    console.log("$scope.rucomId: " + $scope.rucomId);
    RucomService.getRucom.get({id: $scope.rucomId}, function(rucom) {
    $scope.companyName = rucom.name;
    prov = {
      document_number: $scope.newProvider.document_number,
      first_name: $scope.newProvider.first_name? $scope.newProvider.first_name : rucom.name,
      last_name: $scope.newProvider.last_name,
      email: $scope.newProvider.email,
      address: $scope.newProvider.address,
      city: $scope.newProvider.city || '',
      state: $scope.newProvider.state || '',
      phone_number: $scope.newProvider.phone_number,
      photo_file: $scope.newProvider.photo_file || '',
      rucom: {
        id: rucom.id,
        num_rucom: rucom.num_rucom,
        rucom_record: rucom.rucom_record,
        provider_type: rucom.provider_type,
        rucom_status: rucom.status,
        mineral: rucom.mineral
      },
      population_center: {
        id: $scope.newProvider.population_center ? $scope.newProvider.population_center.id : '',
        name: $scope.newProvider.population_center ? $scope.newProvider.population_center.name : '',
        population_center_code: $scope.newProvider.population_center ? $scope.newProvider.population_center.name : ''
      },
      company_info: {
        name: '',
        nit_number: '',
        legal_representative: '',
        id_type_legal_rep: '',
        id_number_legal_rep: '',
        email: '',
        phone_number: ''
      },
      identification_number_file: $scope.newProvider.identification_number_file || '',
      mining_register_file: $scope.newProvider.mining_register_file || '',
      rut_file: $scope.newProvider.rut_file || '',
      chamber_commerce_file: $scope.newProvider.chamber_commerce_file || ''
    };

    if($scope.newProvider.has_company) {
      prov.first_name = $scope.newProvider.first_name;
      prov.has_company =  true;
      prov.company_info = {
       name: $scope.companyName,
       nit_number: $scope.newProvider.company_info.nit_number,
       legal_representative: $scope.newProvider.company_info.legal_representative,
       id_type_legal_rep: $scope.newProvider.company_info.id_type_legal_rep,
       id_number_legal_rep: $scope.newProvider.company_info.id_number_legal_rep,
       email: $scope.newProvider.company_info.email,
       phone_number: $scope.newProvider.company_info.phone_number
      };
      $scope.newProvider.company_info.name = prov.company_info.name;
    }

    console.log(prov.rucom.num_rucom);
    console.log(prov.rucom.rucom_record);
    if(prov.rucom.num_rucom) {
      $scope.rucomIDField.label = 'Número de RUCOM';
      $scope.rucomIDField.field = 'num_rucom';
    } else if (prov.rucom.rucom_record) {
      $scope.rucomIDField.label = 'Número de Expediente';
      $scope.rucomIDField.field = 'rucom_record';
    }

    $scope.newProvider = prov;
    $scope.currentRucom = prov.rucom;
    ProviderService.setCurrentProv(prov);
    if ($scope.newProvider.population_center.id !== '') {
      $scope.loadProviderLocation($scope.newProvider);
    }

    console.log('provider:' + prov);
    console.log(prov);
    });
  } else {
    prov = {
      document_number: $scope.newProvider.document_number,
      first_name: $scope.newProvider.first_name || '',
      last_name: $scope.newProvider.last_name,
      email: $scope.newProvider.email,
      address: $scope.newProvider.address,
      city: $scope.newProvider.city || '',
      state: $scope.newProvider.state || '',
      phone_number: $scope.newProvider.phone_number,
      photo_file: $scope.newProvider.photo_file || '',
      rucom: {
        provider_type: $scope.newProvider.rucom ? $scope.newProvider.rucom.provider_type : '',
        rucom_status: "No Inscrito",
        mineral: "Oro"
      },
      population_center: {
        id: $scope.newProvider.population_center ? $scope.newProvider.population_center.id : '',
        name: $scope.newProvider.population_center ? $scope.newProvider.population_center.name : '',
        population_center_code: $scope.newProvider.population_center ? $scope.newProvider.population_center.name : ''
      },
      company_info: {
        name: '',
        nit_number: '',
        legal_representative: '',
        id_type_legal_rep: '',
        id_number_legal_rep: '',
        email: '',
        phone_number: ''
      },
      identification_number_file: $scope.newProvider.identification_number_file || '',
      mining_register_file: $scope.newProvider.mining_register_file || '',
      rut_file: $scope.newProvider.rut_file || '',
      chamber_commerce_file: $scope.newProvider.chamber_commerce_file || ''
    };

    if($scope.newProvider.has_company) {
      prov.has_company =  true;
      prov.company_info = {
       name: $scope.companyName,
       nit_number: $scope.newProvider.company_info.nit_number,
       legal_representative: $scope.newProvider.company_info.legal_representative,
       id_type_legal_rep: $scope.newProvider.company_info.id_type_legal_rep,
       id_number_legal_rep: $scope.newProvider.company_info.id_number_legal_rep,
       email: $scope.newProvider.company_info.email,
       phone_number: $scope.newProvider.company_info.phone_number
      };
      $scope.newProvider.company_info.name = prov.company_info.name;
    }

    $scope.newProvider = prov;
    $scope.currentRucom = prov.rucom;
    ProviderService.setCurrentProv(prov);
    if ($scope.newProvider.population_center.id !== '') {
      $scope.loadProviderLocation($scope.newProvider);
    }  
  }

  $scope.photo=CameraService.getLastScanImage();
  if(CameraService.getJoinedFile() && CameraService.getJoinedFile().length>0){
    $scope.file=CameraService.getJoinedFile();
  }else if (ScannerService.getScanFiles() && ScannerService.getScanFiles().length>0){
    $scope.file=ScannerService.getScanFiles();
  }

  if($scope.photo && CameraService.getTypeFile() === 1){
    $scope.newProvider.photo_file=$scope.photo;
    ProviderService.setCurrentProv($scope.newProvider);
    CameraService.clearData();
  }

  if($scope.file){
    if(CameraService.getTypeFile() === 2) {
      $scope.newProvider.identification_number_file=$scope.file;
      ProviderService.setCurrentProv($scope.newProvider);
    }
    if(CameraService.getTypeFile() === 3) {
      $scope.newProvider.mining_register_file=$scope.file;
      ProviderService.setCurrentProv($scope.newProvider);
    }
    if(CameraService.getTypeFile() === 4) {
      $scope.newProvider.rut_file=$scope.file;
      ProviderService.setCurrentProv($scope.newProvider);
    }
    if(CameraService.getTypeFile() === 5) {
      $scope.newProvider.chamber_commerce_file=$scope.file;
      ProviderService.setCurrentProv($scope.newProvider);
    }
    CameraService.clearData();
    ScannerService.clearData();
  }

  $scope.scanner= function(type){
    CameraService.setTypeFile(type);
  };

  LocationService.getStates.query({}, function(states) {
    $scope.states = states;
    console.log('States: ' + JSON.stringify(states));
  });

  $scope.idTypeLegalRep = [
    { type: 1, name: 'CC' },
    { type: 2, name: 'CE' }
  ];

  $scope.formTabControl = {
    selectedIndex : ProviderService.currentTabProvCreation,
    secondUnlocked : true,
    firstLabel : "Información de Proveedor",
    secondLabel : "Información de Compañia",
    thirdLabel : "Documentación"
  };

  $scope.formValidateRucom = {
    rucomValidated : false,
  };

  $scope.check = function(){
    if($scope.newProvider.has_company && $scope.newProvider.first_name !== $scope.companyName){
      $scope.newProvider.company_info.name = $scope.companyName;
    }else if($scope.newProvider.has_company && $scope.newProvider.first_name === $scope.companyName){
      $scope.newProvider.first_name = "";
      $scope.newProvider.company_info.name = $scope.companyName;
    } if(!$scope.newProvider.has_company && $scope.newProvider.first_name === ''){
      $scope.newProvider.first_name = $scope.companyName;
      $scope.newProvider.company_info.name = "";
    }
  };

  $scope.back = function() {
    ProviderService.setCurrentProv({});
    $state.go(ProviderService.getCallerState || 'providers')
  };

  $scope.next = function() {
    $scope.formTabControl.selectedIndex = Math.min($scope.formTabControl.selectedIndex + 1, 2) ;
    ProviderService.currentTabProvCreation = $scope.formTabControl.selectedIndex;
    console.log("type: " + $scope.newProvider);
  };

  $scope.previous = function() {
    $scope.formTabControl.selectedIndex = Math.max($scope.formTabControl.selectedIndex - 1, 0);
    ProviderService.currentTabProvCreation = $scope.formTabControl.selectedIndex;
    if ($scope.newProvider.population_center.id !== '') {
      $scope.loadProviderLocation($scope.newProvider);
    }
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

  $scope.createProvider = function($event){
    console.log($scope.newProvider);
    $resource = ProviderService.create($scope.newProvider);
    if($resource) {
      saveBtnEnabled = false;
      $scope.showUploadingDialog($event);
    } else {
      $scope.infoAlert('Crear nuevo proveedor', 'Algo salió mal. Por favor asegurese de diligenciar todos los campos requeridos y proveer la documentación de soporte.', true);
    }
  };

  $scope.showUploadingDialog = function ($event) {
     var parentEl = angular.element(document.body);
     $mdDialog.show({
       parent: parentEl,
       targetEvent: $event,
       disableParentScroll: false,
       template:
         '<md-dialog>' +
           '  <md-dialog-content>' +
           '    <div layout="column" layout-align="center center">' +
           '      <p>{{message}}</p>' +
           '      <md-progress-circular md-mode="determinate" value="{{progress}}"></md-progress-circular>' +
           '    </div>' +
           '  </md-dialog-content>' +
           '  <div class="md-actions">' +
           '    <md-button ng-click="closeDialog()" ng-if="progress === 100" class="md-primary">' +
           '      Cerrar' +
           '    </md-button>' +
           '  </div>' +
           '</md-dialog>',       
       controller: ['scope', '$mdDialog', 'ProviderService', function(scope, $mdDialog, ProviderService) {
         scope.progress = ProviderService.impl.uploadProgress;
         scope.message = 'Espere por favor...'
         scope.$watch(function () { return ProviderService.impl.uploadProgress }, function (newVal, oldVal) {
           if (typeof newVal !== 'undefined') {
             console.log('Progress: ' + scope.progress + ' (' + ProviderService.impl.uploadProgress + ')');
             scope.progress = ProviderService.impl.uploadProgress;
             if(scope.progress === 100) {
               scope.closeDialog();
             }
           }
         });
         scope.closeDialog = function() {
           $mdDialog.cancel();
           $scope.newProvider = {};
           ProviderService.setCurrentProv({});
           $scope.infoAlert('Crear nuevo proveedor', 'El registro ha sido exitoso', false);
           $scope.abortCreate = true;
           ProviderService.currentTabProvCreation = 0;
         }
      }]
    });
  };

  $scope.infoAlert = function(title, content, error) {
   $mdDialog.show($mdDialog.alert().title(title).content(content).ok('OK'))
   .finally(function() {
      if (!error) {
        $state.go(ProviderService.getCallerState() || 'providers')
      }
    });
  };

  // Watchers for listen to changes in editable fields
  $scope.$watch('newProvider',
   function(newVal, oldVal) {
     if (oldVal && newVal !== oldVal) {
       $scope.saveBtnEnabled = true;
     }
     ProviderService.setCurrentProv($scope.newProvider);
  }, true);

  $scope.$watch('formTabControl.selectedIndex',
   function(newVal, oldVal) {
     if (newVal !== oldVal) {
       ProviderService.currentTabProvCreation = $scope.formTabControl.selectedIndex;
     }
  }, true);

  // end watchers
  
  // It listens to state changes
  $scope.$on('$stateChangeStart',
    function(event, toState, toParams, fromState, fromParams){
      // console.log('Changing state from: ' + JSON.stringify(fromState) + ' to: ' + JSON.stringify(toState));
      // console.log('Params state from: ' + JSON.stringify(fromParams) + ' to: ' + JSON.stringify(toParams));
      if (toState.url !== "/scanner" && toState.url !== "/scanner1" && toState.url !== "/camera" ) {
        if (!$scope.abortCreate) {
          event.preventDefault();
          var confirm;
          confirm = $mdDialog.confirm().title('Cancelar la creación del nuevo proveedor').content('¿Desea cancelar la operación actual? Los datos que no haya guardado se perderán').ariaLabel('Lucky day').ok('Aceptar').cancel('Cancelar').targetEvent(event);
          return $mdDialog.show(confirm).then((function() {
            $scope.abortCreate = true;
            ProviderService.setCurrentProv({});
            console.log('provider create: dismissing operation');
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
      $scope.selectedState = state;
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
      $scope.selectedCity = city;
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
      $scope.newProvider.city = $scope.selectedCity.name;
      $scope.newProvider.state = $scope.selectedState.name;
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
