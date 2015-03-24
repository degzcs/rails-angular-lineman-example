#
# This service is in charge to manage the request to the server for the trasporter
#
angular.module('app').factory('TransporterService', ($resource)->
	$resource('/api/v1/transporter/:id', {}, {
		query: {method:'GET', isArray:false}
		})
)