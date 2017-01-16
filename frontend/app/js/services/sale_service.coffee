
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
      transaction_state: null
      use_wacom_device: true
      report_url: null


    create: (sale_params, gold_batch_params, selectedPurchases, selectedSaleType)->
      if selectedSaleType == 'directly_buyer'
        return $http.post("api/v1/sales", {sale: sale_params, gold_batch: gold_batch_params,selected_purchases: selectedPurchases})
      else if selectedSaleType == 'marketplace'
        return $http.post("api/v1/sales/marketplace", {sale: sale_params, gold_batch: gold_batch_params, selected_purchases: selectedPurchases})

    buyRequest: (saleId)->
      return $http.put("api/v1/sales/buy_request", {sale_id: saleId})

    rejectBuyer: (saleId, buyerId)->
      return $http.put("api/v1/sales/reject_buyer", {sale_id: saleId, buyer_id: buyerId})

    # TODO: Change this when is created the PurhcaseRequest state machine
    acceptBuyer: (saleId, buyerId) ->
      return $http
                  method: 'GET'
                  url: 'api/v1/sales/'+saleId+'/transition'
                  params:
                    buyer_id: buyerId
                    transition: 'send_info!'

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
    # Get all sales by transaction state as seller
    #
    getAllByState: (state)->
      return $http.get('api/v1/sales/by_state/'+state)

    #
    # Get all sales by state published
    #
    getAllForMarketplace: ->
      return $http.get("api/v1/sales/marketplace")

    #
    # Trigger a transaction on transaction state field by the transition
    #
    trigger_transition: (id, transition) ->
      return $http
                  method: 'GET'
                  url: 'api/v1/sales/'+id+'/transition'
                  params: transition: transition

    #
    # Get the buy agreetment from settings
    #
    fixed_sale_agreetment: (page) ->
      if page
        return $http
                   method: "GET"
                   url: "api/v1/agreetments/fixed_sale"
                   params: page: page
      else
        return $http
                   method: "GET"
                   url: "api/v1/agreetments/fixed_sale"


    #
    #Get all sales
    #
    get_list: (ids)->
      return $http.get('api/v1/sales', params:
                "sales_list[]": ids)

    saveModel: ->
      sessionStorage.saleService = angular.toJson(service.model)

    restoreModel: ->
      if sessionStorage.saleService != null
        service.model = angular.fromJson(sessionStorage.saleService)
        return service.model
      else
        return service.model


    clearModel: ->
      sessionStorage.saleService = null
      service.model =
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
        transaction_state: null
        use_wacom_device: true

  #
  # Return
  #
  service