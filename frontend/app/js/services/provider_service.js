angular.module('app').factory('ProviderService', function($resource,$upload,$http) {

    var impl = this;
    var currentProvider = {};
    var providers = [];
    impl.uploadProgress = 0;
    var currentTabProvCreation = 0;


    var setCurrentProv = function(provider) {
        currentProvider = provider;
    };

    var retrieveProviders = $resource('/api/v1/providers.json', {per_page: '@per_page', page: '@page'});

    var retrieveProviderById = $resource('/api/v1/providers/:providerId.json', {providerId:'@providerId'});

    var retrieve = $resource('/api/v1/providers/by_types', {types:'@types', per_page: '@per_page', page: '@page'},{
        byTypes: {method:'GET', isArray: true}
    });

    var getCurrentProv = function() {
        return currentProvider;
    };

    var create = function(provider) {      
      if (provider.identification_number_file && provider.mining_register_file && provider.rut_file && provider.photo_file) {
        if (provider.rucom.provider_type === "Comercializadores" && !provider.chamber_commerce_file) {
          return false;
        }
        i = 0;
        files = [];
        return blobUtil.imgSrcToBlob(provider.photo_file).then(function(provider_photo_file) {
          provider_photo_file.name = 'provider_photo.png';
          provider.identification_number_file[0].name = 'identification_number_file.pdf';
          provider.mining_register_file[0].name = 'mining_register_file.pdf';
          provider.rut_file[0].name = 'rut_file.pdf';
          files = [];
          if (provider.rucom.provider_type === "Comercializadores") {
            provider.chamber_commerce_file[0].name = 'chamber_commerce_file.pdf';
            files = [
              provider.identification_number_file[0],
              provider.mining_register_file[0],
              provider.rut_file[0],
              provider.chamber_commerce_file[0],
              provider_photo_file,
            ];
          } else {
            files = [
              provider.identification_number_file[0],
              provider.mining_register_file[0],
              provider.rut_file[0],
              provider_photo_file,
            ];
          }
          return $upload.upload({
            url: '/api/v1/providers/',
            method: 'POST',
            fields: !provider.company_info ? {
              "provider[first_name]":provider.first_name,
              "provider[document_number]":provider.document_number,
              "provider[last_name]":provider.last_name,
              "provider[phone_number]":provider.phone_number,
              "provider[address]":provider.address,
              "provider[rucom_id]":provider.rucom.id,
              "provider[email]":provider.email,
              "provider[population_center_id]":provider.population_center.id
            }
            :
            {
              "provider[first_name]":provider.first_name,
              "provider[document_number]":provider.document_number,
              "provider[last_name]":provider.last_name,
              "provider[phone_number]":provider.phone_number,
              "provider[address]":provider.address,
              "provider[rucom_id]":provider.rucom.id,
              "provider[email]":provider.email,
              "provider[population_center_id]":provider.population_center.id,
              "company_info[name]":provider.company_info.name,
              "company_info[nit_number]":provider.company_info.nit_number,
              "company_info[legal_representative]":provider.company_info.legal_representative,
              "company_info[id_type_legal_rep]":provider.company_info.id_type_legal_rep,
              "company_info[id_number_legal_rep]":provider.company_info.id_number_legal_rep,
              "company_info[phone_number]":provider.company_info.phone_number,
              "company_info[email]":provider.company_info.email
            },
            file: files,
            fileFormDataName: 'provider[files][]'
          }).progress(function(evt) {
            console.log('progress: ' + impl.uploadProgress + '% ' + evt.config.file);
            impl.uploadProgress = parseInt(100.0 * evt.loaded / evt.total);
          }).success(function(data, status, headers, config) {
            //uploadProgress = 0;
            // var model;
            // console.log('uploaded file ');
            // window.data = data;
            // model = angular.fromJson(sessionStorage.providerService);
            // model.reference_code = data.reference_code;
            // sessionStorage.providerService = angular.toJson(model);
            // return service.model = model;
          });
        })["catch"](function(err) {});
      } else {
        return false;
      }

      // var file,  _results;
      // if (provider.photo_file) {
      //   _results = [];
      //     file = provider.photo_file;
      //     $upload.upload({
      //       url: '/api/v1/providers/',
      //       method: 'POST',
      //       fields: !provider.company_info ? {
      //             "provider[first_name]":provider.first_name,
      //             "provider[document_number]":provider.document_number,
      //             "provider[last_name]":provider.last_name,
      //             "provider[phone_number]":provider.phone_number,
      //             "provider[address]":provider.address,
      //             "provider[rucom_id]":provider.rucom.id,
      //             "provider[email]":provider.email,
      //             "provider[population_center_id]":provider.population_center.id
      //       }
      //       :
      //       {
      //             "provider[first_name]":provider.first_name,
      //             "provider[document_number]":provider.document_number,
      //             "provider[last_name]":provider.last_name,
      //             "provider[phone_number]":provider.phone_number,
      //             "provider[address]":provider.address,
      //             "provider[rucom_id]":provider.rucom.id,
      //             "provider[email]":provider.email,
      //             "provider[population_center_id]":provider.population_center.id,
      //             "company_info[name]":provider.company_info.name,
      //             "company_info[nit_number]":provider.company_info.nit_number,
      //             "company_info[legal_representative]":provider.company_info.legal_representative,
      //             "company_info[id_type_legal_rep]":provider.company_info.id_type_legal_rep,
      //             "company_info[id_number_legal_rep]":provider.company_info.id_number_legal_rep,
      //             "company_info[phone_number]":provider.company_info.phone_number,
      //             "company_info[email]":provider.company_info.email
      //       },
      //       file: file,
      //       fileFormDataName: 'provider[photo_file]'
      //     })
      //     .progress(progress).success(success);
      //   }else{
      //    return $resource('/api/v1/providers/',
      //     {},{
      //         save: {
      //             method: 'POST',
      //             params:{
      //             "provider[first_name]":provider.first_name,
      //             "provider[document_number]":provider.document_number,
      //             "provider[last_name]":provider.last_name,
      //             "provider[phone_number]":provider.phone_number,
      //             "provider[address]":provider.address,
      //             "provider[rucom_id]":provider.rucom.id,
      //             "provider[email]":provider.email,
      //             "provider[population_center_id]":provider.population_center.id
      //             }
      //         }
      //       });
      //   }
  };
  //Can call edit like so:
  //$resource = ProviderService.edit($scope.currentProvider);
  //  if($resource){
   //   $resource .update({ id:$scope.currentProvider.id }, $scope.currentProvider);
   // }
      var edit = function(provider) {
      var file, i, _results;
      if(provider.files && provider.files.length){
        i = 0;
        while(i < provider.files.length){
          file = provider.files[i];
          $upload.upload({
            url: '/api/v1/providers/',
            method: 'PUT',
            fields: !provider.company_info ? {
              "provider[phone_number]":provider.phone_number,
              "provider[address]":provider.address,
              "provider[email]":provider.email,
              "provider[population_center_id]":provider.population_center.id
            }
            :
            {
              "provider[phone_number]":provider.phone_number,
              "provider[address]":provider.address,
              "provider[email]":provider.email,
              "provider[population_center_id]":provider.population_center.id,
              "company_info[email]":provider.company_info.email,
              "company_info[phone_number]":provider.company_info.phone_number
            },
            file: file,
            fileFormDataName: 'provider[files]'
          })
          .progress(progress).success(success);
          i++;
        }
      }else{

        return $resource('/api/v1/providers/:id',
        {id:'@id'},{
            'update': {
                method: 'PUT',
                params: !provider.company_info ? {
                  "provider[phone_number]":provider.phone_number,
                  "provider[address]":provider.address,
                  "provider[email]":provider.email,
                  "provider[population_center_id]":provider.population_center.id
                }
                :
                {
                  "provider[phone_number]":provider.phone_number,
                  "provider[address]":provider.address,
                  "provider[email]":provider.email,
                  "provider[population_center_id]":provider.population_center.id,
                  "company_info[email]":provider.company_info.email,
                  "company_info[phone_number]":provider.company_info.phone_number
                }
              }
          });
      }
    };
    var progress= function(evt) {
            var progressPercentage;
            progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
            return console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
        };

    var success= function(data, status, headers, config) {
            return console.log('file ' + config.file.name + 'uploaded. Response: ' + data);
        };

    var setCallerState = function(state){
      sessionStorage.callerState = state;
    }

    var getCallerState = function(){
      if(sessionStorage.callerState ){
        state = sessionStorage.callerState
      }
      return state;
    }

    return {
        getCurrentProv: getCurrentProv,
        setCurrentProv: setCurrentProv,
        retrieveProviders: retrieveProviders,
        create : create,
        edit : edit,
        retrieveProviderById: retrieveProviderById,
        uploadProgress: impl.uploadProgress,
        impl: impl,
        retrieve: retrieve,
        currentTabProvCreation: currentTabProvCreation,
        setCallerState: setCallerState,
        getCallerState: getCallerState
    };
});