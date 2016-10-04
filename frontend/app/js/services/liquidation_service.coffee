
angular.module('app').factory 'LiquidationService', ($http)-> 
  service = 
    model:
      selectedPurchases: null #=>  example: {[purchase_id: 1,amount_picked: 2.3]}
      totalAmount: 0
      selectedClient: null
      price: 0
      weightedLaw: 0

    
    saveState: ->
      sessionStorage.pendingLiquidation = 'true'
      sessionStorage.liquidationService = angular.toJson(service.model)
      console.log 'liquidation Saved'

    restoreState: ->
      if(sessionStorage.pendingLiquidation)
        service.model = angular.fromJson(sessionStorage.liquidationService)
      else
        sessionStorage.pendingLiquidation = 'false'

    deleteState: ->
      sessionStorage.pendingLiquidation = 'false'
      sessionStorage.liquidationService = null


  service