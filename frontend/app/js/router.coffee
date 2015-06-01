 angular.module("app").config ($stateProvider, $urlRouterProvider, $authProvider) ->

  #TODO: apply some 'universal resolve' approach to avoid boilerplate code here
  # see this link: http://spin.atomicobject.com/2014/10/04/javascript-angularjs-resolve-routes/

  #  --- Static Routes ---- #

  $stateProvider.state( "home",
    url: "/home"
    ncyBreadcrumb:
      label: 'Home page'
      skip: true
    views:
      'content':
        templateUrl: "partials/home.html"
        controller: "HomeCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        if $auth.isAuthenticated()
          $location.path "/dashboard"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("scanner1",
    url: "/scanner1",
    ncyBreadcrumb:
      label: 'PDF scanner'
    views:
      'content':
        templateUrl: "partials/scanner1.html"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

   .state("sendtoken",
    url: "/sendtoken",
    ncyBreadcrumb:
      label: 'PDF scanner'
    views:
      'content':
        templateUrl: "partials/sessions/send_token.html"
        controller: "SessionsNewCtrl"
  )

   .state("passwordconfirm",
    url: "/passwordconfirm?token&email",
    ncyBreadcrumb:
      label: 'Restablecer password'
    views:
      'content':
        templateUrl: "partials/sessions/password_confirm.html"
        controller: "SessionsNewCtrl"
    resolve:
      confirm: ($q, SessionService, $stateParams) ->
        SessionService.canChangePassword($stateParams.email, $stateParams.token)
        # # deferred = $q.defer()
        #  if SessionService.can_updated_password
        #   console.log 'true'
        #   # deferred.resolve()
        #  else
        #   console.log 'false'
        #    # deferred.reject()
        #   $location.path "/login"
        # # deferred.promise
  )

# Scanner

  .state("scanner",
    url: "/scanner",
    ncyBreadcrumb:
      label: 'PDF scanner'
    views:
      'content':
        templateUrl: "partials/scanner.html"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )
  .state("camera",
    url: "/camera",
    ncyBreadcrumb:
      label: 'Camera'
    views:
      'content':
        templateUrl: "partials/camera.html"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state "dashboard",
    url: "/dashboard"
    ncyBreadcrumb:
      label: 'Dashboard'
    views:
      'content':
        templateUrl: "partials/dashboard.html"
        controller: "DashboardCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise


  #  --- Authentication Routes ---- #

  .state("new_session",
    url: "/login"
    ncyBreadcrumb:
      label: 'Login'
      skip: true
    views:
      'content':
        templateUrl: "partials/sessions/new.html"
        controller: "SessionsNewCtrl"
  )

  #  --- External User Routes ---- #

  .state("index_external_user",
    url: "/external_users",
    ncyBreadcrumb:
      label: 'Usuarios Externos'
    views:
      'content':
        templateUrl: "partials/external_users/index.html"
        controller: "ExternalUserIndexCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("show_external_user",
    url: "/external_user/:id",
    ncyBreadcrumb:
      label: 'Detalles usuario externo'
      parent: 'index_external_user'
    views:
      'content':
        templateUrl: "partials/external_users/show.html"
        controller: "ExternalUserShowCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("edit_external_user",
    url: "/external_user/:id/edit",
    ncyBreadcrumb:
      label: 'Edición de usuario externo'
      parent: 'show_external_user'
    views:
      'content':
        templateUrl: "partials/external_users/edit.html"
        controller: "ExternalUserEditCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("edit_external_user_company",
    url: "/external_user/:id/edit_company",
    ncyBreadcrumb:
      label: 'Edición de compañia'
      parent: 'show_external_user'
    views:
      'content':
        templateUrl: "partials/external_users/edit_company.html"
        controller: "ExternalUserCompanyEditCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("search_rucom",
    url: "/rucoms",
    ncyBreadcrumb:
      label: 'Buscar proveedor o cliente en el RUCOM'
    views:
      'content':
        templateUrl: "partials/rucoms/search_rucom.html"
        controller: "SearchRucomCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

    .state("create_external_user_type_a",
      url: "/external_users/type_a",
      ncyBreadcrumb:
        label: 'Nuevo Usuario Externo: Formulario tipo A'
        parent: 'index_external_user'
      views:
        'content':
          templateUrl: "partials/external_users/type_a.html"
          controller: "ExternalUserCreateTypeACtrl"
        'top-nav':
          templateUrl: "partials/top-nav.html"
          controller: "SidebarCtrl"
        'flying-navbar':
          templateUrl: "partials/flying-navbar.html"
          controller: "SidebarCtrl"

      resolve:
        authenticated: ($q, $location, $auth) ->
          deferred = $q.defer()
          unless $auth.isAuthenticated()
            $location.path "/login"
          else
            deferred.resolve()
          deferred.promise
    )

    .state("create_external_user_type_b",
      url: "/external_users/type_b",
      ncyBreadcrumb:
        label: 'Nuevo Usuario Externo: Formulario tipo B'
        parent: 'index_external_user'
      views:
        'content':
          templateUrl: "partials/external_users/type_b.html"
          controller: "ExternalUserCreateTypeBCtrl"
        'top-nav':
          templateUrl: "partials/top-nav.html"
          controller: "SidebarCtrl"
        'flying-navbar':
          templateUrl: "partials/flying-navbar.html"
          controller: "SidebarCtrl"

      resolve:
        authenticated: ($q, $location, $auth) ->
          deferred = $q.defer()
          unless $auth.isAuthenticated()
            $location.path "/login"
          else
            deferred.resolve()
          deferred.promise
    )

#  --- Clients Routes ---- #

    .state("clients",
    url: "/clients",
    ncyBreadcrumb:
      label: 'Clientes'
    views:
      'content':
        templateUrl: "partials/clients/index.html"
        controller: "ClientsIndexCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
    )

    .state("create_client",
      url: "/client/rucom/:rucomId",
      ncyBreadcrumb:
        label: 'Nuevo cliente'
      views:
        'content':
          templateUrl: "partials/clients/new.html"
          controller: "ClientsCreateCtrl"
        'top-nav':
          templateUrl: "partials/top-nav.html"
          controller: "SidebarCtrl"
        'flying-navbar':
          templateUrl: "partials/flying-navbar.html"
          controller: "SidebarCtrl"


      resolve:
        authenticated: ($q, $location, $auth) ->
          deferred = $q.defer()
          unless $auth.isAuthenticated()
            $location.path "/login"
          else
            deferred.resolve()
          deferred.promise
    )

    .state("edit_client",
    url: "/client/:clientId",
    ncyBreadcrumb:
      label: 'Edición de cliente'
    views:
      'content':
        templateUrl: "partials/clients/edit.html"
        controller: "ClientsEditCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"


    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
    )



  #  --- Batches Routes ---- #

  .state( "batches",
    url: "/inventory/all",
    ncyBreadcrumb:
      label: 'Inventory'
    views:
      'content':
        templateUrl: "partials/batches/index.html"
        controller: "BatchesIndexCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )


  .state( "liquidate_batches",
    url: "/inventory/liquidates",
    ncyBreadcrumb:
      label: 'Inventory'
    views:
      'content':
        templateUrl: "partials/batches/liquidate.html"
        controller: "BatchesLiquidateCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )


  #  --- Couriers Routes ---- #

  .state("new_courier",
    url: "/courier",
    ncyBreadcrumb:
      label: 'Registro de Transportador'
    views:
      'content':
        templateUrl: "partials/couriers/new.html"
        controller: "CouriersNewCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  #  --- Purchase Routes ---- #

  .state("new_purchase",
    url: "/purchases/new",
    ncyBreadcrumb:
      label: 'Nueva Compra'
    views:
      'content':
        templateUrl: "partials/purchases/new.html"
        controller: "PurchasesCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("new_purchase.step1",
    url: "/purchases/step1",
    ncyBreadcrumb:
      label: 'Provedor y Certificado de Origen'
    views:
      'content':
        templateUrl: "partials/purchases/step1.html"
        controller: "PurchasesCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("new_purchase.step2",
    url: "/step2",
    ncyBreadcrumb:
      label: 'Pesaje y Compra'
    views:
      'content':
        templateUrl: "partials/purchases/step2.html"
        controller: "PurchasesCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("new_purchase.step3",
    url: "/step3",
    ncyBreadcrumb:
      label: 'Previsualizar Factura'
    views:
      'content':
        templateUrl: "partials/purchases/step3.html"
        controller: "PurchasesCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )
  .state("show_purchase",
    url: "/purchases/show",
    ncyBreadcrumb:
      label: 'Detalles de compra'
    views:
      'content':
        templateUrl: "partials/purchases/show.html"
        controller: "PurchasesShowCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )
  .state("trazoro_purchase",
    url: "/purchases/trazoro_purchase",
    ncyBreadcrumb:
      label: 'Crear una compra Trazoro'
    views:
      'content':
        templateUrl: "partials/purchases/trazoro.html"
        controller: "PurchasesTrazoroCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )
  #  --- Origin Certificate Routes ---- #
  .state("new_origin_certificate",
    url: "/origin_certificates/new",
    ncyBreadcrumb:
      label: 'Seleccion de Certificado de Origen'
    views:
      'content':
        templateUrl: "partials/origin_certificates/new.html"
        controller: "OriginCertificateCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("new_origin_certificate.barequero_chatarrero",
    url: "/origin_certificates/barequero_chatarrero/new",
    ncyBreadcrumb:
      label: 'Certificado de Origen Barequeros y Chatarreros'
    views:
      'content':
        templateUrl: "partials/origin_certificates/barequero_chatarrero/new.html"
        controller: "BarequeroChatarreroOriginCertificateCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("new_origin_certificate.beneficiation_plant",
    url: "/origin_certificates/beneficiation_plant/new",
    ncyBreadcrumb:
      label: 'Certificado de Origen Planta de Beneficio'
    views:
      'content':
        templateUrl: "partials/origin_certificates/beneficiation_plant/new.html"
        controller: "BeneficiationPlantOriginCertificateCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("new_origin_certificate.pawnshops",
    url: "/origin_certificates/pawnshops/new",
    ncyBreadcrumb:
      label: 'Acreditacion de Facturas Casas de Compra y Venta'
    views:
      'content':
        templateUrl: "partials/origin_certificates/pawnshops/new.html"
        controller: "PawnshopsOriginCertificateCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )


  .state("new_origin_certificate.authorized_miner",
    url: "/origin_certificates/authorized_miner/new",
    ncyBreadcrumb:
      label: 'Certificado de Origen de Explotador Minero Autorizado'
    views:
      'content':
        templateUrl: "partials/origin_certificates/authorized_miner/new.html"
        controller: "AuthorizedMinerOriginCertificateCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  # ------- Inventory routes ----------- #

  .state("index_inventory",
    url: "/inventory",
    ncyBreadcrumb:
      label: 'Inventario de compras'
    views:
      'content':
        templateUrl: "partials/inventory/index.html"
        controller: "InventoryIndexCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )
  .state("show_inventory",
    url: "/inventory/detail",
    ncyBreadcrumb:
      label: 'Detalle de compra'
    views:
      'content':
        templateUrl: "partials/inventory/show.html"
        controller: "InventoryShowCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )
  .state("liquidate_inventory",
    url: "/inventory/liquidate",
    ncyBreadcrumb:
      label: 'Lingotear'
    views:
      'content':
        templateUrl: "partials/inventory/liquidate.html"
        controller: "InventoryLiquidateCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )
  .state("show_sale",
    url: "/sale/info",
    ncyBreadcrumb:
      label: 'Reporte - Remision'
    views:
      'content':
        templateUrl: "partials/sales/show.html"
        controller: "SaleShowCtrl"
      'top-nav':
        templateUrl: "partials/top-nav.html"
        controller: "SidebarCtrl"
      'flying-navbar':
        templateUrl: "partials/flying-navbar.html"
        controller: "SidebarCtrl"

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )


  $urlRouterProvider.otherwise "/home"

  # Satellizer config
  $authProvider.loginUrl = '/api/v1/auth/login';
  $authProvider.loginRedirect = '/dashboard';
  $authProvider.tokenName = 'access_token'