angular.module('app')
    .directive('camera', function(CameraService) {
        return {
            restrict: 'EA',
            replace: true,
            transclude: true,
            scope: {},
            controller: function($scope, $q, $timeout) {
                this.takeSnapshot = function() {
                    var canvas  = document.querySelector('canvas'),
                        ctx     = canvas.getContext('2d'),
                        videoElement = document.querySelector('video'),
                        d       = $q.defer();

                    canvas.width = $scope.w;
                    canvas.height = $scope.h;
                    //  console.log("timeout " +$timeout);
                    $timeout(function() {
                        ctx.fillRect(0, 0, $scope.w, $scope.h);
                        ctx.drawImage(videoElement, 0, 0, $scope.w, $scope.h);
                        d.resolve(canvas.toDataURL());
                    }, 0);
                    return d.promise;
                };
            },
            templateUrl: 'camera.html',
            link: function(scope, ele, attrs) {
                var w = attrs.width || 500,
                    h = attrs.height || 300;

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
                            maxHeight: h,
                            maxWidth: w
                        }
                    },
                    audio: false
                }, onSuccess, onFailure);

                scope.w = w;
                scope.h = h;

            }
        };
    });
