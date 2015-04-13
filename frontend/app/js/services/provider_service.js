angular.module('app').factory('ProviderService', function($resource,$upload) {

    var currentProvider = {};
    var providers = [];

    var setCurrentProv = function(provider) {
        currentProvider = provider;
    };

    var retrieveProviders = $resource('/api/v1/providers.json', {per_page: '@per_page', page: '@page'});

    var retrieveProviderById = $resource('/api/v1/providers/:providerId.json', {providerId:'@providerId'});

    var getCurrentProv = function() {
        return currentProvider;
    };

    var create = function(provider) {
      var file,  _results;
      if (provider.photo_file) {
        _results = [];
          file = provider.photo_file;
          $upload.upload({
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
            file: file,
            fileFormDataName: 'provider[photo_file]'
          })
          .progress(progress).success(success);
        }else{
         return $resource('/api/v1/providers/',
          {},{
              save: {
                  method: 'POST',
                  params:{
                  "provider[first_name]":provider.first_name,
                  "provider[document_number]":provider.document_number,
                  "provider[last_name]":provider.last_name,
                  "provider[phone_number]":provider.phone_number,
                  "provider[address]":provider.address,
                  "provider[rucom_id]":provider.rucom.id,
                  "provider[email]":provider.email,
                  "provider[population_center_id]":provider.population_center.id
                  }
              }
            });
        }
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

    return {
        getCurrentProv: getCurrentProv,
        setCurrentProv: setCurrentProv,
        retrieveProviders: retrieveProviders,
        create : create,
        edit : edit,
        retrieveProviderById: retrieveProviderById
    };
});