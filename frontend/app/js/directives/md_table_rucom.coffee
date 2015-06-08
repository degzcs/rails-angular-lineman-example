angular.module('app').directive 'mdTableRucom', ->
  {
    restrict: 'E'
    scope:
      headers: '='
      content: '='
      sortable: '='
      filters: '='
      customClass: '=customClass'
      count: '='
      currentRucom: '='
      type: '='
    controller: ($scope, $filter, $location, $window, $state, $mdDialog, RucomService, ProviderService, ClientService, ExternalUser) ->
      orderBy = $filter('orderBy')
      $scope.tablePage = 0
      $scope.currentPath = $location.path().substring(1)

      $scope.nbOfPages = ->
        if $scope.content then Math.ceil($scope.content.length / $scope.count) else 0

      $scope.handleSort = (field) ->
        if $scope.sortable.indexOf(field) > -1
          true
        else
          false

      $scope.order = (predicate, reverse) ->
        $scope.content = orderBy($scope.content, predicate, reverse)
        $scope.predicate = predicate
        return

      $scope.order $scope.sortable[0], false

      $scope.getNumber = (num) ->
        new Array(num)

      $scope.goToPage = (page) ->
        $scope.tablePage = page
        return

      $scope.setCurrentRucom = (rucom) ->
        if rucom.status == 'Rechazado'
          title = 'RUCOM'
          text = 'No es posible crear un proveedor con un estado de RUCOM \'Rechazado\''
          $mdDialog.show $mdDialog.alert().title(title).content(text).ok('OK')
        else if rucom.provider_type != RucomService.user_type
          title = 'RUCOM'
          text = "El rucom seleccionado debe ser del tipo "+ RucomService.user_type
          $mdDialog.show $mdDialog.alert().title(title).content(text).ok('OK')
        else
          rucom_name = "Nombre: "+rucom.name
          rucom_num = "Numero: "+rucom.num_rucom
          confirm = $mdDialog.confirm().parent(angular.element(document.body)).title("Esta seguro de seleccionar este rucom. "+rucom_name+", "+rucom_num).ariaLabel('Lucky day').ok('Estoy seguro').cancel('cancelar')
          $mdDialog.show(confirm).then (->
            console.log "ok"

            RucomService.check_if_available(rucom.id).success( (data, headers) ->
              $mdDialog.cancel()
              RucomService.setCurrentRucom(data)
              $scope.comeBack()
            ).error (data, status, headers, config)->
              if status == 400
                $mdDialog.show $mdDialog.alert().title('Hubo un problema').content('Este rucom ya esta asignado a un usuario').ariaLabel('Alert Dialog ').ok('ok')
            return
          ), ->
            $scope.alert = 'You decided to keep your debt.'
            return


          # RucomService.check_if_available(rucom.id).success( (data, headers) ->
          #   $mdDialog.cancel()
          #   RucomService.setCurrentRucom(data)
          #   $scope.comeBack()
          # ).error (data, status, headers, config)->
          #   if status == 400
          #     $mdDialog.show $mdDialog.alert().title('Hubo un problema').content('Este rucom ya esta asignado a un usuario').ariaLabel('Alert Dialog ').ok('ok')
          # return
            # if (providers.length > 0) {
            #   var title = 'RUCOM';
            #   var text = 'Ya existe un proveedor asociado a este registro del RUCOM';
            #   $mdDialog.show($mdDialog.alert().title(title).content(text).ok('OK'));
            # } else {
            #     //console.log('setCurrentRucom' + JSON.stringify(rucom));
            #     RucomService.setCurrentRucom(rucom);        
            #     // console.log(rucom.provider_type);
            #     // var type = $scope.setProviderType(rucom.provider_type);
            #     // console.log('1. Setting current Rucom: ' + rucom.id);
            #    var user_type =  ExternalUser.modelToCreate.external_user.user_type  
            #    console.log(user_type);  
            #    if(user_type == 0){
            #       $state.go('create_external_user_type_a');
            #    }else{
            #       $state.go('create_external_user_type_b');
            #    }   
            # }
            
        return

      $scope.comeBack = ->
        window.history.back()
        return

      $scope.setProviderType = (provider_type) ->
        if provider_type == 'Barequero'
          console.log 'Type A'
          return 'type_1'
        else if provider_type == 'Comercializadores' or provider_type == 'Solicitante Legalización De Minería' or provider_type == 'Titular' or provider_type == 'Beneficiario Área Reserva Especial' or provider_type == 'Subcontrato de formalización' or provider_type == 'Consumidor'
          console.log 'Type B'
          return 'type_2'
        else if provider_type == 'Planta de Beneficio'
          console.log 'Type C'
          return 'type_3'
        return

      return
    templateUrl: 'directives/md-table-rucom.html'
  }
