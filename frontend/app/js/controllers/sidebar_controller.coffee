angular.module('app').controller 'SidebarCtrl', ($scope, $timeout, $mdSidenav, $auth, $state) ->

  #  Here just add the sidebar navigation options with their state
  $scope.options = [
    {name: "Dashboard", state: "dashboard"}
    {name: "Providers" , state: "providers"}
    {name: "Inventory", state: "index_inventory"}
    {name: "Couriers", state: "new_courier"}
    {name: "Compras", state: "new_purchase.step1"}
    {name: "Certificados de Origen", state: "new_origin_certificate"}
  ]


  $scope.allowSidebar= ->
      unless $state.current.name == "home" || $state.current.name == "new_session"
        return true
      else
        return false

  $scope.close = ->
    $mdSidenav('left').close().then ->
      # $log.debug 'close LEFT is done'
      return
    return

  $scope.toggleLeft = ->
    $mdSidenav('left').toggle().then ->
      # $log.debug 'toggle LEFT is done'
      return
    return

  return