angular.module('app').controller( 'HomeCtrl', function($scope, $alert, $auth, $anchorScroll, $location){

  $scope.scrollTo = function(id) {
    $location.hash(id);
    console.log($location.hash());
    $anchorScroll();
  
  };

});
