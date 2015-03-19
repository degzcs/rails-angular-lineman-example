angular.module('app').directive('trSidebarButton', [function () {
  return {
    restrict: 'E',
    templateUrl: 'directives/tr-sidebar-button.html',
    scope: {
      name: "=",
      url: "="
    },
    link: function (scope, iElement, iAttrs) {
        
    }
  };
}]);