angular.module('app')
    .directive('cameraSnapshot', function(CameraService) {
        return {
            restrict: 'EA',
            require: '^camera',
            scope: true,
            templateUrl: 'camera_snapshot.html',
            link: function(scope, ele, attrs, CameraController) {
                scope.takeSnapshot = function() {
                    CameraController.takeSnapshot()
                        .then(function(image) {
                            scope.image=image;
                            //Hacer algo con la imagen tomada
                        });
                };
                scope.addScanFile=function(){
                    if(scope.image) {
                        CameraService.addScanFile(scope.image);
                        console.log("image added "+scope.image);
                    }
                };
                scope.comeBack=function(){
                    //console.log("all the files "+ CameraService.getScanFiles());
                    window.history.back();
                };
            }
        };
    });