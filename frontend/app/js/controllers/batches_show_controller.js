angular.module('app').controller('BatchesShowCtrl',  ['$scope', function($scope) {

    //properties for liquidate_inventory.html

    //section liquidate:
   // $scope.inventario=InventoryServic.getItem();

    $scope.provider = {
        id_rucom: 'RUCOM-201403014943',
        prov_type: $scope.provType,
        type: 'Persona Natural',
        name: 'Leandro Ordóñez',
        id: '1023939222',
        phone_nb: '314 757 9454',
        address: 'Cra 1 # 2N - 3, Urbanizacion A, Popayan, Colombia',
        email: 'leandro.ordonez.ante@gmail.com',
        city: 'Popayán',
        state: 'CAUCA',
        postalCode : '94043'
    };

    $scope.compra = {
        castellanos: '10',
        tomines: '17',
        reales: '12',
        granos: '13',
        total: '34',
        ley: '800',
        precioGramo: '1300'
    };


}]);
