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
    
    controller: () ->
      #controller cn func, may access $scope, $element, $attrs, $transclude
      

    link: (scope, iElement, iAttrs) ->
      #register DOM listeners or update DOM
      #
    
  return directiveDefinitionObject