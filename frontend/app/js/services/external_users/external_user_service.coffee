angular.module('app').factory 'ExternalUser', ($resource, $upload, $http, $mdDialog) ->
  
  all = (per_page,page)->
    $mdDialog.show(templateUrl: 'partials/loading.html')
    return $http
              url: 'api/v1/external_users'
              method: 'GET'
              params: {
                per_page: per_page || 10,
                page: page || 1
              }
  query_by_name = (name)->
    return $http
              url: 'api/v1/external_users'
              method: 'GET'
              params: {
                per_page: 10
                page: 1
                query_name: name
              }
  query_by_id = (id)->
    return $http
              url: 'api/v1/external_users'
              method: 'GET'
              params: {
                per_page: 10
                page: 1
                query_id: id
              }
  query_by_rucom_id = (rucomid)->
    return $http
              url: 'api/v1/external_users'
              method: 'GET'
              params: {
                per_page: 10
                page: 1
                query_rucomid: rucomid
              }
  return {
    all: all
    query_by_name: query_by_name
    query_by_id: query_by_id
    query_rucomid: query_by_rucom_id
  }