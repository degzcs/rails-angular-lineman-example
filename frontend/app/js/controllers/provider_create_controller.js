angular.module('app').controller('ProvidersCreateCtrl', ['$scope','CameraService', 'ProviderService', function($scope,CameraService, ProviderService){
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
    postalCode : '94043',
    photo_file: ''
  };
   $scope.provider = {        
    first_Name : 'Kmilo',
    document_number : '2163636556',
    last_Name : 'Kmjj',
    phone_number : '1-685-855-9776 x684',
    address : '21205 Baumbach Island"',
    rucom_id : '20', //Must Exist
    email : 'corine@breitenberg.name',
    population_center_id : '1', //Must Exist
    photo_file: ''
  };  
  $scope.photo=CameraService.getLastScanImage();
  if($scope.photo){
    $scope.provider.photo_file=CameraService.getLastScanFile();  
  }
  /*
  if($scope.photo){
$scope.provider.photo_file.push(CameraService.dataURItoFile($scope.photo,'photo_provider'));
  }
  */
  //$scope.provider.photo_file=$scope.photo?CameraService.dataURItoFile($scope.photo,'photo_provider'):[];

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
    ProviderService.create($scope.provider); 
  };
  $scope.previous = function() {
    $scope.formCreateTabCtrl.selectedIndex = Math.max($scope.formCreateTabCtrl.selectedIndex - 1, 0);
  };
  $scope.create = function(){
    ProviderService.create($scope.provider); 
  };

}]);