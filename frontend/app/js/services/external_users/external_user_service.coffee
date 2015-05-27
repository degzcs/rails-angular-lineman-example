angular.module('app').factory 'ExternalUser', ($resource, $upload, $http, $mdDialog) ->
  service =
    modelToCreate:
      external_user:
        first_name: ''
        last_name: ''
        email: ''
        document_number: ''
        document_expedition_date: ''
        phone_number: ''
        address: ''
        rucom_id: ''
        population_center_id: ''
        user_type: ''
        document_number_file: ''
        mining_register_file: ''
        rut_file: ''
        chamber_commerce_file: ''
        photo_file: ''
      company:
        nit_number: ''
        name: ''
        city: ''
        state: ''
        country: ''
        legal_representative: ''
        id_type_legal_rep: ''
        id_number_legal_rep: ''
        email: ''
        phone_number: ''

    modelToUpdate:
      company:
        phone_number: ''
        email: ''
      external_user:
        phone_number: ''
        email: ''
        address: ''
        population_center_id: ''


    all: (per_page,page)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10,
                  page: page || 1
                }
    get: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/external_users/'+id
                method: 'GET'
    
    update_external_user: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/external_users/'+id
                method: 'PUT'
                data: {
                  external_user: service.modelToUpdate.external_user
                }
    
    update_external_user_company: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/external_users/'+id
                method: 'PUT'
                data: {
                  company: service.modelToUpdate.company
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
    saveModelToCreate: ->
      sessionStorage.external_user_to_create = angular.toJson(service.modelToCreate)
    restoreModelToCreate: ->
      if(sessionStorage.external_user_to_create)
        service.modelToCreate = angular.fromJson(sessionStorage.external_user_to_create)
      return service.modelToCreate
  return service