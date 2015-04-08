angular.module('app').factory('LocationService', function($resource) {

    // States Info:

    var getStates = $resource('/api/v1/states.json', {});

    var getStateById = $resource('/api/v1/states/:stateId.json', {stateId:'@stateId'});

    var getCitiesFromState = $resource('/api/v1/states/:stateId/cities.json', {stateId:'@stateId'});

    // Cities Info:

    var getCities = $resource('/api/v1/cities.json', {});

    var getCityById = $resource('/api/v1/cities/:cityId.json', {cityId:'@cityId'});

    var getPopulationCentersFromCity = $resource('/api/v1/cities/:cityId/population_centers.json', {cityId:'@cityId'});

    // Population Centers Info:

    var getPopulationCenters = $resource('/api/v1/population_centers.json', {});

    var getPopulationCenterById = $resource('/api/v1/population_centers/:populationCenterId.json', {populationCenterId:'@populationCenterId'});

    return {
        getStates: getStates,
        getStateById: getStateById,
        getCitiesFromState: getCitiesFromState,
        getCities: getCities,
        getCityById: getCityById,
        getPopulationCentersFromCity: getPopulationCentersFromCity,
        getPopulationCenters: getPopulationCenters,
        getPopulationCenterById: getPopulationCenterById
    };
});