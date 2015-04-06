angular.module('app').factory('RucomService', function($resource) {

    var currentRucom = {};        

    var setCurrentRucom = function(rucom) {
        currentRucom = rucom;
    };

    var getCurrentRucom = function() {
        return currentRucom;
    };

    var getRucom = $resource('/api/v1/rucom/:rucomId', {}, {
      query: {
        method: 'GET',
        params:{rucomId:''},
        isArray: false
      }
    });

    var retrieveRucoms = $resource('/api/v1/:resource', {resource: 'rucoms', rucom_query: '@rucom_query'}, {
      query: {
        method: 'GET',
        isArray: false
      }
    });    

    return {
        getCurrentRucom: getCurrentRucom,        
        setCurrentRucom: setCurrentRucom,
        getRucom: getRucom,
        retrieveRucoms: retrieveRucoms
    };
});