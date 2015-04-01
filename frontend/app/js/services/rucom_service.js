angular.module('app').factory('rucomService', function($resource) {

    var getRucom = $resource('/api/v1/rucom/:id', {}, {
      query: {
        method: 'GET',
        params:{id:''},
        isArray: false
      }
    });

    var retrieveRucoms = $resource('/api/v1/:resource', {resource: 'rucom', rucom_attr: '@rucom_attr'}, {
      query: {
        method: 'GET',
        isArray: false
      }
    });    

    return {
        getRucom: getRucom,
        retrieveRucoms: retrieveRucoms
    };
});