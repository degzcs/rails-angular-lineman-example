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
    buy_agreetment: (page) ->
      if page
        return $http
                   method: "GET"
                   url: "api/v1/agreetments/buy_agreetment"
                   params: page: page
      else
        return $http
                   method: "GET"
                   url: "api/v1/agreetments/buy_agreetment" 

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
        miningAuthorizationFile: service.model.mining_authorization_file,
        photoFile: service.model.photo_file,
        signaturePicture: service.model.signature_picture
      }

      # Final files that will be uplaoded by the $upload service
      blobFiles = {
        idDocumentFile: '',
        miningAuthorizationFile: '',
        photoFile: '',
        signaturePicture: ''
      }

      blobUtil.imgSrcToBlob(filesToUpload.photoFile).then((photoFile) ->
        blobFiles.photoFile = photoFile
        blobFiles.photoFile.name = 'photo_file.png'
        # Other Files
        if service.use_wacom_device == false
          blobFiles.signaturePicture = photoFile
          blobFiles.signaturePicture.name = 'signature_picture.png'
          convertAndUploadFiles(filesToUpload, blobFiles)
        else
          blobUtil.imgSrcToBlob(filesToUpload.signaturePicture).then((signaturePicture) ->
            blobFiles.signaturePicture = signaturePicture
            blobFiles.signaturePicture.name = 'signature_picture.png'
            convertAndUploadFiles(filesToUpload, blobFiles)
          ).catch (err) ->
            console.log '[SERVICE-ERROR]: image signature failed to load: ' + err
      ).catch (err) ->
        console.log '[SERVICE-ERROR]: image photo failed to load: ' + err
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
        # mining_authorization file
        if filesToUpload.miningAuthorizationFile
          # if !(filesToUpload.mining_authorization_file[0] instanceof File)
          #   filesToUpload.mining_authorization_file[0].name = 'mining_authorization_file.pdf'
          # else
          # NOTE: this part is used to convert the image/ in a blob image and can change the filename
          miningAuthorizationFileCopy = filesToUpload.miningAuthorizationFile
          miningAuthorizationReader = new FileReader

          miningAuthorizationReader.onload = ->
            miningAuthorizationArray = createBinaryFile(@result)
            blobFiles.miningAuthorizationFile = createBlobFile(miningAuthorizationArray, 'mining_authorization_file', miningAuthorizationFileCopy[0])
            --filesRemaining
            if filesRemaining <= 0
              uploadFiles(blobFiles)
            return

          miningAuthorizationReader.readAsBinaryString miningAuthorizationFileCopy[0]
          filesRemaining++
        #-------------------------------------------------------------------------
        # signature_picture file
        if filesToUpload.signaturePicture
          signaturePictureFileCopy = filesToUpload.signaturePicture
          signaturePictureReader = new FileReader

          signaturePictureReader.onload = ->
            signaturePictureArray = createBinaryFile(@result)
            blobFiles.signaturePicture = createBlobFile(signaturePictureArray, 'signature_picture', signaturePictureFileCopy[0])
            --filesRemaining
            if filesRemaining <= 0
              uploadFiles(blobFiles)
            return

          signaturePictureReader.readAsBinaryString signaturePictureFileCopy[0]
          filesRemaining++

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
        console.log blobFiles.signaturePicture
        if blobFiles.photoFile
          files.push blobFiles.photoFile
        if blobFiles.idDocumentFile
          files.push blobFiles.idDocumentFile
        if blobFiles.miningAuthorizationFile
          files.push blobFiles.miningAuthorizationFile
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
          fileFormDataName: 'files[]').progress((evt) ->
          console.log 'progress: ' + service.uploadProgress + '% ' + evt.config.file
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

    byIdNumber: (idNumber, rolName) ->
      return $http
                url: '/api/v1/authorized_providers/by_id_number'
                method: 'GET'
                params: {
                  rol_name: rolName # 'Barequero o chatarrero'
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

  return service