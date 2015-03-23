angular.module('app').controller('InventoryController',  ['$scope', function($scope) {
    $scope.inventarioList=function(){
        var lista=[];
        for(i=0;i<10;i++){
            var inventario={fecha:'', hora:'', quien:'', cuantos:'', ley:'', valor:''};
            inventario.selected= false;
            inventario.fecha="10/20/2014"+i;
            inventario.hora="10:20"+i;
            inventario.quien="Carlos R"+i;
            inventario.cuantos=i;
            inventario.ley="100"+i;
            inventario.valor="100"+i;
            lista.push(inventario);
        }
        return lista;
    };
    $scope.selectaall=false;
    $scope.selectAll=function(inventarioList){
        if($scope.selectaall){
            for(i=0;i<inventarioList.length;i++){
                inventarioList[i].selected=false;
            }
        }else{
            for(i=0;i<inventarioList.length;i++) {
                inventarioList[i].selected = true;
            }
        }
        console.log("sel"+$scope.selectaall);
        console.log("selecciona todo" + inventarioList.length);
    };
    $scope.selectItem=function(item){
        console.log("selecciona item"  + item.selected);
    };
    $scope.lista= $scope.inventarioList();
    $scope.gramosFinales="";

    //////////////////////////////////////
}]);