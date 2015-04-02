angular.module('app').factory('ProviderService', function($resource) {

    var currentProvider = {};
    var providers = [];

    var setCurrentProv = function(provider) {
        currentProvider = provider;
    };

    var retrieveProviders = $resource('/api/v1/providers.json', {});

    var retrieveProviderById = $resource('/api/v1/providers/:providerId.json', {providerId:'@providerId'});

    var getCurrentProv = function() {
        return currentProvider;
    };

    return {
        getCurrentProv: getCurrentProv,
        setCurrentProv: setCurrentProv,
        retrieveProviders: retrieveProviders,
        retrieveProviderById: retrieveProviderById
    };
});