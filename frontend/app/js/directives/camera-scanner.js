angular.module('app')
    .directive('camerascan', function(CameraService) {
        return {
            restrict: 'EA',
            replace: true,
            transclude: true,
            scope: {
                w1: '=', //widht of the streaming 
                h1: '=', //height of the streaming 
                w2: '=', //width image snapshot
                h2: '=', //height image snapshot

            },
            controller: 'CameraScannerController',
            templateUrl: 'directives/camera-scanner.html',
            link: function(scope, ele, attrs) {
                if (!CameraService.hasUserMedia) {
                    return;
                }
                dimensions={w1:scope.w1,h1:scope.h1};
                //CameraService.playVideo(dimensions);

            }
        };
    });
