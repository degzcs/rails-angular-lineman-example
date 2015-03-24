angular.module('app').controller 'TransportersNewCtrl', ($scope, TransporterService) ->
	#
	#  Model
	#
	# $scope.transporterData.first_name = ''
	# $scope.transporterData.last_name = ''
	# $scope.transporterData.document_number = ''
	# $scope.transporterData.phone_number = ''
	# $scope.transporterData.email_address = ''
	# NOTE: I think there are a lot of fields missing for this model like company, NIT, ...

	#
	# Instances
	#

	$scope.transporterData = {}

	#
	# Functions
	#

	# conveys the transporter data to the server
	$scope.newTransporter = ()->
	  $scope.errors = null
	  $scope.updating = true 
	  transporter = new TransporterService($scope.transporterData)
	  transporter.$save()



