angular.module('app').factory 'User', ($http) ->
  { get: (id) ->
      return $http
        method: 'GET'
        url: 'api/v1/users/' + id
    query_by_name: (name,per_page,page)->
      return $http
                url: 'api/v1/users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_name: name
                }
    query_by_id: (id,per_page,page)->
      return $http
                url: 'api/v1/users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_id: id
                }
    query_by_rucom_id: (rucomid,per_page,page)->
      return $http
                url: 'api/v1/users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_rucomid: rucomid
                }
  }
