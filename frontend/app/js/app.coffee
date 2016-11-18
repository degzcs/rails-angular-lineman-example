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
  'infinite-scroll'
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
      $rootScope.$broadcast 'restorePurchaseState'
      $rootScope.$broadcast 'restoreGoldBatchState'
      #??
      # sessionStorage.restorestate = false

  # Save the state of models, e.g. purchase.model on PurchaseService
  # let everthing know that we need to save state now.
  window.onbeforeunload = (event) ->
    # $console.log('saving state ...')
    # $rootScope.$broadcast 'savePurchaseState'

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
    .iconSet('logo_trazoro_black', 'img/icons/landing/logo-trazoro-black.svg', 24)
    .defaultIconSet 'img/icons/sets/core-icons.svg', 24
  return

.config ($mdThemingProvider) ->
  goldYellow = $mdThemingProvider.extendPalette('yellow', {
    '500': 'edb039'
  });
  $mdThemingProvider.definePalette('goldYellow', goldYellow);

  $mdThemingProvider.theme('default')
    .primaryPalette('goldYellow')
    .accentPalette('orange');
  $mdThemingProvider.theme('docs-dark', 'default')
    .primaryPalette('yellow')
    .dark();
  $mdThemingProvider.theme('landTheme')
    .dark();
# #fff blanco, #edcf36 amarillo, negro opaco #1a1a1a, negro negro #000000


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

# TODO: figure it out why is this here!!
#GLOBAL METHODS
Number::formatMoney = (c, d, t) ->
  `var t`
  `var d`
  `var c`
  n = this
  c = if isNaN(c = Math.abs(c)) then 2 else c
  d = if d == undefined then '.' else d
  t = if t == undefined then ',' else t
  s = if n < 0 then '-' else ''
  i = parseInt(n = Math.abs(+n or 0).toFixed(c)) + ''
  j = if (j = i.length) > 3 then j % 3 else 0
  s + (if j then i.substr(0, j) + t else '') + i.substr(j).replace(/(\d{3})(?=\d)/g, '$1' + t) + (if c then d + Math.abs(n - i).toFixed(c).slice(2) else '')


