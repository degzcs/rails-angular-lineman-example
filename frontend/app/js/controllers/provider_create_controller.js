angular.module('app')

.controller('ProvidersCreateCtrl', ['$scope', function($scope){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  $scope.newProvider = {        
    firstName: 'Javier',
    lastName: 'Suarez' ,  
    num_rucom: '',
    rucom_record: '',
    subcontract_number: '',
    type: '',
    company: 'Google' ,
    address: '1600 Amphitheatre Pkwy' ,
    city: 'Mountain View' ,
    state: 'CA' ,
    biography: 'Loves kittens, snowboarding, and can type at 130 WPM.\n\nAnd rumor has it she bouldered up Castle Craig!',
    postalCode : '94043'
  };  

  $scope.newCompany = {
    nit_number: '1234567890',
    name: 'TBBC',
    address: 'Torres del Parque',
    city: 'Popayán',
    state: 'Cauca',
    country: 'Colombia',
    legal_representative: 'Leandro Ordoñez',
    type: 'Persona Juridica',
    id_number: '1061234567',
    email: 'lord@tbbc.com',
    phone: '0987654321',
    rucom_record: '',
    num_rucom: '',
  };

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
    console.log("type: " + $scope.newProvider.providerTypes);    
    //$scope.newCompany.rucom_record = $scope.newProvider.providerTypes;

  };
  $scope.previous = function() {
    $scope.formCreateTabCtrl.selectedIndex = Math.max($scope.formCreateTabCtrl.selectedIndex - 1, 0);
    //$scope.newProvider.rucom_record = $scope.newProvider.providerTypes;
  };

  $scope.validateRucom = function(id_rucom){
    if (id_rucom === "123") {
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