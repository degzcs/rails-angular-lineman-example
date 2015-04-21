#
# This service is in charge to manage the request to the server for the session and password recovery
#
angular.module('app').factory('SessionService', ($resource)->
	$resource('/api/v1/session/:id', {}, {
		query: {method:'GET', isArray:false}
		})
)