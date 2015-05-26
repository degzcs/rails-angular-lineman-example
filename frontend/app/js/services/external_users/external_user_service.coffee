angular.module('app').factory 'ExternalUser', ($resource, $upload, $http, $mdDialog) ->
  service =
    #modelToCreate:
    modelToUpdate:
      company:
        name: ''
      external_user:
        phone_number: ''
        email: ''
        address: ''
        population_center_id: ''

    all: (per_page,page)->
      $mdDialog.show(templateUrl: 'partials/loading.html')
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10,
                  page: page || 1
                }
    get: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html')
      return $http
                url: 'api/v1/external_users/'+id
                method: 'GET'
    
    update_external_user: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html')
      console.log service.modelToUpdate.external_user
      return $http
                url: 'api/v1/external_users/'+id
                method: 'PUT'
                data: {
                  external_user: service.modelToUpdate.external_user
                }

    query_by_name: (name,per_page,page)->
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_name: name
                }
    query_by_id: (id,per_page,page)->
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_id: id
                }
    query_by_rucom_id: (rucomid,per_page,page)->
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_rucomid: rucomid
                }
  return service