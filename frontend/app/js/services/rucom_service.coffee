angular.module('app').factory 'RucomService', ($resource,$mdDialog, $http) ->
  service =
    currentRucom: {}

    setCurrentRucom: (rucom)->
      service.currentRucom = rucom

    getCurrentRucom: ->
      return service.currentRucom
    
    all: (per_page,page)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/rucoms'
                method: 'GET'
                params: {
                  per_page: per_page || 10,
                  page: page || 1
                }
    
    get: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/rucoms/'+id
                method: 'GET'
    
    check_is_available: (rucom)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/rucoms/'+id+'/check_is_available'
                method: 'GET'
