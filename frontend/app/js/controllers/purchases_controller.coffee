angular.module('app').controller 'PurchasesCtrl', ($scope, PurchaseService) ->
  #
  # Instances
  #
  $scope.purchaseData = {}

  #
  # Model
  #
  $scope.purchaseData.amount = '1000'
  $scope.purchaseData.gold_batch_id = '1'
  $scope.purchaseData.provider_id = '1'
  $scope.purchaseData.origin_certificate_sequence = '123456789'
  $scope.purchaseData.origin_certificate_file = ''


  #
  # Fuctions
  #

  # It sends the information when the file is selected
  # TO DO: call PurchaseService's create function when is clicked the create purchase button
  $scope.$watch 'purchaseData.origin_certificate_file', ->
    PurchaseService.create $scope.purchaseData

