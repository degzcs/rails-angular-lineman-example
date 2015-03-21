angular.module('app').controller 'InventoryController1', ($scope) ->
  $scope.inventarioList = []
  $scope.msj= 'a'
  $scope.inventarioList = ($scope) ->
    inventario = undefined
    lista = []
    i = 0
    while i++
      inventario.fecha = '10/20/2014'
      inventario.hora = '10:20'
      inventario.quien = 'Carlos R'
      inventario.cuantos = '10'
      inventario.ley = '100'
      inventario.valor = '100'
      lista.push inventario
      i < 10
    lista

  $scope.msj= $scope.inventarioList.length
  return

