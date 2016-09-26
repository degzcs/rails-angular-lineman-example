angular.module('app').controller 'SalesCtrl', ($scope, SaleService, GoldBatchService, CameraService, MeasureConverterService, $timeout, $q, $mdDialog, CurrentUser, ScannerService, $location,$state, $filter, AuthorizedProviderService, SignatureService) ->
  
  #
  # Instances
  #
  $scope.sale = SaleService
  $scope.chkAgreetmentActive = false

 # Returns the Fixed Sale Agreetmen from Settings instance
  SaleService.getFixedSaleAgreetment().success ((data)->
    console.log 'OK getFixedSaleAgreetment'
    $scope.sale.model.fixed_sale_agreetment = data.fixed_sale_agreetment
  ), (error) ->
    console.log('Error al tratar de Obtener el texto de fijación del Acuerdo')
 
 # Monitoring the Agreetment check
  $scope.handlerContinue =  ->
    console.log $scope.chkAgreetmentActive
    res = if $scope.chkAgreetmentActive == true then true else false
    console.log 'res: ' + res
    return res