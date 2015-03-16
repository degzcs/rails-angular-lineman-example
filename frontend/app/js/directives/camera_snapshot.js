angular.module('app')
    .directive('cameraSnapshot', function(CameraService) {
        return {
            restrict: 'EA',
            require: '^camera',
            scope: true,
            template: '<div style="width:600px; display:inline-block;"><button class="md-raised md-primary md-button md-default-theme" ng-click="takeSnapshot()">Tomar Imagen</button></div>'+
            '<div style="display:inline-block;"><md-button class="md-raised md-primary md-button md-default-theme"  ng-click="addScanFile()">Agregar al Documento</md-button>'+
            '<br/><br/><br/>' +
            '<button class="md-raised md-primary md-button md-default-theme"  ng-click="comeBack()"> Finalizar Scan </button>',
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