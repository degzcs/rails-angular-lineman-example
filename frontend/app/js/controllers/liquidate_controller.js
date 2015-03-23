angular.module('app').controller('LiquidateController',  ['$scope', function($scope) {

    $scope.showOptions=function(optionLingote){
        return optionLingote === 2;
    };
    $scope.optionLingote=1;
    $scope.optionsLingote = [
        { label: 'Único', value: 1 },
        { label: 'Varios', value: 2 }
    ];
    $scope.numLingotes=1;
    $scope.lingotes = [
        { peso: 0, ley: 0 }
    ];
    $scope.lingotear=function(numLingotes,lingotes,optionLingote){
        console.log("lingotear opcion  " + optionLingote + " numero lingotes "+ lingotes.length);
        if(optionLingote === 2 && numLingotes>1 ){
            if(lingotes.length<numLingotes){

            for(i=0;i< numLingotes-lingotes.length+1;i++){
                lingote={peso:0, ley:0};
                lingotes.push(lingote);
            }
            }else{
                lingotes.splice(numLingotes,lingotes.length - numLingotes);
            }
        }else if(optionLingote === 1){
            lingotes.splice(1,lingotes.length);
        }
    };
/////////////////////////////////////////////////////////
    $scope.comprador="";
    $scope.transportador="";
    $scope.transporte=
        { medio: '', empresa: '', codigo :'', fecha:'' };

    $scope.medios = ['Áereo', 'Terrestre particular',
        'Terrestre público'];
}]);
