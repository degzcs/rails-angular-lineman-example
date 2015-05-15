angular.module('app').factory('ScannerService', function() {

var pdf = new jsPDF();
var filesarray=[];
var consecutivo=0;
    //Method to get the scanned files
    var getScanFiles=function(){
        return filesarray;
    };
//Clear data
    var clearData=function(){
        filesarray=[];
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
//Method to get the last file in pdf joining all the images
     var joinFile=function(images){
     pdf=new jsPDF();    
     filesarray=[];        
     consecutivo++;
      if(images && images.length>0){
       for(var i=0;i<images.length;i++){
         if(i>0){
            pdf.addPage();
            pdf.setPage(0);
        } 
        pdf.addImage(images[i],"JPEG",5,5,200,280);
        }
     //   pdf.save("a.pdf");
        var blob= pdf.getBlob();
        blob.lastModifiedDate = new Date();
        blob.name = consecutivo+getDate()+'.pdf';;
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