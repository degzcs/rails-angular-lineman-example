angular.module('app').controller 'SidebarCtrl', ($scope, $timeout, $mdSidenav, $auth, $state) ->

  #  Here just add the sidebar navigation options with their state
  $scope.options = [
    {name: "Dashboard", state: "dashboard", icon: 'action:dashboard'}
    {name: "Certificados de Origen", state: "new_origin_certificate", icon: 'action:pageview'}
    {name: "Compras", state: "new_purchase.step1", icon: 'action:add_shopping_cart'}
    {name: "Inventario", state: "index_inventory", icon: 'action:assignment'}
    {name: "Proovedores" , state: "providers", icon: 'social:people'}
    {name: "transportadores", state: "new_courier", icon: 'maps:local_shipping'}
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