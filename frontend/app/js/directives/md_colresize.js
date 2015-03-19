angular.module('app').directive('mdColresize', function ($timeout) {
  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      scope.$evalAsync(function () {
        $timeout(function(){ $(element).colResizable({
          liveDrag: true,
          fixed: true
          
        });},100);
      });
    }
  };
});

angular.module('app').filter('startFrom',function (){
  return function (input,start) {
    start = +start;
    return input.slice(start);
  };
});