#
# This service is in charge to manage the server requests related to Purchases
#
#TODO: make the remaining HTTP requests
angular.module('app').factory 'PurchaseService', ($rootScope, $upload)->
  service=
    #
    # Model
    #
    model:
      price: 0
      provider_photo_file: ''
      provider: {}
      origin_certificate_sequence: ''
      origin_certificate_file: ''
      law: 1
      totalGrams: 0
    #
    # HTTP resquests
    #
    create: (purchase, gold_batch) ->
      if purchase.origin_certificate_file and purchase.origin_certificate_file.length
        i = 0
        while i < purchase.origin_certificate_file.length
          file = purchase.origin_certificate_file[i]
          $upload.upload(
            url: '/api/v1/purchases/'
            method: 'POST'
            fields:
              "purchase[price]": purchase.price,
              "purchase[provider_id]": purchase.provider.id
              "gold_batch[parent_batches]": gold_batch.parent_batches
              "gold_batch[grams]": gold_batch.totalGrams
              "gold_batch[grade]": gold_batch.law # Which is the real name?
              "gold_batch[inventory_id]": gold_batch.inventory_id
              "purchase[origin_certificate_sequence]": purchase.origin_certificate_sequence
            file: file
            fileFormDataName: 'purchase[origin_certificate_file]')

          .progress((evt) ->
              progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
              console.log 'progress: ' + progressPercentage + '% ' + evt.config.file.name
          )

          .success (data, status, headers, config) ->
              console.log 'file ' + config.file.name + 'uploaded. Response: ' + data
          i++

    #
    # Save model temporal states
    #
    saveState: ->
      sessionStorage.restorestate = 'true'
      sessionStorage.purchaseService = angular.toJson(service.model)
    restoreState: ->
      if(sessionStorage.purchaseService)
        service.model = angular.fromJson(sessionStorage.purchaseService)
      else
        sessionStorage.restorestate = 'false'

  #
  # Listeners
  #
  console.log(service)
  $rootScope.$on 'savePurchaseState', service.saveState
  $rootScope.$on 'restorePurchaseState', service.restoreState

  #
  # Return
  #
  service