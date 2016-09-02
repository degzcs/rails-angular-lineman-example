angular.module('app').factory 'SignatureService', ($resource, $upload, $http, $mdDialog, $state) ->

  service =
    imageId: ''
    wgssSignatureSDK: null
    sigObj: null
    sigCtl: null
    dynCapt: null
    authorizedProviderName: 'Proveedor Autorizado'
    # Show the exeptions
    Exception: (txt)->
      service.printInBox("Exception: " + txt)

    # Allows to printInBox text in the PC screen
    printInBox: (txt) ->
      txtDisplay = document.getElementById('txtDisplay')
      if 'CLEAR' == txt
        txtDisplay.value = ''
      else
        txtDisplay.value += txt + '\n'
        txtDisplay.scrollTop = txtDisplay.scrollHeight
        # scroll to end
      return

    #
    OnLoad: (callback) ->
      service.printInBox 'CLEAR'
      @restartSession callback
      return

    # Allows restart the signature session and shows up if the devices is connected or not.
    # @param callback [ Function ]
    restartSession: (callback) ->
      timedDetect= ->
        if service.wgssSignatureSDK.running
          service.printInBox 'Servicio SDK de firma detectado.'
          start()
        else
          service.printInBox 'Servicio SDK de firma no detectado.'
        return

      onDetectRunning= ->
        if service.wgssSignatureSDK.running
          service.printInBox 'Servicio SDK de firma detectado.'
          clearTimeout timeout
          start()
        else
          service.printInBox 'Servicio SDK de firma no detectado.'
        return

      start= ->
        if service.wgssSignatureSDK.running
          service.sigCtl = new (service.wgssSignatureSDK.SigCtl)(onSigCtlConstructor)
        return

      onSigCtlConstructor= (sigCtlV, status) ->
        if service.wgssSignatureSDK.ResponseStatus.OK == status
          service.dynCapt = new (service.wgssSignatureSDK.DynamicCapture)(onDynCaptConstructor)
        else
          service.printInBox 'SigCtl constructor error: ' + status
        return

      onDynCaptConstructor= (dynCaptV, status) ->
        if service.wgssSignatureSDK.ResponseStatus.OK == status
          service.sigCtl.GetSignature onGetSignature
        else
          service.printInBox 'DynCapt constructor error: ' + status
        return

      onGetSignature= (sigCtlV, sigObjV, status) ->
        if service.wgssSignatureSDK.ResponseStatus.OK == status
          service.sigObj = sigObjV
          service.sigCtl.GetProperty 'Component_FileVersion', onSigCtlGetProperty
        else
          service.printInBox 'SigCapt GetSignature error: ' + status
        return

      onSigCtlGetProperty= (sigCtlV, property, status) ->
        if service.wgssSignatureSDK.ResponseStatus.OK == status
          #service.printInBox 'DLL: flSigCOM.dll  v' + property.text
          service.dynCapt.GetProperty 'Component_FileVersion', onDynCaptGetProperty
        else
          service.printInBox 'SigCtl GetProperty error: ' + status
        return

      onDynCaptGetProperty= (dynCaptV, property, status) ->
        if service.wgssSignatureSDK.ResponseStatus.OK == status
          #service.printInBox 'DLL: flSigCapt.dll v' + property.text
          service.printInBox 'La aplicacion esta lista!!!'
          service.printInBox 'Presione el boton \'FIRMAR\' para capturar la firma.'
          if 'function' == typeof callback
            callback()
        else
          service.printInBox 'DynCapt GetProperty error: ' + status
        return
      imageBox = document.getElementById('imageBox')
      if null != imageBox.firstChild
        imageBox.removeChild imageBox.firstChild
      timeout = setTimeout(timedDetect, 1500)
      # pass the starting service port  number as configured in the registry
      service.wgssSignatureSDK = new WacomGSS_SignatureSDK(onDetectRunning, 8000)
      return

    #
    #  Capture functions
    #
    Capture: ->
      onDynCaptCapture= (dynCaptV, SigObjV, status) ->
        if service.wgssSignatureSDK.ResponseStatus.INVALID_SESSION == status
          service.printInBox 'Error: invalid session. Restarting the session.'
          service.restartSession window.Capture
        else
          if service.wgssSignatureSDK.DynamicCaptureResult.DynCaptOK != status
            service.printInBox 'Capture returned: ' + status
          switch status
            when service.wgssSignatureSDK.DynamicCaptureResult.DynCaptOK
              service.sigObj = SigObjV
              service.printInBox 'Signature captured successfully'
              flags = service.wgssSignatureSDK.RBFlags.RenderOutputBase64 | service.wgssSignatureSDK.RBFlags.RenderColor24BPP
              imageBox = document.getElementById('imageBox')
              service.sigObj.RenderBitmap 'bmp', imageBox.clientWidth, imageBox.clientHeight, 0.7, 0x00000000, 0x00FFFFFF, flags, 0, 0, service.imageId, onRenderBitmap
            when service.wgssSignatureSDK.DynamicCaptureResult.DynCaptCancel
              service.printInBox 'Signature capture cancelled'
            when service.wgssSignatureSDK.DynamicCaptureResult.DynCaptPadError
              service.printInBox 'No capture service available'
            when service.wgssSignatureSDK.DynamicCaptureResult.DynCaptError
              service.printInBox 'Tablet Error'
            when service.wgssSignatureSDK.DynamicCaptureResult.DynCaptIntegrityKeyInvalid
              service.printInBox 'The integrity key parameter is invalid (obsolete)'
            when service.wgssSignatureSDK.DynamicCaptureResult.DynCaptNotLicensed
              service.printInBox 'No valid Signature Capture licence found'
            when service.wgssSignatureSDK.DynamicCaptureResult.DynCaptAbort
              service.printInBox 'Error - unable to parse document contents'
            else
              service.printInBox 'Capture Error ' + status
              break
        return

      onRenderBitmap= (sigObjV, bmpObj, status) ->
        if service.wgssSignatureSDK.ResponseStatus.OK == status
          imageBox = document.getElementById('imageBox')
          if null == imageBox.firstChild
            imageBox.appendChild bmpObj.image
          else
            imageBox.replaceChild bmpObj.image, imageBox.firstChild
        else
          service.printInBox 'Signature Render Bitmap error: ' + status
        return

      if !service.wgssSignatureSDK.running or null == service.dynCapt
        service.printInBox 'Session error. Restarting the session.'
        service.restartSession window.Capture
        return
      service.dynCapt.Capture service.sigCtl, service.authorizedProviderName, 'Compra Mineral', null, null, onDynCaptCapture
      return
  return service
