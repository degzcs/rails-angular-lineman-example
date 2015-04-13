#
# This service is in charge to save the GoldBatch model
#
angular.module('app').factory 'GoldBatchService', ($rootScope)->
  service=
    #
    # Model
    #
    model:
      parent_batches: ''
      grams: 0 # the introduced grams  by the seller or provider
      castellanos: 0
      ozs: 0
      tomines: 0
      riales: 0
      inventory_id:  1
      total_grams: 0
      total_fine_grams: 0

    #
    # Save and restore model temporal states
    saveState: ->
      sessionStorage.restorestate = 'true'
      sessionStorage.goldBatchService = angular.toJson(service.model)
    restoreState: ->
      if(sessionStorage.goldBatchService)
        service.model = angular.fromJson(sessionStorage.goldBatchService)
      else
        sessionStorage.restorestate = 'false'

  #
  # Listeners
  #
  $rootScope.$on 'saveGoldBatchState', service.saveState
  $rootScope.$on 'restoreGoldBatchState', service.restoreState

  #
  # Return
  #
  service