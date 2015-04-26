
angular.module('app').factory 'SaleService', ($http)-> 
  service = 

    model:
      selectedPurchases: null
      totalAmount: 0
      ingots_number: 0

    create: (sale, gold_batch)->
      console.log(sale)
      console.log(gold_batch)
      return $http.post("api/v1/sales", {sale: sale, gold_batch: gold_batch})
    
    saveState: ->
      sessionStorage.restoreSale = 'true'
      sessionStorage.saleService = angular.toJson(service.model)
      console.log 'Sale Saved'

    restoreState: ->
      if(sessionStorage.saleService)
        service.model = angular.fromJson(sessionStorage.saleService)
      else
        sessionStorage.restoreSale = 'false'


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