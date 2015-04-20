angular.module('app').factory('ScannerService', function() {

var pdf = new jsPDF();
var filesarray=[];
    //Method to get the scanned files
    var getScanFiles=function(){
        return filesarray;
    };
//Clear data
    var clearData=function(){
        filesarray=[];
    };
//Method to get the last file in pdf joining all the images
     var joinFile=function(images){
     filesarray=[];        
      if(images && images.length>0){
       for(var i=0;i<images.length;i++){
         if(i>0){
            pdf.addPage();
            pdf.setPage(0);
        } 
        pdf.addImage(images[i],"png",5,5,200,280);
        }
     //   pdf.save("a.pdf");
        var blob= pdf.blob('file.pdf');
        blob.lastModifiedDate = new Date();
        blob.name = 'file.pdf';
        filesarray.push(blob);
        return filesarray;
        }
    };

    return {
        getScanFiles:  getScanFiles,
        clearData: clearData,
        joinFile: joinFile
    };
});