angular.module('app').controller('ScannerController',  ['$scope','ScannerService', function($scope,ScannerService) {
            	
        	$scope.images=[];	

        	$scope.init=function(){
        		var DWObject = Dynamsoft.WebTwainEnv.GetWebTwain('dwtcontrolContainer'); 
         		DWObject.Width = 300;  
    			DWObject.Height = 400;
			};
			
			$scope.$on("$destroy", function(){
		       var DWObject = Dynamsoft.WebTwainEnv.GetWebTwain('dwtcontrolContainer'); 
         		DWObject.Width = 1;  
    			DWObject.Height = 1;
		    });
			
			  $scope.finish=function(){
			  	$scope.images=[];
			  	var DWObject = Dynamsoft.WebTwainEnv.GetWebTwain('dwtcontrolContainer'); 
				for (var i = 0; i < DWObject.HowManyImagesInBuffer; i++) { // Loop through each of the images in the viewer.
						DWObject.SelectedImagesCount = 1;        
				        DWObject.SetSelectedImageIndex(0, i);
						DWObject.GetSelectedImagesSize(3);// Pre-calculate the size of the images:
						// Encode the images into a base64 string:
						var imagedata = DWObject.SaveSelectedImagesToBase64Binary(); 
						var root="data:image/png;base64,";
						imagedata = root.concat(imagedata);
						$scope.images.push(imagedata);
						console.log(imagedata);
				}
				console.log($scope.images);
				ScannerService.joinFile($scope.images);
				DWObject.RemoveAllSelectedImages();
				DWObject.Width = 1;  
    			DWObject.Height = 1;
	  			window.history.back();
			  };	

              $scope.click=function(){
                var DWObject = Dynamsoft.WebTwainEnv.GetWebTwain('dwtcontrolContainer'); 
                DWObject.SelectSource();                        // Select a Data Source (a device like scanner) from the Data Source Manager.            
                DWObject.OpenSource();                          // Open the source. You can set resolution, pixel type, etc. after this method. Please refer to the sample 'Scan' -> 'Custom Scan' for more info.
                DWObject.IfDisableSourceAfterAcquire = true;    // Source will be closed automatically after acquisition.
                DWObject.MaxImagesInBuffer = 100;
                DWObject.IfShowFileDialog =false;
                DWObject.IfShowUI = true;
                DWObject.IfFeederEnabled = true; 
				DWObject.XferCount = -1;
                DWObject.IfAutoFeed = true;   //auto feed
                DWObject.AcquireImage();
            
                DWObject.RegisterEvent('OnPostAllTransfers',function(){
			/*	
				alert(DWObject.HowManyImagesInBuffer);
			*/	
				});
                };
               
}]);
                

