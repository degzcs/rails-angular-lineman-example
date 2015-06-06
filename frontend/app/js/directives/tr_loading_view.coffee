# Registers a new directive with the compiler
#
angular.module('app').directive 'trLoadingView', () ->
  directiveDefinitionObject =
    scope: {
      mode: "="
      progress: "="
      message: "="
    }
    restrict: 'E'
    templateUrl: 'directives/tr-loading-view.html'
    
    controller: ($scope) ->
      #controller cn func, may access $scope, $element, $attrs, $transclude
      console.log $scope.progress
      console.log $scope.mode

    link: (scope, iElement, iAttrs) ->
      #register DOM listeners or update DOM
      #
    
  return directiveDefinitionObject