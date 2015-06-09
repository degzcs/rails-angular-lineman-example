#
# This service is in charge to manage the server requests related to Purchases
#
#TODO: make the remaining HTTP requests
angular.module('app').factory 'PurchaseService', ($location, $rootScope, $upload , $http,$mdDialog)->
  service=
    #
    # Service impl
    #
    impl: this

    #
    # Model
    #
    model:
      type: 'provider'
      price: 0
      seller_picture: ''
      sale_id: ''
      provider: {}
      origin_certificate_sequence: ''
      origin_certificate_file: ''
      fine_gram_unit_price: 0 # this is set up for current buyer (currently logged user )
      reference_code: ''
      barcode_html: ''
      code: ''
      trazoro: ''
      sale_id: ''
      gold_batch: ''
      #barcode_html: ''
      code: ''
      rucom_id_field: ''

    #
    # HTTP resquests
    #
    create: (purchase, gold_batch) ->
      # if purchase.origin_certificate_file and purchase.seller_picture
      i = 0
      files = []
      ###### Convert data:image base 64 to Blob and use the callback to send the request to save the purchase in DB
      blobUtil.imgSrcToBlob(purchase.seller_picture).then((seller_picture_blob) ->
        ##IMPROVE: Setup the filenames in order to receive them properly in server side.
        ## I am using a Regx in server to know which files is each one
        seller_picture_blob.name = 'seller_picture.png'
        if purchase.origin_certificate_file[0]
          files = [purchase.origin_certificate_file[0], seller_picture_blob]
        else
          js_pdf = new jsPDF()
          files = [seller_picture_blob]

        $upload.upload(
          # headers: {'Content-Type': file.type},
          url: '/api/v1/purchases/'
          method: 'POST'
          fields:
            "purchase[price]": purchase.price,
            "purchase[provider_id]": purchase.provider.id
            "purchase[sale_id]": purchase.sale_id
            #"gold_batch[parent_batches]": gold_batch.parent_batches
            "gold_batch[fine_grams]": gold_batch.total_fine_grams
            "gold_batch[grade]": gold_batch.grade # < -- This is "la ley" in spanish, used to calculate fine grams from grams, see more in measure_converter_service.coffee file
            "gold_batch[inventory_id]": gold_batch.inventory_id
            "purchase[origin_certificate_sequence]": purchase.origin_certificate_sequence
          file: files
          fileFormDataName: 'purchase[files][]')

        .progress((evt) ->
            # progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
            # console.log 'progress: ' + progressPercentage + '% ' + evt.config.file.name
            console.log 'progress: ' + service.impl.uploadProgress + '% ' + evt.config.file
            service.impl.uploadProgress = parseInt(100.0 * evt.loaded / evt.total)
        )

        .success (data, status, headers, config) ->
            console.log '[SERVICE-LOG]: uploaded file !!!!' ##+ config.file.name + ' uploaded. Response: ' + data
            # window.response = data
            model = angular.fromJson(sessionStorage.purchaseService)
            model.barcode_html = data.barcode_html
            model.code = data.code
            sessionStorage.purchaseService = angular.toJson(model)
            service.model = model
            #service.flushModel()
            # if !data.status == 500
            $location.path('/purchases/show')
            $mdDialog.show $mdDialog.alert().title('Felicitaciones').content('la compra ha sido creada').ariaLabel('Alert Dialog Demo').ok('ok')
            
            # else
              # show an error message
        ).catch (err) ->
          console.log '[SERVICE-ERROR]: image failed to load!!'
          service.restoreState()
          # $location.path('/purchases/new/step1')
        # image failed to load
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
    # Get a single purchase by id
    #
    get: (id)->
      return $http({method: "GET", url: "api/v1/purchases/" + id})

    get_list: (ids)->
      console.log "IDS"
      console.log ids
      return $http.get('api/v1/purchases', params:
                "purchase_list[]": ids)
    flushModel: ->
      service.model = {
        type: 'provider'
      }
      sessionStorage.removeItem('purchaseService')
      return



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