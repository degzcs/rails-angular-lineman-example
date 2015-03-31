angular.module('app').controller('ProvidersCreateCtrl', ['$scope', '$stateParams', 'providerService', function($scope, $stateParams, providerService){
  //$scope.currentProvider = providerService.getCurrentProv() ? ;
  $scope.newProvider = {        
    firstName: '',
    lastName: '' ,
    id_rucom: '',
    company: 'Google' ,
    address: '1600 Amphitheatre Pkwy' ,
    city: 'Mountain View' ,
    state: 'CA' ,
    biography: 'Loves kittens, snowboarding, and can type at 130 WPM.\n\nAnd rumor has it she bouldered up Castle Craig!',
    postalCode : '94043'
  };  

  $scope.data = {
    selectedIndex : 0,
    secondLocked : false,
    secondLabel : "Complementary info"
  };
  $scope.next = function() {
    $scope.data.selectedIndex = Math.min($scope.data.selectedIndex + 1, 1) ;
  };
  $scope.previous = function() {
    $scope.data.selectedIndex = Math.max($scope.data.selectedIndex - 1, 0);
  };

}]);