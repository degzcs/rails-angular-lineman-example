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
          'save': {
            method: 'POST',
            params: {
              "courier[first_name]":courier.first_name,
              "courier[id_document_number]":courier.id_document_number,
              "courier[id_document_type]":courier.id_document_type,
              "courier[last_name]":courier.last_name,
              "courier[phone_number]":courier.phone_number,
              "courier[address]":courier.address,
              "courier[company_name]":courier.company_name,
              "courier[nit_company_number]":courier.nit_company_number
            }
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
             method: 'PUT',
             params: {
              "courier[first_name]":courier.first_Name,
              "courier[id_document_number]":courier.id_document_number,
              "courier[id_document_type]":courier.id_document_type,
              "courier[last_name]":courier.last_Name,
              "courier[phone_number]":courier.phone_number,
              "courier[address]":courier.address,
              "courier[company_name]":courier.company_name,
              "courier[nit_company_number]":courier.nit_company_number
            }
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