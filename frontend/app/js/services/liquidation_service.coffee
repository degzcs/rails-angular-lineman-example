
angular.module('app').factory 'LiquidationService', ($http)-> 
  service = 
    model:
      selectedPurchases: null
      totalAmount: 0
      ingots_number: 0

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