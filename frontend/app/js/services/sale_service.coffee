
angular.module('app').factory 'SaleService', ($http, $rootScope)->
  service =

    model:
      id: null
      courier: null
      buyer: null
      user_id: null
      gold_batch_id: null
      code: null
      price: null
      purchase_files_collection: null
      shipment: null
      proof_of_sale: null
      barcode_html: null
      selectedPurchases: null #=>  example: {[purchase_id: 1,amount_picked: 2.3]}
      associatedPurchases: null
      totalAmount: null
      fixed_sale_agreetment: null
      weightedLaw: null


    create: (sale_params, gold_batch_params, selectedPurchases)->
      return $http.post("api/v1/sales", {sale: sale_params, gold_batch: gold_batch_params,selected_purchases: selectedPurchases})

    saveState: ->
      sessionStorage.restoreSale = 'true'
      sessionStorage.saleService = angular.toJson(service.model)

    restoreState: ->
      if(sessionStorage.restoreSale)
        service.model = angular.fromJson(sessionStorage.saleService)
        return service.model
      else
        sessionStorage.restoreSale = 'false'

    deleteState: ->
      sessionStorage.pendingLiquidation = 'false'
      sessionStorage.saleService = null  

    get_by_code: (code)->
      return $http.get("api/v1/sales/get_by_code/"+code)

    get: (id)->
      return $http.get("api/v1/sales/"+id)

    getBatches: (id)->
      return $http.get("api/v1/sales/"+id+"/batches")

    getFixedSaleAgreetment: ->
      return $http.get("api/v1/agreetments/fixed_sale")

    #
    # Get all sales paged for the current user  
    #
    all_paged: (page)->
      if page
        return $http
                 method: "GET"
                 url: "api/v1/sales"
                 params: page: page
      else
        return $http
                 method: "GET"
                 url: "api/v1/sales"

    #
    #Get all sales
    #
    get_list: (ids)->
      return $http.get('api/v1/sales', params:
                "sales_list[]": ids)
    #setSaleInfo: function(sale_info){
    #  sessionStorage.setItem('saleInfo',JSON.stringify(sale_info));
    #  console.log(JSON.parse(sessionStorage.getItem('saleInfo')));
    #},
    #getSaleInfo: function(){
    #  sale_info =JSON.parse(sessionStorage.getItem('saleInfo'));
    #  return sale_info;
    #}
  #
  # Return
  #
  service