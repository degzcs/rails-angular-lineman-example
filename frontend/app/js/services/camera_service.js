angular.module('app').factory('CameraService', function($window) {

    var files= [];
    var hasUserMedia = function() {
        return !!getUserMedia();
    };
//method to get the camera and microphone resource
    var getUserMedia = function() {
        navigator.getUserMedia = ($window.navigator.getUserMedia ||
        $window.navigator.webkitGetUserMedia ||
        $window.navigator.mozGetUserMedia ||
        $window.navigator.msGetUserMedia);
        return navigator.getUserMedia;
    };
//mehtod to add scan files
    var addScanFile = function($datarUrl){
        files.push($datarUrl);
        //  console.log(files);
        //  return files;
    };
//Method to get the scanned files
    var getScanFiles=function(){
        console.log(files);
        return files;
    };

    return {
        hasUserMedia: hasUserMedia(),
        addScanFile:  addScanFile,
        getUserMedia: getUserMedia,
        getScanFiles: getScanFiles

    };
});