angular.module('app').controller('InventoryController',  function($scope, InventoryService) {

    // get the list value from server response ans setup the list
    InventoryService.query(function(res) {
                   $scope.list = res.list;
                }, function(error) {
                  // Error handler code
                });

    $scope.select_all=false;

    // updates all checkboxes in the inventory list
    // @params inventoryList [Array]
    $scope.selectAll=function(inventoryList){
        for(i=0;i<inventoryList.length;i++){
            if($scope.select_all){
                    inventoryList[i].selected=false;
            }else{
                    inventoryList[i].selected = true;
            }
        }
        console.log("select all value "+ $scope.select_all);
        console.log("rows selected number" + inventoryList.length);
    };

    // selects a single item in the inventory list
    // @params item [Object]
    $scope.selectItem=function(item){
        console.log("selecciona item"  + item.selected);
    };

    $scope.finalGrams="";

});