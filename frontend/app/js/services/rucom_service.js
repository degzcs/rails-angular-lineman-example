angular.module('app').factory('RucomService', function($resource) {

    var getRucom = $resource('/api/v1/rucoms/:id', {rucomId: '@rucomId'});

    var retrieveRucoms = $resource('/api/v1/:resource', {resource: 'rucoms', rucom_query: '@rucom_query'});    

    return {
        getRucom: getRucom,
        retrieveRucoms: retrieveRucoms
    };
});