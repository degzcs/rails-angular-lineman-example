angular.module('app').factory 'AuthorizedProvider', ($resource, $upload, $http, $mdDialog, RucomService, $state) ->
  service =

    uploadProgress: 0
    isCompany: false
    modelToCreate:
      user_type: ''
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
        external_user_mining_register_file: ''
        mining_register_file: ''
        chamber_of_commerce_file: ''
        rut_file: ''
     all: (per_page,page)->
      #$mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/external_users'
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
      external_user = service.modelToCreate.authorized_provider
      profile = service.modelToCreate.profile
      files_to_upload = service.modelToCreate.files
      rucom = service.modelToCreate.rucom

      blobUtil.imgSrcToBlob(files_to_upload.photo_file).then (external_user_photo_file) ->
        external_user_photo_file.name = 'photo_file.png'
        # Other Files
        filesRemaining = 0;

# -----------------------------------------------------------
        # Document Number File
        if files_to_upload.document_number_file
          if !(files_to_upload.document_number_file[0] instanceof File)
            files_to_upload.document_number_file[0].name = 'document_number_file.pdf'
          else
            document_number_file_copy = files_to_upload.document_number_file
            document_number_reader = new FileReader
            fileName = 'document_number_file'

            document_number_reader.onload = ->
              array = createBinaryFile(@result)
              files_to_upload.document_number_file = createBlobFile(array, fileName, document_number_file_copy)
              --filesRemaining
              if filesRemaining <= 0
                uploadFiles()
              return

            document_number_reader.readAsBinaryString document_number_file_copy[0]
            filesRemaining++

#--------------------------------------------------------------------
        # External Users mining register file
        console.log 'Mining Register File'
        if files_to_upload.external_user_mining_register_file
          if !(files_to_upload.external_user_mining_register_file[0] instanceof File)
            files_to_upload.external_user_mining_register_file[0].name = 'mining_register_file.pdf'
          else
            mining_register_file_copy = files_to_upload.external_user_mining_register_file
            miningRegisterReader = new FileReader
            fileName = 'mining_register_file'

            miningRegisterReader.onload = ->
              array = createBinaryFile(@result)
              files_to_upload.external_user_mining_register_file = createBlobFile(array, fileName, mining_register_file_copy)
              --filesRemaining
              if filesRemaining <= 0
                uploadFiles()
              return

            miningRegisterReader.readAsBinaryString mining_register_file_copy[0]
            filesRemaining++

  #------------------------------------------------------------
        #
        # Funtion to convert the files in a array valid with the Binary format to then convert it as Blob to send it by PUT Request
        #
        createBinaryFile = (result) ->
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
          console.log 'Array = '
          console.log array
          return array

#------------------------------------------------------------
        #
        # Funtion to convert the files as Blob to send it by PUT Request
        #
        createBlobFile = (array, fileName, fileCopy) ->
          file = []
          ext = fileCopy[0].name.substring(fileCopy[0].name.lastIndexOf('.'))
          file.push new Blob([ array ], type: 'application/octet-stream')
          file[0].name = fileName + ext
          return file

#------------------------------------------------------------
        files = []

        uploadFiles = ->

          if external_user_photo_file
            files.push external_user_photo_file
          if files_to_upload.document_number_file[0]
            files.push files_to_upload.document_number_file[0]
          if files_to_upload.external_user_mining_register_file[0]
            files.push files_to_upload.external_user_mining_register_file[0]

          console.log 'Se impreme el array de archivos a cargar: '
          console.log files

          $upload.upload(
            url: '/api/v1/autorized_providers/' + id
            method: 'PUT'
            headers: {'Content-Type': 'application/json'}
            fields:
              "authorized_provider[email]":external_user.email,
              "profile[first_name]":profile.first_name,
              "profile[last_name]":profile.last_name,
              "profile[phone_number]":profile.phone_number,
              "profile[address]":profile.address,
              "profile[city_id]":profile.city_id,
              "rucom[rucom_number]":rucom.rucom_number
            file: files
            fileFormDataName: 'profile[files][]').progress((evt) ->
            console.log 'progress: ' + service.uploadProgress + '% ' + evt.config.file
            service.uploadProgress = parseInt(100.0 * evt.loaded / evt.total)
            return
          ).success( (data, status, headers, config)->
            $mdDialog.show $mdDialog.alert().title('Felicitaciones').content('El usuario a sido creado').ariaLabel('Alert Dialog Demo').ok('ok')
            $state.go "index_external_user"
            service.clearModelToCreate()
            return
          ).error (data, status, headers, config)->
            $mdDialog.show $mdDialog.alert().title('Alerta - Hubo inconvenientes').content('El Productor no pudo ser Actualizado!').ariaLabel('Alert Dialog Demo').ok('ok')
            $state.go "index_external_user"
            service.clearModelToCreate()
            return

        #Files Upload
        if filesRemaining <= 0
          uploadFiles()
          console.log "SUBIENDO"

#-----------------------------------------------------------------
    saveModelToCreate: ->
      sessionStorage.external_user_to_create = angular.toJson(service.modelToCreate)

    restoreModelToCreate: ->
      files = service.modelToCreate.files
      if sessionStorage.external_user_to_create != null
        service.modelToCreate = angular.fromJson(sessionStorage.external_user_to_create)
        service.modelToCreate.files = files
        service.modelToCreate
      else
        service.modelToCreate


    clearModelToCreate: ->
      RucomService.user_type = ''
      RucomService.currentRucom = null
      sessionStorage.external_user_to_create = null
      service.isCompany= false
      service.modelToCreate =
        user_type: ''
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
          external_user_mining_register_file: ''
          mining_register_file: ''
          chamber_of_commerce_file: ''
          rut_file: ''


      console.log "Model clened"
  return service