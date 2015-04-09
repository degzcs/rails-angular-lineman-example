angular.module('app').controller('ProvidersRucomCtrl', ['$scope', '$stateParams', 'CameraService', 'RucomService', function($scope, $stateParams, CameraService, RucomService){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  // $scope.newProvider = {
  //   firstName: 'Javier',
  //   lastName: 'Suarez' ,
  //   num_rucom: '',
  //   rucom_record: '1234',
  //   type: '1',
  //   company: 'Google' ,
  //   address: '1600 Amphitheatre Pkwy' ,
  //   city: 'Mountain View' ,
  //   state: 'CA' ,
  //   biography: 'Loves kittens, snowboarding, and can type at 130 WPM.\n\nAnd rumor has it she bouldered up Castle Craig!',
  //   postalCode : '94043',
  //   photo_file: ''
  // };
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
    RucomService.getRucom.get({id: $stateParams.rucomId}, function(data) {
      console.log("data.rucom");
      console.log(data);
      $scope.newProvider = data;
      $scope.newCompany.mineral = data.mineral;
      RucomService.setCurrentRucom(data);
      console.log('Current rucom: ' + data);
    });
  }

 $scope.photo=CameraService.getLastScanImage();
  if($scope.photo){
    $scope.newProvider.photo_file=CameraService.getLastScanFile();
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
    if (typeof $scope.newProvider.id !== "undefined" && ($scope.newProvider.status === 'active' || $scope.newProvider.status === 'Certificado, En eval de ren requerido')) {
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
  $scope.create = function(){
    ProviderService.create($scope.provider);
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
