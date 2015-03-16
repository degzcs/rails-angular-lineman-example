angular.module('app')
    .directive('useCamera', function(CameraService) {
        return {
            scope: true,
            template: '<br/>',
            link: function(scope, ele, attrs) {

                console.log("files retrieved");
                for(var i=0;i< CameraService.getScanFiles().length;i++){
                    console.log( CameraService.getScanFiles()[i]);
                }
            }
        };
    });