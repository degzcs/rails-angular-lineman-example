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
      seller_picture: ''
      provider: {}
      origin_certificate_sequence: ''
      origin_certificate_file: ''
      law: 1
      fine_gram_unit_price: 0 # this is set up for current buyer (current user login)

    #
    # HTTP resquests
    #
    create: (purchase, gold_batch) ->
      if purchase.seller_picture and purchase.seller_picture.length
        i = 0
        files = []
        ###### Convert data:image base 64 to Blob and use the callback to send the request to save the purchase in DB
        blobUtil.imgSrcToBlob(purchase.seller_picture).then((seller_picture_blob) ->
          ##IMPROVE: Setup the filenames in order to receive them properly in server side.
          ## I am using a Regx in server to know which files is each one
          seller_picture_blob.name = 'seller_picture.png'

          files = [purchase.origin_certificate_file[0], seller_picture_blob]
          console.log files
          $upload.upload(
            # headers: {'Content-Type': file.type},
            url: '/api/v1/purchases/'
            method: 'POST'
            fields:
              "purchase[price]": purchase.price,
              "purchase[provider_id]": purchase.provider.id
              "gold_batch[parent_batches]": gold_batch.parent_batches
              "gold_batch[grams]": gold_batch.total_fine_grams
              "gold_batch[grade]": gold_batch.grade # < -- What is this?
              "gold_batch[inventory_id]": gold_batch.inventory_id
              "purchase[origin_certificate_sequence]": purchase.origin_certificate_sequence
            file: files
            fileFormDataName: 'purchase[files][]')

          .progress((evt) ->
              progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
              console.log 'progress: ' + progressPercentage + '% ' + evt.config.file.name
          )

          .success (data, status, headers, config) ->
              console.log 'file ' + config.file.name + ' uploaded. Response: ' + data
          # i++
          ).catch (err) ->
          # image failed to load
          return

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
    # convert from data:image to Blob
    # convert: ->
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