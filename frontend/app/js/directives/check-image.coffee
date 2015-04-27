angular.module('app').directive 'checkImage', ($http) ->
  {
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, c) ->
      attrs.$observe 'ngSrc', (ngSrc) ->
        if ngSrc != undefined
          if ngSrc.length > 0
            c.$setValidity('checkImage', true)
          else
            c.$setValidity('checkImage', false)
  }