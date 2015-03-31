angular.module('app')
    .directive('camera', function(CameraService) {
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
            controller: 'CameraController',
            templateUrl: 'directives/camera.html',
            link: function(scope, ele, attrs) {
                
                if (!CameraService.hasUserMedia) {
                    return;
                }
                var userMedia = CameraService.getUserMedia(),
                    videoElement = document.querySelector('video');
                // We'll be placing our interaction inside of here

                var onSuccess = function(stream) {
                    if (navigator.mozGetUserMedia) {
                        videoElement.mozSrcObject = stream;
                    } else {
                        var vendorURL = window.URL || window.webkitURL;
                        videoElement.src = window.URL.createObjectURL(stream);
                    }
                    // Just to make sure it autoplays
                    videoElement.play();
                };
                // If there is an error
                var onFailure = function(err) {
                    console.error(err);
                };



                // Make the request for the media
                navigator.getUserMedia({
                    video: {
                        mandatory: {
                            maxHeight: scope.h1,
                            maxWidth: scope.w1,
                            minWidth: scope.w1,
                            minHeight: scope.h1
                        }
                    },
                    audio: false
                }, onSuccess, onFailure);

            }
        };
    });
