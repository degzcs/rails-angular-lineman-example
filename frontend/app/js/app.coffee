angular.module("app", [
  "ngResource"
  "ngMessages"
  "ui.router"
  "mgcrea.ngStrap"
  "satellizer"
  "ngMaterial"
  'ncy-angular-breadcrumb'
  'angularFileUpload'
  'jcs.angular-http-batch'
]).run ($rootScope) ->

  # adds some basic utilities to the $rootScope for debugging purposes
  $rootScope.log = (thing) ->
    console.log thing
    return

  $rootScope.alert = (thing) ->
    alert thing
    return

  # Restore the state of models, e.g. purchase.model on PurchaseService
  $rootScope.$on '$routeChangeStart', (event, next, current) ->
    if sessionStorage.restorestate == 'true'
      $rootScope.$broadcast 'restorePurchaseState'
      #let everything know we need to restore state
      sessionStorage.restorestate = false

  # Restore the state of models when is reloade the page, e.g. purchase.model on PurchaseService
  window.onload = (e)->
    if sessionStorage.restorestate == 'true'
      console.log('restoring models...')
      $rootScope.$broadcast 'restorePurchaseState'
      $rootScope.$broadcast 'restoreGoldBatchState'
      #let everything know we need to restore state
      # sessionStorage.restorestate = false

  # Save the state of models, e.g. purchase.model on PurchaseService
  # let everthing know that we need to save state now.
  window.onbeforeunload = (event) ->
    $console.log('saving state ...')
    $rootScope.$broadcast 'savePurchaseState'

.config ($mdIconProvider) ->
  $mdIconProvider
    .iconSet('social', 'img/icons/sets/social-icons.svg', 24)
    .iconSet('action', 'img/icons/sets/action-icons.svg', 24)
    .iconSet('alert', 'img/icons/alert-icons.svg', 24)
    .iconSet('av', 'img/icons/sets/v-icons.svg', 24)
    .iconSet('communication', 'img/icons/sets/communication-icons.svg', 24)
    .iconSet('content', 'img/icons/sets/content-icons.svg', 24)
    .iconSet('device', 'img/icons/sets/device-icons.svg', 24)
    .iconSet('editor', 'img/icons/sets/editor-icons.svg', 24)
    .iconSet('file', 'img/icons/sets/file-icons.svg', 24)
    .iconSet('hardware', 'img/icons/sets/hardware-icons.svg', 24)
    .iconSet('icons', 'img/icons/sets/icons-icons.svg', 24)
    .iconSet('image', 'img/icons/sets/image-icons.svg', 24)
    .iconSet('maps', 'img/icons/sets/maps-icons.svg', 24)
    .iconSet('navigation', 'img/icons/sets/navigation-icons.svg', 24)
    .iconSet('notification', 'img/icons/sets/notification-icons.svg', 24)
    .iconSet('social', 'img/icons/sets/social-icons.svg', 24)
    .iconSet('toggle', 'img/icons/sets/toggle-icons.svg', 24)
    .defaultIconSet 'img/icons/sets/core-icons.svg', 24
  return

.config ($mdThemingProvider) ->
    $mdThemingProvider.theme('docs-dark', 'default')
      .primaryPalette('yellow')
      .dark();



# TODO: Check if the http batcher is working!! Im testing with diferent setups buts i dont see any change

.config [
  'httpBatchConfigProvider'
  (httpBatchConfigProvider) ->
    httpBatchConfigProvider.setAllowedBatchEndpoint 'http://localhost:3000', 
    'http://localhost:3000/api/v1/inventories/:id', 
    {
      maxBatchedRequestPerCall: 20
    }
    return
]


