angular.module('app').controller 'SidebarCtrl', ($scope, $timeout, $mdSidenav, $auth, $state) ->
  #  Here just add the sidebar navigation options with their state
  $scope.options = [
    {name: "Dashboard", state: "dashboard", icon: 'action:dashboard'}
    {name: "Comprar", state: "new_purchase.step1", icon: 'action:add_shopping_cart'}
    {name: "Certificados de Origen", state: "new_origin_certificate", icon: 'action:pageview'}
    {name: "Inventario", state: "index_inventory", icon: 'action:assignment'}
    {name: "Clientes", state: "clients", icon: 'social:people_outline'}
    {name: "Provedores" , state: "providers", icon: 'social:people'}
    # {name: "Transportadores", state: "new_courier", icon: 'maps:local_shipping'}
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
  $scope.logout = ->
    if !$auth.isAuthenticated()
      return
    $auth.logout().then ->
      $mdDialog.show $mdDialog.alert()
        .title('Logout')
        .content('Adios!')
        .ok('Adios!!')
        duration: 2
      return
  $scope.getNavigationClass = (button)->
    if $state.current.name.indexOf(button)> -1
      return"selected"
  return