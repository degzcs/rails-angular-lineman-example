#
# This service is in charge to manage the request to the server for the inventory
#
angular.module('app').factory('InventoryService', ($resource)->
	$resource('/api/v1/inventory', {}, {
		query: {method:'GET', isArray:false}
		})
)