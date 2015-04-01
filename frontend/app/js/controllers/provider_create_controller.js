angular.module('app').controller('ProvidersCreateCtrl', ['$scope', function($scope){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  $scope.newProvider = {        
    firstName: 'Javier',
    lastName: 'Suarez' ,  
    num_rucom: '',
    rucom_record: '1234',
    type: '1',
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
    rucom_record: '98765423457',
    num_rucom: '',
  };

  $scope.formCreateTabCtrl = {
    selectedIndex : 0,
    secondUnlocked : true,
    firstLabel : "Provider info",
    secondLabel : "Company info"
  };

  $scope.next = function() {
    $scope.formCreateTabCtrl.selectedIndex = Math.min($scope.formCreateTabCtrl.selectedIndex + 1, 1);
  };
  $scope.previous = function() {
    $scope.formCreateTabCtrl.selectedIndex = Math.max($scope.formCreateTabCtrl.selectedIndex - 1, 0);
  };

}]);