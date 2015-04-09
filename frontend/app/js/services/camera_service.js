angular.module('app').factory('CameraService', function($window) {

    var images= [];
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
        images.push($datarUrl);
        files.push(dataURItoFile($datarUrl,'file'+files.length+'.png'));
        console.log(files);
    };
//Method to remove scan files
    var removeScanFile= function(){
        if(images && images.length>0){
           images.splice(images.length-1,1);     
        }
        if(files && files.length>0){
           files.splice(files.length-1,1);     
        }
    };  
//Method to get the scanned files
    var getScanFiles=function(){
        console.log("files"+files);
        return files;
    };
//Method to get the last scan image
    var getLastScanImage=function(){
      if(images.length>0){
        return images[images.length-1];
      }
      return '';
    };
//Method to get the last scan file
    var getLastScanFile=function(){
      if(files.length>0){
        return files[files.length-1];
      }
      return '';
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
// convert base64/URLEncoded data component to File
var dataURItoFile=function dataURItoFile(dataURI,fileName) {
    var byteString;
    var myfile='';
    if (dataURI.split(',')[0].indexOf('base64') >= 0){
        byteString = atob(dataURI.split(',')[1]);
    }
    else{
        byteString = unescape(dataURI.split(',')[1]);
    }

    // separate out the mime component
    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];

    // write the bytes of the string to a typed array
    var ia = new Uint8Array(byteString.length);
    for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
    myfile=new Blob([ia], {type:mimeString});
    myfile.lastModifiedDate = new Date();
    myfile.name = fileName;
    return myfile;
};

    return {
        hasUserMedia: hasUserMedia(),
        addScanFile:  addScanFile,
        removeScanFile: removeScanFile,
        getUserMedia: getUserMedia,
        getMediaSources: getMediaSources,
        playVideo: playVideo,
        getLastScanFile: getLastScanFile,
        getLastScanImage: getLastScanImage,
        getScanFiles: getScanFiles

    };
});