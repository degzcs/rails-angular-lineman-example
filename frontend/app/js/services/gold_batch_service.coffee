#
# This service is in charge to save the GoldBatch model
#
angular.module('app').factory('GoldBatchService', ($rootScope, MeasureConverterService)->
  service= new ( ->
    #
    # Model
    #
    @model=
      parent_batches: ''
      grams: 0
      castellanos: 0
      ozs: 0
      tomines: 0
      riales: 0
      inventory_id: ''

    #
    # Save and restore model temporal states
    #
    @saveState= ->
      sessionStorage.restorestate = 'true'
      sessionStorage.goldBatchService = angular.toJson(service.model)
    @restoreState= ->
      if(sessionStorage.goldBatchService)
        service.model = angular.fromJson(sessionStorage.goldBatchService)
      else
        sessionStorage.restorestate = 'false'
    #
    # Measue Unit Price (COP)
    #
    @gramUnitPrice= '1000' # TODO= put this value in some of tables in the DB

    @castellanoUnitPrice= MeasureConverterService.castellanosUnitPriceFrom(@gramUnitPrice)

    @ozUnitPrice= MeasureConverterService.ozsUnitPriceFrom(@gramUnitPrice)

    @tominUnitPrice= MeasureConverterService.tominesUnitPriceFrom(@gramUnitPrice)

    @rialUnitPrice= MeasureConverterService.rialesUnitPriceFrom(@gramUnitPrice)

    #
    # Convertions
    #
    @castellanosToGrams= MeasureConverterService.castellanosToGrams(@model.castellanos)

    @ozsToGrams= MeasureConverterService.ozsToGrams(@model.ozs)

    @tominesToGrams= MeasureConverterService.tominesToGrams(@model.tomines)

    @rialesToGrams= MeasureConverterService.rialesToGrams(@model.riales)

    #
    # Calculate Partial prices for each measure introduced
    #
    @priceBasedOnCastellanos= @gramUnitPrice*@castellanosToGrams

    @priceBasedOnOzs= @gramUnitPrice*@ozsToGrams

    @priceBasedOnTomines= @gramUnitPrice*@tominesToGrams

    @priceBasedOnRials= @gramUnitPrice*@rialesToGrams

  )
  #
  # Listeners
  #
  $rootScope.$on 'saveGoldBatchState', service.saveState
  $rootScope.$on 'restoreGoldBatchState', service.restoreState

  #
  # Return
  #
  service
)