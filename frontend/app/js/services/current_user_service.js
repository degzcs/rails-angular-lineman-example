angular.module('app').factory('CurrentUser', function CurrentUserFactory($http){
  return{
    get: function() {
      return $http({method: "GET", url: "api/v1/users/me"});
    }
  };
});