angular.module('app').factory('CameraService', function($window) {

    var files= [];
    var hasUserMedia = function() {
        return !!getUserMedia();
    };

    var getUserMedia = function() {
        navigator.getUserMedia = ($window.navigator.getUserMedia ||
        $window.navigator.webkitGetUserMedia ||
        $window.navigator.mozGetUserMedia ||
        $window.navigator.msGetUserMedia);
        return navigator.getUserMedia;
    };

    var addScanFile = function($datarUrl){
        files.push($datarUrl);
        //  console.log(files);
        //  return files;
    };

    var getScanFiles=function(){
        return files;
    };

    return {
        hasUserMedia: hasUserMedia(),
        addScanFile:  addScanFile,
        getUserMedia: getUserMedia,
        getScanFiles: getScanFiles

    };
});