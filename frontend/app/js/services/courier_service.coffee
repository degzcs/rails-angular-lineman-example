angular.module('app').factory 'CourierService', ($resource, $upload , $http) ->
  retrieveCouriers = $resource('/api/v1/couriers',
    per_page: '@per_page'
    page: '@page'
    id_document_number: '@id_document_number')

  retrieveCourierById = (id) ->
    return $http
              url: '/api/v1/couriers/'+ id, 
              method: 'GET'
  
  create = (courier) ->
    $resource '/api/v1/couriers/', {}, 'save':
      method: 'POST'
      params:
        'courier[first_name]': courier.first_name
        'courier[id_document_number]': courier.id_document_number
        'courier[id_document_type]': courier.id_document_type
        'courier[last_name]': courier.last_name
        'courier[phone_number]': courier.phone_number
        'courier[address]': courier.address
        'courier[company_name]': courier.company_name
        'courier[nit_company_number]': courier.nit_company_number

  #Can call edit like so:
  #$resource = CourierService.edit($scope.currentCourier);
  #  if($resource){
  #   $resource .update({ id:$scope.currentCourier.id }, $scope.currentCourier);
  # }

  edit = (courier) ->
    $resource '/api/v1/couriers/:id', { id: '@id' }, 'update':
      method: 'PUT'
      params:
        'courier[first_name]': courier.first_Name
        'courier[id_document_number]': courier.id_document_number
        'courier[id_document_type]': courier.id_document_type
        'courier[last_name]': courier.last_Name
        'courier[phone_number]': courier.phone_number
        'courier[address]': courier.address
        'courier[company_name]': courier.company_name
        'courier[nit_company_number]': courier.nit_company_number

  queryById = (id, per_page, page)->
    return $http
              url: 'api/v1/couriers/'
              method: 'GET'
              params: {
                per_page: per_page || 10
                page: page || 1
                id_document_number: id
              }

  {
    retrieveCouriers: retrieveCouriers
    create: create
    edit: edit
    query_by_id: queryById
    retrieveCourierById: retrieveCourierById
  }
