angular.module('app').controller('CameraScannerController',  ['$scope','$q','$timeout','$mdDialog','CameraService', function($scope,$q, $timeout,$mdDialog,CameraService) {
                $scope.optionsSource=CameraService.getMediaSources();
                $scope.optionSelected='';
                $scope.isForCamera='Foto';
                $scope.number=0;
                $scope.image1='';
                
                $scope.changeCamera=function(option){
                    dimensions={w1:$scope.w1,h1:$scope.h1};
                    CameraService.playVideo(dimensions,option);
                    console.log($scope.optionSelected);
                };
                $scope.changeParameter=function(option){
                    dimensions={w1:$scope.w1,h1:$scope.h1};
                    CameraService.playVideo(dimensions,option);
                  
                };
                $scope.takeSnapshot = function() {
                    var canvas  = document.querySelector('canvas'),
                        ctx     = canvas.getContext('2d'),
                        videoElement = document.querySelector('video'),
                        d       = $q.defer();
                        vari=720;
                    canvas.width = vari;
                    canvas.height = vari;
                    $timeout(function() {
                        ctx.fillRect(0, 0, vari, vari);
                        ctx.drawImage(videoElement, 0, 0, vari, vari);
                        d.resolve(canvas.toDataURL("image/jpeg", 1.0));
                    }, 0);
                    d.promise.then(function(image) {
                            $scope.image1=image;
                            canvas.width = $scope.w2;
                    canvas.height = $scope.h2;
                    $timeout(function() {
                        ctx.fillRect(0, 0, $scope.w2, $scope.h2);
                        ctx.drawImage(videoElement, 0, 0, $scope.w2, $scope.h2);
                        d.resolve(canvas.toDataURL("image/jpeg", 1.0));
                    }, 0);
                    d.promise.then(function(image) {
                            $scope.image=image;
                        });
                        });

                    
                };

                $scope.takeAgain = function(){
                    hideCanvas();
                };
                $scope.addScanFile=function(){
                    if($scope.image) {
                        CameraService.addScanFile($scope.image1);
                        $scope.number++;
                        console.log("image added "+ $scope.image1);
                        console.log("image added "+ $scope.image);
                    }
                };
                $scope.removeScanFile=function(){
                        CameraService.removeScanFile();
                        if($scope.number>0){
                           $scope.number--;
                        }
                };
                $scope.comeBack=function(){
                    //console.log("all the files "+ CameraService.getScanFiles());
                    if($scope.isForCamera === 'Foto'){
                        $scope.addScanFile();
                    }
                    window.history.back();
                };
                $scope.showConfirmAdd = function(ev) {
                    // Appending dialog to document.body to cover sidenav in docs app
                    var confirm = $mdDialog.confirm().title('Agregar página')
                      .content('Está seguro de agregar al archivo?')
                      .ariaLabel('Lucky day')
                      .ok('Aceptar')
                      .cancel('Cancelar')
                      .targetEvent(ev);
                    $mdDialog.show(confirm).then($scope.addScanFile);
                  };
                  $scope.showConfirmRemove = function(ev) {
                    // Appending dialog to document.body to cover sidenav in docs app
                    var confirm = $mdDialog.confirm()
                      .title('Remover paǵina')
                      .content('Está seguro de eliminar el archivo?')
                      .ariaLabel('Lucky day')
                      .ok('Please do it!')
                      .cancel('No please')
                      .targetEvent(ev);
                    $mdDialog.show(confirm).then($scope.removeScanFile);
                  };
            }]);