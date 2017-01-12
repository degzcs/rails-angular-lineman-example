angular.module('app').factory 'ReportsService', ($resource, $upload, $http, $mdDialog, $state, SignatureService) ->
  service =
    generateRoyaltiesDocument: (signaturePicture, period, selectedYear, mineralPresentation, baseLiquidationPrice, royaltyPercentage, useWacomDevice) ->
      #
      # Uplaod signature picture and sent request
      #
      uploadFile= (signaturePictureBlob) ->
        $upload.upload(
          url: '/api/v1/reports/royalties'
          method: 'POST'
          headers: {'Content-Type': 'application/pdf'}
          fields:
            "period": period,
            "selected_year": selectedYear,
            "mineral_presentation": mineralPresentation,
            "base_liquidation_price": baseLiquidationPrice,
            "royalty_percentage": royaltyPercentage,
          file: signaturePictureBlob
          fileFormDataName: 'signature_picture'
        ).progress((evt) ->
          console.log 'progress: ' + service.uploadProgress + '% ' + evt.config.file
          service.uploadProgress = parseInt(100.0 * evt.loaded / evt.total)
          return
        ).success( (data, status, headers, config)->
          #file = new Blob([ data ], type: 'application/pdf')
          #fileURL = URL.createObjectURL(file)
          window.open(data, '_blank', '')
          return
        ).error (data, status, headers, config)->
          $mdDialog.show $mdDialog.alert().title('Alerta - Hubo inconvenientes').content(data.detail[0]).ok('ok')
          return

      fakeSignaureBlob= ->
        # From http://stackoverflow.com/questions/14967647/ (continues on next line)
        # encode-decode-image-with-base64-breaks-image (2013-04-21)
        fixBinary = (bin) ->
          length = bin.length
          buf = new ArrayBuffer(length)
          arr = new Uint8Array(buf)
          i = 0
          while i < length
            arr[i] = bin.charCodeAt(i)
            i++
          buf

        base64 = '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'
        binary = fixBinary(atob(base64))
        blob = new Blob([ binary ], type: 'image/png')

      #
      # Main Process
      #
      if useWacomDevice == false
        uploadFile(fakeSignaureBlob())
      else
        blobUtil.imgSrcToBlob(signaturePicture).then((signaturePictureBlob) ->
          signaturePictureBlob.name = 'signature_picture.png'
          uploadFile(signaturePictureBlob)
        ).catch (err) ->
          console.log '[SERVICE-ERROR]: image signature failed to load: ' + err
      return

    #
    # Generate the transaction movements file processed by tax module 
    #
    generateTransactionMovements: (transaction_id) ->
      return $http.get('api/v1/reports/' + transaction_id + '/transaction_movements')