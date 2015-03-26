angular.module("app", [
  "ngResource"
  "ngMessages"
  "ui.router"
  "mgcrea.ngStrap"
  "satellizer"
  "ngMaterial"
  'ncy-angular-breadcrumb'
]).run ($rootScope) ->

  # adds some basic utilities to the $rootScope for debugging purposes
  $rootScope.log = (thing) ->
    console.log thing
    return

  $rootScope.alert = (thing) ->
    alert thing
    return

  return

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
      .primaryPalette('blue')
      .dark();
