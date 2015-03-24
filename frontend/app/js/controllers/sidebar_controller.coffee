angular.module('app').controller 'SidebarCtrl', ($scope, $timeout, $mdSidenav, $auth) ->

  #  Here just add the sidebar navigation options with their state
  $scope.options = [
    {name: "Dashboard", state: "dashboard"}
  #  {name: "Scanner Test" , state: "scanner"}
    {name: "Providers" , state: "providers"}
    {name: "Inventory", state: "batches"}
    {name: "Transporter", state: "new_transporter"}
  ]
  
  $scope.close = ->
    $mdSidenav('left').close().then ->
      $log.debug 'close LEFT is done'
      return
    return

  $scope.toggleLeft = ->
    $mdSidenav('left').toggle().then ->
      $log.debug 'toggle LEFT is done'
      return
    return

  return