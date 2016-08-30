angular.module('app').factory 'SignatureService', ($resource, $upload, $http, $mdDialog, $state) ->

  service =
    wgssSignatureSDK: null
    sigObj: null
    sigCtl: null
    dynCapt: null
    # Show the exeptions
    Exception: (txt)->
      @print("Exception: " + txt)

    # Allows to print text in the PC screen
    print: (txt) ->
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
      @print 'CLEAR'
      @restartSession callback
      return

    # Allows restart the signature session and shows up if the devices is connected or not.
    # @param callback [ Function ]
    restartSession: (callback) ->

      timedDetect: ->
        if wgssSignatureSDK.running
          print 'Signature SDK Service detected.'
          start()
        else
          print 'Signature SDK Service not detected.'
        return

      onDetectRunning: ->
        if wgssSignatureSDK.running
          print 'Signature SDK Service detected.'
          clearTimeout timeout
          start()
        else
          print 'Signature SDK Service not detected.'
        return

      start: ->
        if wgssSignatureSDK.running
          sigCtl = new (wgssSignatureSDK.SigCtl)(onSigCtlConstructor)
        return

      onSigCtlConstructor: (sigCtlV, status) ->
        if wgssSignatureSDK.ResponseStatus.OK == status
          dynCapt = new (wgssSignatureSDK.DynamicCapture)(onDynCaptConstructor)
        else
          print 'SigCtl constructor error: ' + status
        return

      onDynCaptConstructor: (dynCaptV, status) ->
        if wgssSignatureSDK.ResponseStatus.OK == status
          sigCtl.GetSignature onGetSignature
        else
          print 'DynCapt constructor error: ' + status
        return

      onGetSignature: (sigCtlV, sigObjV, status) ->
        if wgssSignatureSDK.ResponseStatus.OK == status
          sigObj = sigObjV
          sigCtl.GetProperty 'Component_FileVersion', onSigCtlGetProperty
        else
          print 'SigCapt GetSignature error: ' + status
        return

      onSigCtlGetProperty: (sigCtlV, property, status) ->
        if wgssSignatureSDK.ResponseStatus.OK == status
          print 'DLL: flSigCOM.dll  v' + property.text
          dynCapt.GetProperty 'Component_FileVersion', onDynCaptGetProperty
        else
          print 'SigCtl GetProperty error: ' + status
        return

      onDynCaptGetProperty: (dynCaptV, property, status) ->
        if wgssSignatureSDK.ResponseStatus.OK == status
          print 'DLL: flSigCapt.dll v' + property.text
          print 'Test application ready.'
          print 'Press \'Start\' to capture a signature.'
          if 'function' == typeof callback
            callback()
        else
          print 'DynCapt GetProperty error: ' + status
        return

      wgssSignatureSDK = null
      sigObj = null
      sigCtl = null
      dynCapt = null
      imageBox = document.getElementById('imageBox')
      if null != imageBox.firstChild
        imageBox.removeChild imageBox.firstChild
      timeout = setTimeout(timedDetect, 1500)
      # pass the starting service port  number as configured in the registry
      wgssSignatureSDK = new WacomGSS_SignatureSDK(onDetectRunning, 8000)
      return

  return service
