# NOTE: This file is not used any more, but it could be used instead step 4
angular.module('app').controller 'SaleShowCtrl', ($scope, SaleService, GoldBatchService, $mdDialog, CurrentUser, LiquidationService, User, PurchaseService,$sce) ->
  #
  # Deletes the last liquidation
  LiquidationService.deleteState()

  #
  #
  #Get info
  $scope.currentSale = SaleService.restoreState()
  $scope.barcode_html = $sce.trustAsHtml($scope.currentSale.barcode_html)
  $scope.currentBuyer = null
  $scope.currentUser = null

  #
  # get Client (buyer)
  User.get($scope.currentSale.buyer.id).success (buyer)->
    $scope.currentBuyer = buyer

  #
  # get current user info
  CurrentUser.get().success (user) ->
    $scope.currentUser = user
