angular.module('app').controller('CameraController',  ['$scope','$q','$timeout','CameraService', function($scope,$q, $timeout,CameraService) {
                $scope.takeSnapshot = function() {
                    var canvas  = document.querySelector('canvas'),
                        ctx     = canvas.getContext('2d'),
                        videoElement = document.querySelector('video'),
                        d       = $q.defer();

                    canvas.width = $scope.w2;
                    canvas.height = $scope.h2;
                    //  console.log("timeout " +$timeout);
                    $timeout(function() {
                        ctx.fillRect(0, 0, $scope.w2, $scope.h2);
                        ctx.drawImage(videoElement, 0, 0, $scope.w2, $scope.h2);
                        d.resolve(canvas.toDataURL());
                    }, 0);
                    d.promise.then(function(image) {
                            $scope.image=image;
                            //Hacer algo con la imagen tomada
                        });
                };
                $scope.addScanFile=function(){
                    if($scope.image) {
                        CameraService.addScanFile($scope.image);
                        console.log("image added "+ $scope.image);
                    }
                };
                $scope.comeBack=function(){
                    //console.log("all the files "+ CameraService.getScanFiles());
                    window.history.back();
                };
            }]);