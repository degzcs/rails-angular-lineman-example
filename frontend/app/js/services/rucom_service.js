// TODO : FIX THE RUCOM SERVICEE!!!!!

angular.module('app').factory('RucomService', function($resource) {

    var currentRucom = {};        

    var setCurrentRucom = function(rucom) {
        currentRucom = rucom;
    };

    var getCurrentRucom = function() {
        return currentRucom;
    };
   
    var getRucom = $resource('/api/v1/rucoms/:id', {rucomId: '@rucomId'});

    var retrieveRucoms = $resource('/api/v1/:resource', {resource: 'rucoms', rucom_query: '@rucom_query'});    

    return {
        getCurrentRucom: getCurrentRucom,        
        setCurrentRucom: setCurrentRucom,
        getRucom: getRucom,
        retrieveRucoms: retrieveRucoms
    };
});