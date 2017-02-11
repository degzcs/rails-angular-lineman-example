angular.module('app').factory 'AuthorizedProviderService', ($resource, $upload, $http, $mdDialog, $state, SignatureService) ->
  service =

    uploadProgress: 0
    isCompany: false
    model: #IMPORTANT NOTE: The model must to have the same structure of the entity
      provider_type: ''
      rucom_id: ''
      email: ''
      first_name: ''
      last_name: ''
      document_number: ''
      phone_number: ''
      address: ''
      id_document_file: ''
      mining_authorization_file: ''
      rut_file: ''
      photo_file: ''
      signature_picture: ''
      city_id: ''
      state_id: ''
      use_wacom_device: true
      rucom:
        rucom_number: ''

    #
    # Get the buy agreetment from settings
    #
    habeas_data_agreetment: (page) ->
      if page
        return $http
                   method: "GET"
                   url: "api/v1/agreetments/habeas_data_agreetment"
                   params: page: page
      else
        return $http
                   method: "GET"
                   url: "api/v1/agreetments/habeas_data_agreetment"

# -----------------------------------------------------------
     all: (per_page,page)->
      #$mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/authorized_providers'
                method: 'GET'
                params: {
                  per_page: per_page || 10,
                  page: page || 1
                }

# -----------------------------------------------------------
    get: (id)->
      #$mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/authorized_providers/'+id
                method: 'GET'

# -----------------------------------------------------------
    update: (id)->
      # Rearrange all files to upload to get them easyly
      filesToUpload = {
        idDocumentFile: service.model.id_document_file,
        rutFile: service.model.rut_file,
        photoFile: service.model.photo_file,
        signaturePicture: service.model.signature_picture
      }

      # Final files that will be uplaoded by the $upload service
      blobFiles = {
        idDocumentFile: '',
        rutFile: '',
        photoFile: '',
        signaturePicture: ''
      }

      blobUtil.imgSrcToBlob(filesToUpload.photoFile).then( (photoFileBlob) ->
        photoFileBlob.name = 'photo_file.png'
        # Other Files
        if service.model.use_wacom_device == false
          signaturePictureBlob = service.fakeSignaureBlob()
          signaturePictureBlob.name = 'signature_picture.png'
          blobFiles.photoFile = photoFileBlob
          blobFiles.signaturePicture = signaturePictureBlob
          convertAndUploadFiles(filesToUpload, blobFiles)
        else
          blobUtil.imgSrcToBlob(filesToUpload.signaturePicture).then( (signaturePictureBlob) ->
            signaturePictureBlob.name = 'signature_picture.png'
            blobFiles.signaturePicture = signaturePictureBlob
            blobFiles.photoFile = photoFileBlob
            convertAndUploadFiles(filesToUpload, blobFiles)
          ).catch (err) ->
            #console.log '[SERVICE-ERROR]: image signature failed to load: ' + err
      ).catch (err) ->
        #console.log '[SERVICE-ERROR]: image photo failed to load: ' + err
#------------------------------------------------------------
      #
      # Funtion to convert the files
      #
      convertAndUploadFiles= (filesToUpload, blobFiles) ->
        # Id Document File
        filesRemaining = 0
        if filesToUpload.idDocumentFile
          # if !(filesToUpload.id_document_file[0] instanceof File)
          #   filesToUpload.id_document_file[0].name = 'id_document_file.pdf'
          # else
          # NOTE: this part is used to convert the image/ in a blob image and can change the filename
          idDocumentFileCopy = filesToUpload.idDocumentFile
          idDocumentReader = new FileReader

          idDocumentReader.onload = ->
            idDocumentArray = createBinaryFile(@result)
            blobFiles.idDocumentFile = createBlobFile(idDocumentArray, 'id_document_file', idDocumentFileCopy[0])
            --filesRemaining
            if filesRemaining <= 0
              uploadFiles(blobFiles)
            return

          idDocumentReader.readAsBinaryString idDocumentFileCopy[0]
          filesRemaining++

        #--------------------------------------------------------------------
        # rut file
        if filesToUpload.rutFile
          # if !(filesToUpload.rut_file[0] instanceof File)
          #   filesToUpload.rut_file[0].name = 'rut_file.pdf'
          # else
          # NOTE: this part is used to convert the image/ in a blob image and can change the filename
          rutFileCopy = filesToUpload.rutFile
          rutReader = new FileReader

          rutReader.onload = ->
            rutArray = createBinaryFile(@result)
            blobFiles.rutFile = createBlobFile(rutArray, 'rut_file', rutFileCopy[0])
            --filesRemaining
            if filesRemaining <= 0
              uploadFiles(blobFiles)
            return

          rutReader.readAsBinaryString rutFileCopy[0]
          filesRemaining++
        #-------------------------------------------------------------------------
        #Files Upload
        if filesRemaining <= 0
          uploadFiles(blobFiles)
        return


