angular.module('app').controller('ProvidersRucomCtrl', ['$scope', '$stateParams', 'CameraService', 'RucomService', 'ProviderService', function($scope, $stateParams, CameraService, RucomService, ProviderService){
  
  $scope.newProvider = {};  
  $scope.populationCenter = {};
  $scope.currentRucom = {};
  var prov = {};

  if ($stateParams.rucomId) {    
    RucomService.getRucom.get({id: $stateParams.rucomId}, function(rucom) {      
      console.log(rucom); 
      RucomService.setCurrentRucom(rucom);
      $scope.currentRucom = {
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

  $scope.photo=CameraService.getLastScanImage();
  if($scope.photo){
    $scope.provider.photo_file=CameraService.getLastScanFile();
  }

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
    console.log("click!");
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
        city: $scope.newProvider.city,
        state: $scope.newProvider.state,
        phone_number: $scope.newProvider.phone_number,
        photo_file: $scope.newProvider.photo_file || ('http://robohash.org/'),
        rucom: {
          num_rucom: rucom.num_rucom,
          rucom_record: rucom.rucom_record,
          provider_type: rucom.provider_type,
          rucom_status: rucom.status,
          mineral: rucom.mineral
        },
        population_center: {
          // id: provider.population_center.id,
          name: $scope.populationCenter.name,
          population_center_code: $scope.populationCenter.population_center_code,
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
      ProviderService.setCurrentProv(prov);
      console.log('provider:' + prov);
      console.log(prov);
      });
    }        
  };

  $scope.next = function() {
    if($scope.formValidateRucom.rucomValidated){
      $scope.formTabControl.selectedIndex = Math.min($scope.formTabControl.selectedIndex + 1, 1);
      console.log("type: " + $scope.newProvider.providerTypes);    
    }        
  };
  
  $scope.previous = function() {
    $scope.formTabControl.selectedIndex = Math.max($scope.formTabControl.selectedIndex - 1, 0);    
  };

  // $scope.validateRucom = function(){    
  //   if (typeof $scope.newProvider.id !== "undefined" && ($scope.newProvider.status === 'active' || $scope.newProvider.status === 'Certificado, En eval de ren requerido')) {
  //     console.log("match");
  //     $scope.formValidateRucom.rucomValidated = true;
  //     $scope.formTabControl.secondUnlocked = false;
  //     return true;
  //   } else{
  //     console.log("no match");
  //     $scope.formValidateRucom.rucomValidated = false;
  //     $scope.formTabControl.secondUnlocked = true;
  //     return false;
  //   }    
  // };

  $scope.create = function(){
    ProviderService.create($scope.provider);
  };

}]);
