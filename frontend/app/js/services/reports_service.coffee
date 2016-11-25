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
          file = new Blob([ data ], type: 'application/pdf')
          fileURL = URL.createObjectURL(file)
          window.open(fileURL, '_blank', '')
          return
        ).error (data, status, headers, config)->
          $mdDialog.show $mdDialog.alert().title('Alerta - Hubo inconvenientes').content(data.detail[0]).ok('ok')
          return

      fakeBlob= ->
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

        base64 = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAB1klEQVR42n2TzytEURTHv3e8N1joRhZG' + 'zJsoCjsLhcw0jClKWbHwY2GnLGUlIfIP2IjyY2djZTHSMJNQSilFNkz24z0/Ms2MrnvfvMu8mcfZvPvu' + 'Pfdzz/mecwgKLNYKb0cFEgXbRvwV2s2HuWazCbzKA5LvNecDXayBjv9NL7tEpSNgbYzQ5kZmAlSXgsGG' + 'XmS+MjhKxDHgC+quyaPKQtoPYMQPOh5U9H6tBxF+Icy/aolqAqLP5wjWd5r/Ip3YXVILrF4ZRYAxDhCO' + 'J/yCwiMI+/xgjOEzmzIhAio04GeGayIXjQ0wGoAuQ5cmIjh8jNo0GF78QwNhpyvV1O9tdxSSR6PLl51F' + 'nIK3uQ4JJQME4sCxCIRxQbMwPNSjqaobsfskm9l4Ky6jvCzWEnDKU1ayQPe5BbN64vYJ2vwO7CIeLIi3' + 'ciYAoby0M4oNYBrXgdgAbC/MhGCRhyhCZwrcEz1Ib3KKO7f+2I4iFvoVmIxHigGiZHhPIb0bL1bQApFS' + '9U/AC0ulSXrrhMotka/lQy0Ic08FDeIiAmDvA2HX01W05TopS2j2/H4T6FBVbj4YgV5+AecyLk+Ctvms' + 'QWK8WZZ+Hdf7QGu7fobMuZHyq1DoJLvUqQrfM966EU/qYGwAAAAASUVORK5CYII='
        binary = fixBinary(atob(base64))
        blob = new Blob([ binary ], type: 'image/png')

      #
      # Main Process
      #
      if useWacomDevice == false
        uploadFile(fakeBlob())
      else
        blobUtil.imgSrcToBlob(signaturePicture).then((signaturePictureBlob) ->
          signaturePictureBlob.name = 'signature_picture.png'
          uploadFile(signaturePictureBlob)
        ).catch (err) ->
          console.log '[SERVICE-ERROR]: image signature failed to load: ' + err
      return