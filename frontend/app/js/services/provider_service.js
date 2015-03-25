angular.module('app').factory('providerService', function($resource) {

    var currentProvider = {};
    var providers = [];

    var setCurrentProv = function(provider) {
        currentProvider = provider;
    };

    var retrieveProviders = $resource('/api/v1/provider/:providerId', {}, {
      query: {
        method: 'GET',
        params:{providerId:''},
        isArray: false
      }
    });

    // var getProviders = function() {
    //     retrieveProviders.query((function(res) {
    //       return providers = res.list;
    //     }), function(error) {});
    //     //return providers;
    // };

    var getCurrentProv = function() {
        return currentProvider;
    };

    return {
        getCurrentProv: getCurrentProv,
        // getProviders:  getProviders,
        setCurrentProv: setCurrentProv,
        retrieveProviders: retrieveProviders
    };
});