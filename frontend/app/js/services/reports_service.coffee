angular.module('app').factory 'ReportsService', ($resource, $upload, $http, $mdDialog, $state, SignatureService) ->
  service =
    generateRoyaltiesDocument: (signaturePicture, period, selectedYear, mineralPresentation, baseLiquidationPrice, royaltyPercentage, useWacomDevice) ->
      #
      # Uplaod signature picture and sent request
      #
      uploadFile= (signaturePictureBlob) ->
        $upload.upload(
          url: '/api/v1/reports/royalties'
          method: 'GET'
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
            # TODO: open generated file window.open
          return
        ).error (data, status, headers, config)->
          $mdDialog.show $mdDialog.alert().title('Alerta - Hubo inconvenientes').content(data.detail[0]).ok('ok')
          return
      #
      # Main Process
      #
      if useWacomDevice == false
        uploadFile(new Blob())
      else
        blobUtil.imgSrcToBlob(signaturePicture).then((signaturePictureBlob) ->
          signaturePictureBlob.name = 'signature_picture.png'
          uploadFile(signaturePictureBlob)
        ).catch (err) ->
          console.log '[SERVICE-ERROR]: image signature failed to load: ' + err
      return