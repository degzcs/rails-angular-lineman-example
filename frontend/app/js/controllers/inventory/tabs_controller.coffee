angular.module('app').controller 'InventoryTabsCtrl', ($timeout, $scope, $mdDialog, CurrentUser) ->
  CurrentUser.get().success (data) ->
    $scope.response = CurrentUser.can_genearate_royalties_document(data)