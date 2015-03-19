angular.module('app').controller 'SidebarCtrl', ($scope, $timeout, $mdSidenav, $log) ->
  $scope.options = [
    {name: "Login" , url: "login"}
    {name: "Home" , url: "home"}
    {name: "Scanner Test" , url: "scanner"}
    {name: "Providers" , url: "providerList"}
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