angular.module('app').factory('providerService', function($resource) {

    var currentProvider = {};
    var providers = [];

    var setCurrentProv = function(provider) {
        currentProvider = provider;
    };

    var retreiveProviders = $resource('/api/v1/provider', {}, {
      query: {
        method: 'GET',
        isArray: false
      }
    });

    // var getProviders = function() {
    //     retreiveProviders.query((function(res) {
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
        retreiveProviders: retreiveProviders
    };
});