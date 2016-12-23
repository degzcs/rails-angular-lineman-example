#
# This service is in charge to manage the server requests related to Purchases
#
#TODO: make the remaining HTTP requests
angular.module('app').factory 'PurchaseService', ($location, $rootScope, $upload, $http, $mdDialog, $state)->
  service=
    #
    # Service impl
    #

    impl: this

    #
    # Model
    #

    model:
      type: 'seller'
      price: 0
      seller_picture: ''
      inventory_id: ''
      seller: {} # TODO: udpate seller variable name for seller
      origin_certificate_sequence: ''
      origin_certificate_file_url: ''
      proof_of_purchase_file_url: ''
      fine_gram_unit_price: 0 # this is set up for current buyer (currently logged user )
      fine_gram_unit_price_to_buy: 0 # this is set up for current buyer (currently logged user )
      reference_code: ''
      barcode_html: ''
      code: ''
      trazoro: ''
      gold_batch: {}
      #barcode_html: ''
      code: ''
      rucom_id_field: ''
      signature_picture: ''
      use_wacom_device: true

    #
    # HTTP resquests
    #

    create: (purchase, gold_batch) ->
      i = 0
      files = []

      ###### Convert data:image base 64 to Blob and use the callback to send the request to save the purchase in DB
      blobUtil.imgSrcToBlob(purchase.seller_picture).then( (seller_picture_blob) ->
        seller_picture_blob.name = 'seller_picture.png'
        signature_picture_blob = ''

        if purchase.use_wacom_device == false
          signature_picture_blob = seller_picture_blob
          signature_picture_blob.name = 'signature.png'
          files = [seller_picture_blob, signature_picture_blob]
          service.uploadFiles(files, purchase, gold_batch)
        else
          blobUtil.imgSrcToBlob(purchase.signature_picture).then( (signature_picture_blob) ->
            signature_picture_blob.name = 'signature.png'
            files = [seller_picture_blob, signature_picture_blob]
            service.uploadFiles(files, purchase, gold_batch)
          ).catch (err) ->
            console.log '[SERVICE-ERROR]: image signature failed to load!!'
            location.path('/purchases/new/purchases/step4')
            $mdDialog.show $mdDialog.alert().title('Error').content(err).ok('ok')
            $mdDialog.show $mdDialog.alert().title('Error').content(err.data.detail[0]).ok('ok')
            service.restoreState()
      )
      .catch (err) ->
        console.log '[SERVICE-ERROR]: image seller_picture failed to load!!' + err
        $location.path('/purchases/new/purchases/step4')
        $mdDialog.show $mdDialog.alert().title('Error').content(err).ok('ok')
        $mdDialog.show $mdDialog.alert().title('Error').content(err.data.detail[0]).ok('ok')
        service.restoreState()

    uploadFiles: (files, purchase, gold_batch) ->
      $upload.upload(
        headers: {'Content-Type': 'application/json'}
        url: '/api/v1/purchases/'
        method: 'POST'
        fields:
          "purchase[price]": purchase.price,
          "purchase[seller_id]": purchase.seller.id
          #"purchase[inventory_id]": purchase.inventory_id
          "gold_batch[fine_grams]": gold_batch.total_fine_grams
          "gold_batch[grade]": gold_batch.grade # < -- This is "la ley" in spanish, used to calculate fine grams from grams, see more in measure_converter_service.coffee file
          "gold_batch[extra_info]": { grams: gold_batch.total_grams, castellanos: gold_batch.castellanos, ozs: gold_batch.ozs, tomines: gold_batch.tomines, reales: gold_batch.reales, granos: gold_batch.granos }
          #"purchase[origin_certificate_sequence]": purchase.origin_certificate_sequence
          "gold_batch[mineral_type]": gold_batch.mineral_type
        file: files
        fileFormDataName: 'purchase[files][]')

      .progress(
        (evt) ->
          console.log 'progress: ' + service.impl.uploadProgress + '% ' + evt.config.file
          service.impl.uploadProgress = parseInt(100.0 * evt.loaded / evt.total)
      )
      .success(
        (data, status, headers, config) ->
          console.log '[SERVICE-LOG]: uploaded file !!!!' ##+ config.file.name + ' uploaded. Response: ' + data
          model = angular.fromJson(sessionStorage.purchaseService)
          model.barcode_html = data.barcode_html
          model.code = data.code
          model.proof_of_purchase_file_url = data.proof_of_purchase_file_url
          model.origin_certificate_file_url = data.origin_certificate_file_url
          sessionStorage.purchaseService = angular.toJson(model)
          service.model = model
          $location.path('/purchases/show')
          $mdDialog.show $mdDialog.alert().title('Felicitaciones').content('la compra ha sido creada').ok('ok')
      )
      .catch (err) ->
        # console.log 'Excedio el limite de creditos' + err
        $mdDialog.show $mdDialog.alert().title('Error').content(err.data.detail[0]).ok('ok')
        $state.go('new_purchase.step2')
        service.restoreState()
      return


    #
    # Save, restore and  delete model temporal states
    #
    saveState: ->
      sessionStorage.restorestate = 'true'
      sessionStorage.purchaseService = angular.toJson(service.model)
    restoreState: ->
      if(sessionStorage.purchaseService)
        service.model = angular.fromJson(sessionStorage.purchaseService)
      else
        sessionStorage.restorestate = 'false'
    deleteState: ->
      sessionStorage.purchaseService = []
    #
    # Get all paginated purchases for the current user
    #
    all: (page)->
      if page
        return $http
                 method: "GET"
                 url: "api/v1/purchases"
                 params: page: page
      else
        return $http
                 method: "GET"
                 url: "api/v1/purchases"

    #
    # Get all Free paginated purchases to Sale for the current user
    #
    all_free: (page)->
      if page
        return $http
                 method: "GET"
                 url: "api/v1/purchases/free_to_sale"
                 params: page: page
      else
        return $http
                 method: "GET"
                 url: "api/v1/purchases/free_to_sale"

    #
    # Get a single purchase by id
    #
    get: (id)->
      return $http({method: "GET", url: "api/v1/purchases/" + id})

    #
    # Get all purchases
    #
    get_list: (ids)->
      return $http.get('api/v1/purchases', params:
                "purchase_list[]": ids)
    flushModel: ->
      service.model = {
        type: 'seller'
      }
      sessionStorage.removeItem('purchaseService')
      return

    #
    # Get all Order by transaction state
    #
    getAllByState: (state) ->
      return $http.get('api/v1/purchases/by_state/'+state)

  #
  # Set uploadProgress variable
  #
  service.impl.uploadProgress = 0

  #
  # Listeners
  #
  # console.log(service)
  $rootScope.$on 'savePurchaseState', service.saveState
  $rootScope.$on 'restorePurchaseState', service.restoreState

  #
  # Return
  #
  service