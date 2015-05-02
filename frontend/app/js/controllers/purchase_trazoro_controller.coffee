# UNUSED CONTROLLER TODO: DEFINE IF THIS IS GOING TO BE PRESETN
angular.module('app').controller 'PurchasesTrazoroCtrl', ($scope, PurchaseService, GoldBatchService, PdfService, $timeout, $q, $mdDialog, CurrentUser,  $sce,SaleService) ->

  $scope.getSale= (code)->
    SaleService.get_by_code(code).success (data)->
      console.log data
