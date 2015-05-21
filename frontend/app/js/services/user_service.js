angular.module('app').factory('User', function UserFactory($http){
  return{
    get: function(id) {
      return $http({method: "GET", url: "api/v1/users/"+id});
    }
  };
});