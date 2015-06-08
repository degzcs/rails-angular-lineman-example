
angular.module('app').factory 'RucomService', ($resource,$mdDialog, $http) ->
  service =
    currentRucom: null
    user_type: ''

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
    
    check_if_available: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/rucoms/'+id+'/check_if_available'
                method: 'GET'

    query_by_name: (name,per_page,page)->
      return $http
                url: 'api/v1/rucoms'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_name: name
                }
    query_by_rucom_num: (rucom_num,per_page,page)->
      return $http
                url: 'api/v1/rucoms'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_rucom_number: rucom_num
                }
