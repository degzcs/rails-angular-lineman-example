angular.module('app').factory('CourierService', function($resource,$upload) {

    var retrieveCouriers = $resource('/api/v1/couriers', {
      per_page: '@per_page', 
      page: '@page', 
      id_document_number: '@id_document_number'
    });

    var retrieveCourierById = $resource('/api/v1/couriers/:courierId', {courierId:'@courierId'});

    var create = function(courier) {      
      return $resource('/api/v1/couriers/',
       {},{
          save: {
            method: 'POST'
          }
      });        
    };
    //Can call edit like so:
    //$resource = CourierService.edit($scope.currentCourier);
    //  if($resource){
    //   $resource .update({ id:$scope.currentCourier.id }, $scope.currentCourier);
    // }
    var edit = function(courier) {
      return $resource('/api/v1/couriers/:id',
        {id:'@id'},{
          'update': {
             method: 'PUT'
          }
      });
    };

    return {
        retrieveCouriers: retrieveCouriers,
        create : create,
        edit : edit,
        retrieveCourierById: retrieveCourierById
    };
});