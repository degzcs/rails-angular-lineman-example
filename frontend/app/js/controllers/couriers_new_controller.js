angular.module('app').controller('CouriersNewCtrl', function($scope, $window, $mdDialog, CourierService) {
	/*
	*  Model
	*
	* $scope.courier.first_name = ''
	* $scope.courier.last_name = ''
	* $scope.courier.id_document_number = ''
	* $scope.courier.id_document_type = ''
	* $scope.courier.phone_number = ''
	* $scope.courier.company_name = ''
	* $scope.courier.nit_company_number = ''

	*
	* Instances
	*

	$scope.courier = {}

	*
	* Functions
	*

	* conveys the courier data to the server */
	
    $scope.courier = {};
    $scope.saveBtnEnabled = false;

    // Watchers for listen to changes in editable fields

    $scope.$watch('courier', 
      function(newVal, oldVal) {
        if (oldVal && newVal !== oldVal) {
          $scope.saveBtnEnabled = true;
        }
    }, true); // objectEquality = true

    $scope.back = function() {
      $window.history.back();
    };

    $scope.infoAlert = function(title, content) {
	  $mdDialog.show($mdDialog.alert().title(title).content(content).ok('OK'))
	  .finally(function() {
        $window.history.back();
      });
	};

    $scope.newCourier = function() {
      console.log(JSON.stringify($scope.courier));
      $resource = CourierService.create($scope.courier);
      if($resource){
        $resource .save($scope.courier);
        $scope.infoAlert('Courier', 'Successful registration');
      } else{
      	$scope.infoAlert('Courier', 'Something went wrong');
      }
  	};
});