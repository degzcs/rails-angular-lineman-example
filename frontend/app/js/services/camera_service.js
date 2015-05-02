angular.module('app').factory('CameraService', function($window) {

    var images= [];
    var files= [];
    var pdf = new jsPDF();
    var width=150;
    var height=150;
    var y=0;
    var typeFile=0;
    var consecutivo=0;
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
    var getDate=function(){
        var today = new Date();
        var min = today.getMinutes(); 
        var hrs = today.getHours(); 
        var dd = today.getDate(); 
        var mm = today.getMonth()+1; 
        var yyyy = today.getFullYear();      
        return yyyy+"-"+mm+"-"+dd+"-"+hrs+"-"+min;
    };
//mehtod to add scan files
    var addScanFile = function($datarUrl){
        images.push($datarUrl);
        files.push(dataURItoFile($datarUrl,consecutivo+getDate()+files.length+'.png'));
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
        var retorno=images[images.length-1];
        return retorno;
      }
      return '';
    };
//Clear data
    var clearData=function(){
        images= [];
        files= [];
        pdf = new jsPDF();
        marginLeft=150;
        marginRight=150;
        y=0;
    };
//Method to get the last scan file
    var getLastScanFile=function(){
      if(files.length>0){
        var retorno=files[files.length-1];
        return retorno;
      }
      return '';
    };
//Method to get the last file in pdf joining all the images
     var getJoinedFile=function(){
      filesarray=[];
      if(images && images.length>0){
       for(var i=0;i<images.length;i++){
         if(i>0){
            pdf.addPage();
            pdf.setPage(y);
        } 
        pdf.addImage(images[i],"png",30,5,width,height);
        }
        var blob= pdf.blob('file.pdf');
        blob.lastModifiedDate = new Date();
        blob.name = consecutivo+getDate()+'.pdf';
        filesarray.push(blob);
        return filesarray;
        }
    };
    var getTypeFile=function(){
        return typeFile;
    };
     var setTypeFile=function(type){
        typeFile=type;
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
        getJoinedFile: getJoinedFile,
        getLastScanFile: getLastScanFile,
        getLastScanImage: getLastScanImage,
        getTypeFile: getTypeFile,
        setTypeFile: setTypeFile,
        clearData: clearData,
        getScanFiles: getScanFiles

    };
});