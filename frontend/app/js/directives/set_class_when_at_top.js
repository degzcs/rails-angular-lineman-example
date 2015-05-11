angular.module('app').directive('setClassWhenAtTop', function ($window) {
    var $win = angular.element($window); // wrap window object as jQuery object

    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            var topReference = attrs.topReference;
            var topClass = attrs.setClassWhenAtTop; // get CSS class from directive's attribute value
            $win.on('scroll', function (e) {
                if ($window.scrollY >= topReference) {
                    element.addClass(topClass);
                } else {
                    element.removeClass(topClass);
                }
            });
        }
    };
}).

controller('ctrl', function ($scope) {
    $scope.scrollTo = function (target){
    };
});
