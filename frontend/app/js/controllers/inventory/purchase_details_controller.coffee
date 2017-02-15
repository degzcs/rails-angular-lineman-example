angular.module('app').controller 'PurchaseDetailsCtrl', ($scope, PurchaseService, $sce, User, $stateParams, $mdDialog, $window) ->

  PurchaseService.get($stateParams.id).success((order, status, headers, config) ->
    $scope.order = order
    $scope.barcodeHtml = $sce.trustAsHtml($scope.order.barcode_html)
    getBuyer($scope.order.buyer.id)
    getSeller($scope.order.seller.id)
  ).error (data, status, headers, config) ->
    infoAlert 'ERROR', 'No se pudo recuperar la orden: ' + data.error

  getBuyer = (buyerId) ->
    User.get(buyerId).success (buyer)->
      $scope.buyer = buyer

  getSeller = (sellerId) ->
    User.get(sellerId).success (seller)->
      $scope.seller = seller

  infoAlert = (title, content) ->
    $mdDialog.show $mdDialog.alert().title(title).content(content).ok('OK')
    return

  $scope.back = ->
    $window.history.back()
    return

