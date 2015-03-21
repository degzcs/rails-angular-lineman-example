angular.module('app').controller('InventoryController',  ['$scope', function($scope) {
    $scope.inventarioList=function(){
        var lista=[];
        for(i=0;i<10;i++){
            var inventario={fecha:'', hora:'', quien:'', cuantos:'', ley:'', valor:''};
            inventario.fecha="10/20/2014"+i;
            inventario.hora="10:20"+i;
            inventario.quien="Carlos R"+i;
            inventario.cuantos=i;
            inventario.ley="100"+i;
            inventario.valor="100"+i;
            lista.push(inventario);
            console.log("lista "+i +lista);
        }
        return lista;
    };
    $scope.selectAll=function(){
        console.log("selecciona todo");
    };
    $scope.selectItem=function(id){
        console.log("selecciona item" + id);
    };

    $scope.gramosFinales="";
    $scope.lista= $scope.inventarioList();



}]);