angular.module('app').factory 'AuthorizedProviderService', ($resource, $upload, $http, $mdDialog, RucomService, $state) ->
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
      city_id: ''
      state_id: ''
      rucom:
        rucom_number: ''

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
                url: 'api/v1/external_users/'+id
                method: 'GET'

# -----------------------------------------------------------
    update: (id)->
      # Rearrange all files to upload to get them easyly
      filesToUpload = {
        id_document_file: service.model.id_document_file,
        mining_authorization_file: service.model.mining_authorization_file,
        photo_file: service.model.photo_file,
      }

      # Final files that will be uplaoded by the $upload service
      blobFiles ={
        id_document_file: '',
        mining_authorization_file: '',
        photo_file: '',
      }

      blobUtil.imgSrcToBlob(filesToUpload.photo_file).then (photo_file) ->
        photo_file.name = 'photo_file.png'
        # Other Files
        filesRemaining = 0;

# -----------------------------------------------------------
        # Id Document File
        if filesToUpload.id_document_file
          # if !(filesToUpload.id_document_file[0] instanceof File)
          #   filesToUpload.id_document_file[0].name = 'id_document_file.pdf'
          # else
          # NOTE: this part is used to convert the image/ in a blob image and can change the filename
          id_document_file_copy = filesToUpload.id_document_file
          idDocumentReader = new FileReader
          fileName = 'id_document_file'

          idDocumentReader.onload = ->
            array = createBinaryFile(@result)
            blobFiles.id_document_file = createBlobFile(array, fileName, id_document_file_copy[0])
            --filesRemaining
            if filesRemaining <= 0
              uploadFiles()
            return

          idDocumentReader.readAsBinaryString id_document_file_copy[0]
          filesRemaining++

#--------------------------------------------------------------------
        # mining_authorization file
        if filesToUpload.mining_authorization_file
          # if !(filesToUpload.mining_authorization_file[0] instanceof File)
          #   filesToUpload.mining_authorization_file[0].name = 'mining_authorization_file.pdf'
          # else
          # NOTE: this part is used to convert the image/ in a blob image and can change the filename
          mining_authorization_file_copy = filesToUpload.mining_authorization_file
          miningAuthorizationReader = new FileReader
          fileName = 'mining_authorization_file'

          miningAuthorizationReader.onload = ->
            array = createBinaryFile(@result)
            blobFiles.mining_authorization_file = createBlobFile(array, fileName, mining_authorization_file_copy[0])
            --filesRemaining
            if filesRemaining <= 0
              uploadFiles()
            return

          miningAuthorizationReader.readAsBinaryString mining_authorization_file_copy[0]
          filesRemaining++

        #Files Upload
        if filesRemaining <= 0
          uploadFiles()

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
        file = []
        ext = fileCopy.name.substring(fileCopy.name.lastIndexOf('.'))
        file.push new Blob([ array ], type: 'application/octet-stream')
        file[0].name = fileName + ext
        return file[0]

#------------------------------------------------------------
      files =[]
      uploadFiles= () ->
        # if blobFiles.photo_file
        #   files.push blobFiles.photo_file
        if blobFiles.id_document_file
          files.push blobFiles.id_document_file
        if blobFiles.mining_authorization_file
          files.push blobFiles.mining_authorization_file
        console.log files
        $upload.upload(
          url: '/api/v1/authorized_providers/' + id
          method: 'PUT'
          headers: {'Content-Type': 'application/json'}
          fields:
            "email":service.model.email,
            "first_name":service.modelfirst_name,
            "last_name":service.modellast_name,
            "phone_number":service.modelphone_number,
            "address":service.modeladdress,
            "city_id":service.modelcity_id,
            "rucom_number":service.model.rucom.rucom_number
          file: files
          fileFormDataName: 'profile[files][]').progress((evt) ->
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
    queryById: (id,per_page,page) ->
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_id: id
                }
#-----------------------------------------------------------------

    byIdNumber: (idNumber) ->
      return $http
                url: '/api/v1/authorized_providers/by_id_number'
                method: 'GET'
                params: {
                  rol_name:'Barequero'
                  id_type: 'CEDULA'
                  id_number: idNumber
                }

#-----------------------------------------------------------------
    saveModel: ->
      sessionStorage.authorized_provider = angular.toJson(service.model)

    restoreModel: ->
      files = service.model.files
      if sessionStorage.authorized_provider != null
        service.model = angular.fromJson(sessionStorage.authorized_provider)
        service.model.files = files
        service.model
      else
        service.model


    clearModel: ->
      RucomService.provider_type = ''
      RucomService.currentRucom = null
      sessionStorage.authorized_provider = null
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

  return service