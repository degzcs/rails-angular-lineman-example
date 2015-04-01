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
//Method to get media sources
    var getMediaSources=function(){
        $options=[];
        var n=0;
     MediaStreamTrack.getSources(function(sourceInfos) {
     for (var i = 0; i !== sourceInfos.length; ++i) {
        var sourceInfo = sourceInfos[i];
        var option = {value:'', text:''};
        option.value = sourceInfo.id;
         if (sourceInfo.kind === 'video') {
            n++;
          option.text = sourceInfo.label || ' Cámara ' + n;
          $options.push(option);
        } 
      }
     });
     return $options;
    };
// Method to select source and play it
    var playVideo=function(dimensions,optionSelected){
    var constraints;
    var onSuccess = function(stream) {
        var userMedia = getUserMedia,
        videoElement = document.querySelector('video');
        if (navigator.mozGetUserMedia) {
            videoElement.mozSrcObject = stream;
        } else {
            var vendorURL = window.URL || window.webkitURL;
            videoElement.src = window.URL.createObjectURL(stream);
        }
        // Just to make sure it autoplays
        videoElement.play();
    };
    var onFailure = function(err) {
        console.error(err);
    };
         
    constraints={
    video: {
        optional:[{
                    sourceId: optionSelected
                }],
        mandatory: {
            maxHeight: dimensions.h1,
            maxWidth: dimensions.w1,
            minWidth: dimensions.w1,
            minHeight: dimensions.h1
        }
    },
    audio: false
    };
    
    navigator.getUserMedia(constraints, onSuccess, onFailure);
};
    return {
        hasUserMedia: hasUserMedia(),
        addScanFile:  addScanFile,
        getUserMedia: getUserMedia,
        getMediaSources: getMediaSources,
        playVideo: playVideo,
        getScanFiles: getScanFiles

    };
});