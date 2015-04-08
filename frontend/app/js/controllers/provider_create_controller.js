angular.module('app')

.controller('ProvidersRucomCtrl', ['$scope',  '$stateParams', 'RucomService', function($scope, $stateParams, RucomService){
  
  $scope.newCompany = {
    nit_number: '1234567890',
    name: 'TBBC',
    address: 'Torres del Parque',
    population_center: '1',
    legal_representative: 'Leandro Ordoñez',
    id_type_legal_rep: '1',
    id_number_legal_rep: '1061234567',
    email: 'lord@tbbc.com',
    phone_number: '0987654321',
    mineral: '',
    status: false   
  };

  $scope.id_type_legal_rep = [    
    { type: 3, name: 'CC' },
    { type: 2, name: 'Cédula de extranjería' }
  ];

  $scope.newProvider = {};  
  if ($stateParams.rucomId) {   
    console.log("$stateParams.rucomId: " + $stateParams.rucomId);     
    RucomService.getRucom.get({rucomId: $stateParams.rucomId}, function(data) {
      console.log(data.rucom);
      $scope.newProvider = data.rucom;
      $scope.newCompany.mineral = data.mineral;
      RucomService.setCurrentRucom(data.rucom);
      console.log('Current rucom: ' + data.rucom.idrucom);
    });
  }

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

  $scope.next = function() {
    if($scope.formValidateRucom.rucomValidated){
      $scope.formTabControl.selectedIndex = Math.min($scope.formTabControl.selectedIndex + 1, 1);
      console.log("type: " + $scope.newProvider.providerTypes);    
    }        
  };
  
  $scope.previous = function() {
    $scope.formTabControl.selectedIndex = Math.max($scope.formTabControl.selectedIndex - 1, 0);    
  };

  $scope.validateRucom = function(){    
    if (typeof $scope.newProvider.document_number !== "undefined" && ($scope.newProvider.status === 'Certificado' || $scope.newProvider.status === 'Certificado, En eval de ren requerido')) {
      console.log("match");
      $scope.formValidateRucom.rucomValidated = true;
      $scope.formTabControl.secondUnlocked = false;
      return true;
    } else{
      console.log("no match");
      $scope.formValidateRucom.rucomValidated = false;
      $scope.formTabControl.secondUnlocked = true;
      return false;
    }    
  };

  // $scope.providerTypes = [
  //   { type: 1, name: 'Comercializador' },
  //   { type: 2, name: 'Titular' },
  //   { type: 3, name: 'Solicitante Legalización De Minería' },    
  //   { type: 2, name: 'Beneficiario Área Reserva Especial' },
  //   { type: 1, name: 'Consumidor' },
  //   { type: 1, name: 'Barequero' },
  //   { type: 2, name: 'Subcontrato de formalización' },
  //   { type: 3, name: 'Planta de Beneficio' }    
  // ];

  // $scope.statusType = [
  //   { type: 1, name: 'Certificado' },
  //   { type: 2, name: 'Rechazado' },
  //   { type: 3, name: 'En trámite, pendiente de evaluación' },    
  //   { type: 4, name: 'Certificado, En eval de ren requerido' }    
  // ];





}]);
