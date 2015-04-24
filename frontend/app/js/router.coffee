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
    url: "/passwordconfirm",
    ncyBreadcrumb:
      label: 'PDF scanner'
    views:
      'content':
        templateUrl: "partials/sessions/password_confirm.html"
        controller: "SessionsNewCtrl"
  )

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

  .state "dashboard",
    url: "/dashboard"
    ncyBreadcrumb:
      label: 'Dashboard'
    views:
      'content':
        templateUrl: "partials/dashboard.html"
        controller: "DashboardCtrl"
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

  #  --- Providers Routes ---- #

  .state("providers",
    url: "/provider",
    ncyBreadcrumb:
      label: 'Providers'
    views:
      'content':
        templateUrl: "partials/providers/index.html"
        controller: "ProvidersIndexCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("edit_provider",
    url: "/provider/:providerId",
    ncyBreadcrumb:
      label: 'Provider Edition'
    views:
      'content':
        templateUrl: "partials/providers/edit.html"
        controller: "ProvidersEditCtrl"

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
    url: "/rucoms/:type",
    ncyBreadcrumb:
      label: 'Search provider or client by rucom'
    views:
      'content':
        templateUrl: "partials/providers/search_rucom.html"
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

    .state("type_1",
      url: "/provider/type_1/rucom/:rucomId",
      ncyBreadcrumb:
        label: 'New provider'
      views:
        'content':
          templateUrl: "partials/providers/type_a.html"
          controller: "ProvidersRucomCtrl"

      resolve:
        authenticated: ($q, $location, $auth) ->
          deferred = $q.defer()
          unless $auth.isAuthenticated()
            $location.path "/login"
          else
            deferred.resolve()
          deferred.promise
    )

    .state("type_2",
      url: "/provider/type_2/rucom/:rucomId",
      ncyBreadcrumb:
        label: 'New provider'
      views:
        'content':
          templateUrl: "partials/providers/type_b.html"
          controller: "ProvidersRucomCtrl"

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

    .state("create_client",
      url: "/client/rucom/:rucomId",
      ncyBreadcrumb:
        label: 'New Client'
      views:
        'content':
          templateUrl: "partials/clients/new.html"
          controller: "ClientsCreateCtrl"

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
      label: 'New Courier'
    views:
      'content':
        templateUrl: "partials/couriers/new.html"
        controller: "CouriersNewCtrl"
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
    url: "/step1",
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
    url: "/purchases/show.html",
    ncyBreadcrumb:
      label: 'Factura Generada'
    views:
      'content':
        templateUrl: "partials/purchases/show.html"
        controller: "PurchasesShowCtrl"
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
        controller: "OriginCertificateCtrl"
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
        controller: "OriginCertificateCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  .state("new_origin_certificate.houses_buy_and_sell",
    url: "/origin_certificates/houses_buy_and_sell/new",
    ncyBreadcrumb:
      label: 'Acreditacion de Facturas Casas de Compra y Venta'
    views:
      'content':
        templateUrl: "partials/origin_certificates/houses_buy_and_sell/new.html"
        controller: "OriginCertificateCtrl"
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
        controller: "OriginCertificateCtrl"
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