#------------------------------------------------------------
      #
      # Funtion to convert the files in a array valid with the Binary format to then convert it as Blob to send it by PUT Request
      #
      createBinaryFile= (result) ->
        `var i`
        i = undefined
        l = undefined
        d = undefined
        array = undefined
        d = result
        l = d.length
        array = new Uint8Array(l)
        i = 0
        while i < l
          array[i] = d.charCodeAt(i)
          i++
        return array

#------------------------------------------------------------
      #
      # Converts files to Blob type
      #
      createBlobFile= (array, fileName, fileCopy) ->
        file = null
        ext = fileCopy.name.substring(fileCopy.name.lastIndexOf('.'))
        file = new Blob([ array ], type: 'application/octet-stream')
        file.name = fileName + ext
        return file

#------------------------------------------------------------
      files = []
      uploadFiles= (blobFiles) ->
        if blobFiles.photoFile
          files.push blobFiles.photoFile
        if blobFiles.idDocumentFile
          files.push blobFiles.idDocumentFile
        if blobFiles.rutFile
          files.push blobFiles.rutFile
        if blobFiles.signaturePicture
          files.push blobFiles.signaturePicture
        $upload.upload(
          url: '/api/v1/authorized_providers/' + id
          method: 'PUT'
          headers: {'Content-Type': 'application/json'}
          fields:
            "authorized_provider[email]":service.model.email,
            "profile[first_name]":service.model.first_name,
            "profile[last_name]":service.model.last_name,
            "profile[phone_number]":service.model.phone_number,
            "profile[address]":service.model.address,
            "profile[city_id]":service.model.city_id,
            "rucom[rucom_number]":service.model.rucom.rucom_number
          file: files
          fileFormDataName: 'files[]')
        .progress((evt) ->
          #console.log 'progress: ' + service.uploadProgress + '% ' + evt.config.file
          service.uploadProgress = parseInt(100.0 * evt.loaded / evt.total)
          return
        ).success( (data, status, headers, config)->
          $mdDialog.show $mdDialog.alert().title('Felicitaciones').content('El usuario a sido creado').ariaLabel('Alert Dialog Demo').ok('ok')
          $state.go "index_authorized_provider"
          service.clearModel()
          return
        ).error (data, status, headers, config)->
          #
          #TODO: This message has to be validated in case of error
          #
          $mdDialog.show $mdDialog.alert().title('Alerta - Hubo inconvenientes').content('El Productor no pudo ser Actualizado!').ariaLabel('Alert Dialog Demo').ok('ok')
          $state.go "index_authorized_provider"
          service.clearModel()
          return

#-----------------------------------------------------------------

    byIdNumber: (idNumber, providerType) ->
      return $http
                url: '/api/v1/authorized_providers/by_id_number'
                method: 'GET'
                params: {
                  rol_name: providerType # 'Barequero o chatarrero'
                  id_type: 'CEDULA'
                  id_number: idNumber
                }
#-----------------------------------------------------------------

    queryById: (id, per_page, page) ->
      return $http
                url: 'api/v1/authorized_providers'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_id: id
                }
#-----------------------------------------------------------------

    queryByName: (name,per_page,page)->
      return $http
                url: 'api/v1/authorized_providers'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_name: name
                }
    queryByRucom_id: (rucomid,per_page,page)->
      return $http
                url: 'api/v1/authorized_providers'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_rucomid: rucomid
                }

#-----------------------------------------------------------------
    saveModel: ->
      sessionStorage.authorizedProviderService = angular.toJson(service.model)

    restoreModel: ->
      if sessionStorage.authorizedProviderService != null
        service.model = angular.fromJson(sessionStorage.authorizedProviderService)
        service.model
      else
        service.model


    clearModel: ->
      sessionStorage.authorizedProviderService = null
      service.isCompany= false
      service.model =
        provider_type: ''
        rucom_id: ''
        authorized_provider:
          email: ''
        profile:
          first_name: ''
          last_name: ''
          document_number: ''
          phone_number: ''
          address: ''
          id_document_file: ''
          mining_authorization_file: ''
          photo_file: ''
          city_id: ''
          state_id: ''
        rucom:
          rucom_number: ''
        files:
          photo_file: ''
          document_number_file: ''
          mining_register_file: ''
          chamber_of_commerce_file: ''
          rut_file: ''
          signature_picture: ''

    updateBasicInfo: (id)->
      return $http
                url: '/api/v1/authorized_providers/update_basic_info/' + id
                method: 'PUT'
                params:
                  'authorized_provider[email]': service.model.email,
                  'profile[phone_number]': service.model.phone_number,
                  'profile[address]': service.model.address


    # function for clone Blobs objects this avoid the references object issue
    clone: (obj) ->
      if null == obj or 'object' != typeof obj
       return obj
      copy = new Blob
      for attr of obj
       if obj.hasOwnProperty(attr)
         copy[attr] = obj[attr]
      copy
    fakeSignaureBlob: ->
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

  return service