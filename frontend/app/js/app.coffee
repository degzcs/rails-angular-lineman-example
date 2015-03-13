angular.module("app", [
  "ngResource"
  "ngMessages"
  "ui.router"
  "mgcrea.ngStrap"
  "satellizer"
]).run ($rootScope) ->

  # adds some basic utilities to the $rootScope for debugging purposes
  $rootScope.log = (thing) ->
    console.log thing
    return

  $rootScope.alert = (thing) ->
    alert thing
    return

  return
