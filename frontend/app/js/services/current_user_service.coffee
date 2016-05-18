# NOTE: read the next article to upgrade the way to save value in the clien side
# https://stormpath.com/blog/where-to-store-your-jwts-cookies-vs-html5-web-storage
# and perhaps use this library that help to encrypt the data on clint-site
# https://github.com/jas-/secStore.js
# read this article as well
# http://security.stackexchange.com/questions/89937/is-html5-sessionstorage-secure-for-temporarily-storing-a-cryptographic-key
# TODO: see if it is better save the values in the server-side (ex BD like preferences or settings)
angular.module('app').factory 'CurrentUser', ($http) ->
  service=
    get: ->
      $http
        method: 'GET'
        url: 'api/v1/users/me'
    settings:
      # @param item [ Object ] ex. { name: 'Alan Britho'}
      set: (item)->
        items = angular.fromJson(sessionStorage.currentUserSettings) || {}
        new_items = angular.extend(items, item)
        sessionStorage.currentUserSettings = angular.toJson(new_items)
      # @param key [ String ] ex. 'name'
      # @return [ String ]
      get: (key)->
        items = angular.fromJson(sessionStorage.currentUserSettings) || {}
        items[key]
      clean: ->
        sessionStorage.currentUserSettings = nil
  service