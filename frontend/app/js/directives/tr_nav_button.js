angular.module('app').directive('trNavButton',function ($state) {
  return {
    restrict: 'E',
    templateUrl: 'directives/tr-nav-button.html',
    scope: {
      name: "=",
      state: "=",
      icon: "="
    },
    link: function ($scope, iElement, iAttrs) {
      $scope.isSelected = function(){
        if ($scope.state === $state.current.name) {
          return true;
        } else {
          return false;
        }
      };
    }
  }; 
});