angular.module('app')

.controller('ProvidersRucomCtrl', ['$scope',  '$stateParams', 'RucomService', function($scope, $stateParams, RucomService){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;

  $scope.currentRucom = {};
  if ($stateParams.rucomId) {   
    console.log("$stateParams.rucomId: " + $stateParams.rucomId);     
    RucomService.getRucom.get({rucomId: $stateParams.rucomId}, function(data) {
      console.log(data.rucom);
      $scope.currentRucom = data.rucom;
      RucomService.setCurrentRucom(data.rucom);
      console.log('Current rucom: ' + data.rucom.idrucom);
    });
  }

  // $scope.newCompany = {
  //   nit_number: '1234567890',
  //   name: 'TBBC',
  //   address: 'Torres del Parque',
  //   city: 'Popayán',
  //   state: 'Cauca',
  //   country: 'Colombia',
  //   legal_representative: 'Leandro Ordoñez',
  //   type: 'Persona Juridica',
  //   id_number: '1061234567',
  //   email: 'lord@tbbc.com',
  //   phone: '0987654321',
  //   rucom_record: '',
  //   num_rucom: '',
  // };

  $scope.providerTypes = [
    { type: 1, name: 'Comercializador' },
    { type: 2, name: 'Titular' },
    { type: 3, name: 'Solicitante Legalización De Minería' },    
    { type: 2, name: 'Beneficiario Área Reserva Especial' },
    { type: 1, name: 'Consumidor' },
    { type: 1, name: 'Barequero' },
    { type: 2, name: 'Subcontrato de formalización' },
    { type: 3, name: 'Planta de Beneficio' }    
  ];

  $scope.idTypes = [
    { type: 1, name: 'RUT' },
    { type: 2, name: 'Pasaporte' },
    { type: 3, name: 'Cédula de extranjería' },    
    { type: 4, name: 'NIT' },
    { type: 5, name: 'CC' }    
  ];

  $scope.statusType = [
    { type: 1, name: 'Certificado' },
    { type: 2, name: 'Rechazado' },
    { type: 3, name: 'En trámite, pendiente de evaluación' },    
    { type: 4, name: 'Certificado, En eval de ren requerido' }    
  ];

  $scope.formCreateTabCtrl = {
    selectedIndex : 0,
    secondUnlocked : true,
    firstLabel : "Provider info",
    secondLabel : "Company info"
  };

  $scope.formValidateRucom = {    
    rucomValidated : false,    
  };

  $scope.next = function() {
    $scope.formCreateTabCtrl.selectedIndex = Math.min($scope.formCreateTabCtrl.selectedIndex + 1, 1);
    console.log("type: " + $scope.currentRucom.providerTypes);    
    //$scope.newCompany.rucom_record = $scope.newProvider.providerTypes;
  };
  
  $scope.previous = function() {
    $scope.formCreateTabCtrl.selectedIndex = Math.max($scope.formCreateTabCtrl.selectedIndex - 1, 0);
    //$scope.newProvider.rucom_record = $scope.newProvider.providerTypes;
  };

  $scope.validateRucom = function(){
    if ($scope.currentRucom.id !== '' && ($scope.currentRucom.status === 'Certificado' || $scope.currentRucom.status === 'Certificado, En eval de ren requerido')) {
      console.log("match");    
      $scope.formValidateRucom.rucomValidated = true;
      return true;
    } else{
      console.log("no match");
      $scope.formValidateRucom.rucomValidated = false;
      return false;
    }    
  };
}]);
