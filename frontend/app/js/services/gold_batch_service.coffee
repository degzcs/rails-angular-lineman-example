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
      grade: 1
      grams: 0 # the introduced grams  by the seller or provider
      castellanos: 0
      ozs: 0
      tomines: 0
      reales: 0
      granos: 0
      total_grams: 0
      total_fine_grams: 0
      mineral_type: ''

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
    deleteState: ->
      sessionStorage.goldBatchService = []

  #
  # Listeners
  #
  $rootScope.$on 'saveGoldBatchState', service.saveState
  $rootScope.$on 'restoreGoldBatchState', service.restoreState

  #
  # Return
  #
  service