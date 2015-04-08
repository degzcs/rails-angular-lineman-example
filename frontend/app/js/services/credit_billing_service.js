angular.module('app').factory('CreditBilling', function CreditBillingFactory($http){
  return{
    get: function() {
      return $http({method: "GET", url: "api/v1/credit_billings"}); 
    },
    create: function(credit_billing) {
      return $http.post("api/v1/credit_billings", {credit_billing: credit_billing});
    }
  };
});