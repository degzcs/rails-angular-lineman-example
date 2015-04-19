angular.module('app')
    .directive('scanner', function() {
        return {
            restrict: 'EA',
            replace: true,
            transclude: true,
            scope: {
                file: '=',
            },
            controller: 'ScannerController',
            templateUrl: 'directives/scanner.html',
            link: function(scope, ele, attrs) {
            
                

            }
        };
    });
