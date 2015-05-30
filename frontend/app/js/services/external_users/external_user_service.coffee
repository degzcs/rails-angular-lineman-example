angular.module('app').factory 'ExternalUser', ($resource, $upload, $http, $mdDialog,RucomService,$state) ->
  service =

    
    uploadProgress: 0

    modelToCreate:
      rucom_id: ''
      external_user:
        first_name: ''
        last_name: ''
        email: ''
        document_number: ''
        document_expedition_date: ''
        phone_number: ''
        address: ''
        population_center_id: ''
        user_type: ''
      company:
        nit_number: ''
        name: ''
        city: ''
        state: ''
        country: ''
        legal_representative: ''
        id_type_legal_rep: ''
        id_number_legal_rep: ''
        email: ''
        phone_number: ''
      files: 
        document_number_file: ''
        mining_register_file: ''
        chamber_commerce_file: ''
        photo_file: ''
        rut_file: ''

    modelToUpdate:
      company:
        phone_number: ''
        email: ''
      external_user:
        phone_number: ''
        email: ''
        address: ''
        population_center_id: ''



    all: (per_page,page)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10,
                  page: page || 1
                }
    get: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/external_users/'+id
                method: 'GET'

    create: ()->
      # Photo file
      external_user = service.modelToCreate.external_user
      company = service.modelToCreate.company
      files = service.modelToCreate.files
      rucom_id = service.modelToCreate.rucom_id
      console.log rucom_id

      blobUtil.imgSrcToBlob(files.photo_file).then (external_user_photo_file) ->
        #external_user_photo_file = photo_file
        external_user_photo_file.name = 'photo_file.png'
        
        # Other Files
        filesRemaining = 0;

        # Document Number File
        if !(files.document_number_file[0] instanceof File)
          files.document_number_file[0].name = 'document_number_file.pdf'
          console.log("ALGO PASO")
            
        else
          document_number_file_copy = files.document_number_file
          document_number_reader = new FileReader
          files.document_number_file = []
          console.log("ALGO NOPASO")
            
          document_number_reader.onload = ->
            `var i`
            i = undefined
            l = undefined
            d = undefined
            array = undefined
            d = @result
            l = d.length
            array = new Uint8Array(l)
            i = 0
            while i < l
              array[i] = d.charCodeAt(i)
              i++
            files.document_number_file.push new Blob([ array ], type: 'application/octet-stream')
            files.document_number_file[0].name = 'document_number_file' + document_number_file_copy[0].name.substring(document_number_file_copy[0].name.lastIndexOf('.'))
            --filesRemaining
            if filesRemaining <= 0
              uploadFiles()
            # window.location.href = URL.createObjectURL(b);
            return
          document_number_reader.readAsBinaryString document_number_file_copy[0]
          filesRemaining++

        # Mining register file
        if !(files.mining_register_file[0] instanceof File)
          files.mining_register_file[0].name = 'mining_register_file.pdf'
        else
          mining_register_file_copy = files.mining_register_file
          mining_register_reader = new FileReader
          files.mining_register_file = []

          mining_register_reader.onload = ->
            `var i`
            i = undefined
            l = undefined
            d = undefined
            array = undefined
            d = @result
            l = d.length
            array = new Uint8Array(l)
            i = 0
            while i < l
              array[i] = d.charCodeAt(i)
              i++
            files.mining_register_file.push new Blob([ array ], type: 'application/octet-stream')
            files.mining_register_file[0].name = 'mining_register_file' + mining_register_file_copy[0].name.substring(mining_register_file_copy[0].name.lastIndexOf('.'))
            --filesRemaining
            if filesRemaining <= 0
              uploadFiles()
            # window.location.href = URL.createObjectURL(b);
            return

          mining_register_reader.readAsBinaryString mining_register_file_copy[0]
          filesRemaining++

        #Rut file
        if !(files.rut_file[0] instanceof File)
          files.rut_file[0].name = 'rut_file.pdf'
        else
          rut_file_copy = files.rut_file
          rut_reader = new FileReader
          files.rut_file = []

          rut_reader.onload = ->
            `var i`
            i = undefined
            l = undefined
            d = undefined
            array = undefined
            d = @result
            l = d.length
            array = new Uint8Array(l)
            i = 0
            while i < l
              array[i] = d.charCodeAt(i)
              i++
            files.rut_file.push new Blob([ array ], type: 'application/octet-stream')
            files.rut_file[0].name = 'rut_file' + rut_file_copy[0].name.substring(rut_file_copy[0].name.lastIndexOf('.'))
            --filesRemaining
            if filesRemaining <= 0
              uploadFiles()
            # window.location.href = URL.createObjectURL(b);
            return

          rut_reader.readAsBinaryString rut_file_copy[0]
          filesRemaining++

        files_to_upload = []
        
        uploadFiles = ->

          if external_user.user_type != 0
            files_to_upload = [
              files.iddocument_number_file[0]
              files.mining_register_file[0]
              files.rut_file[0]
              files.chamber_commerce_file[0]
              external_user_photo_file
            ]
          else
            files_to_upload = [
              files.document_number_file[0]
              files.mining_register_file[0]
              files.rut_file[0]
              external_user_photo_file
            ]
          $upload.upload(
            url: '/api/v1/external_users/'
            method: 'POST'
            headers: { 'Content-Transfer-Encoding': 'utf-8' }
            fields: 
              "external_user[first_name]":external_user.first_name,
              "external_user[document_number]":external_user.document_number,
              "external_user[last_name]":external_user.last_name,
              "external_user[phone_number]":external_user.phone_number,
              "external_user[address]":external_user.address,
              "external_user[email]":external_user.email,
              "external_user[population_center_id]":external_user.population_center_id,
              "rucom_id": rucom_id
            file: files_to_upload
            fileFormDataName: 'external_user[files_to_upload][]').progress((evt) ->
            console.log 'progress: ' + service.uploadProgress + '% ' + evt.config.file
            service.uploadProgress = parseInt(100.0 * evt.loaded / evt.total)
            return
          ).success (data, status, headers, config) ->
              $mdDialog.show $mdDialog.alert().title('Felicitaciones').content('El usuario a sido creado').ariaLabel('Alert Dialog Demo').ok('ok')
              $state.go "index_external_user"
              service.clearModelToCreate()
            #uploadProgress = 0;
            # var model;
            # console.log('uploaded file ');
            # window.data = data;
            # model = angular.fromJson(sessionStorage.external_userService);
            # model.reference_code = data.reference_code;
            # sessionStorage.external_userService = angular.toJson(model);
            # return service.model = model;
            return

        #Files Upload
        if filesRemaining <= 0
          uploadFiles()
          console.log "SUBIENDO"


    
    update_external_user: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/external_users/'+id
                method: 'PUT'
                data: {
                  external_user: service.modelToUpdate.external_user
                }
    
    update_external_user_company: (id)->
      $mdDialog.show(templateUrl: 'partials/loading.html',disableParentScroll: false)
      return $http
                url: 'api/v1/external_users/'+id
                method: 'PUT'
                data: {
                  company: service.modelToUpdate.company
                }
    
    query_by_name: (name,per_page,page)->
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_name: name
                }
    query_by_id: (id,per_page,page)->
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_id: id
                }
    query_by_rucom_id: (rucomid,per_page,page)->
      return $http
                url: 'api/v1/external_users'
                method: 'GET'
                params: {
                  per_page: per_page || 10
                  page: page || 1
                  query_rucomid: rucomid
                }
    saveModelToCreate: ->
      sessionStorage.external_user_to_create = angular.toJson(service.modelToCreate)
    restoreModelToCreate: ->
      if(sessionStorage.external_user_to_create)
        service.modelToCreate = angular.fromJson(sessionStorage.external_user_to_create)
      return service.modelToCreate
    clearModelToCreate: ->
      RucomService.currentRucom = null
      sessionStorage.external_user_to_create = null
      service.modelToCreate =
        rucom_id: ''
        external_user:
          first_name: ''
          last_name: ''
          email: ''
          document_number: ''
          document_expedition_date: ''
          phone_number: ''
          address: ''
          population_center_id: ''
          user_type: ''
        files:
          document_number_file: ''
          mining_register_file: ''
          rut_file: ''
          chamber_commerce_file: ''
          photo_file: ''
        company:
          nit_number: ''
          name: ''
          city: ''
          state: ''
          country: ''
          legal_representative: ''
          id_type_legal_rep: ''
          id_number_legal_rep: ''
          email: ''
          phone_number: ''


      console.log "Model clened"
  return service