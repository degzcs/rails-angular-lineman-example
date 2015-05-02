
angular.module('app').factory 'SaleService', ($http)-> 
  service = 
    
    model: 
      id: null
      courier_id: null
      client_id: null
      user_id: null
      gold_batch_id: null 
      grams: null
      code: null
      barcode_html: null
      selectedPurchases: null #=>  example: {[purchase_id: 1,amount_picked: 2.3]}
      totalAmount: null

    create: (sale_params, gold_batch_params,selectedPurchases)->
      return $http.post("api/v1/sales", {sale: sale_params, gold_batch: gold_batch_params,selected_purchases: selectedPurchases})

    saveState: ->
      sessionStorage.restoreSale = 'true'
      sessionStorage.saleService = angular.toJson(service.model)
      console.log 'Sale Saved'

    restoreState: ->
      if(sessionStorage.restoreSale)
        service.model = angular.fromJson(sessionStorage.saleService)
        return service.model
      else
        sessionStorage.restoreSale = 'false'
        
    get_by_code: (code)->
      return $http.get("api/v1/sales/"+code)

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