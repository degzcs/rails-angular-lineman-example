 angular.module("app").config ($stateProvider, $urlRouterProvider, $authProvider) ->

  # TODO: apply some 'universal resolve' approach to avoid boilerplate code here
  # see this link: http://spin.atomicobject.com/2014/10/04/javascript-angularjs-resolve-routes/
  # TODO: split this file in several ones.

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
      label: 'Inicio'
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

  #  --- Authorized Provider Routes ---- #

  .state("index_authorized_provider",
    url: "/authorized_providers",
    ncyBreadcrumb:
      label: 'Proveedores'
    views:
      'content':
        templateUrl: "partials/authorized_providers/index.html"
        controller: "AuthorizedProviderIndexCtrl"
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

  .state("show_authorized_provider",
    url: "/authorized_provider/:id",
    ncyBreadcrumb:
      label: 'Detalles proveedor'
      parent: 'index_authorized_provider'
    views:
      'content':
        templateUrl: "partials/authorized_providers/show.html"
        controller: "AuthorizedProviderShowCtrl"
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

  .state("term_and_cond_authorized_provider",
    url: "/authorized_providers/:id/term_and_cond",
    ncyBreadcrumb:
      label: 'Aceptación de Manejo de información'
      parent: 'index_authorized_provider' #'show_authorized_provider'
    views:
      'content':
        templateUrl: "partials/authorized_providers/terms_and_cond.html"
        controller: "AuthorizedProviderTermCondCtrl"
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

  .state("new_authorized_provider",
    url: "/authorized_providers/:id/new",
    ncyBreadcrumb:
      label: 'Edición de proveedor'
      parent: 'index_authorized_provider' #'show_authorized_provider'
    views:
      'content':
        templateUrl: "partials/authorized_providers/new.html"
        controller: "AuthorizedProviderNewCtrl"
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

  .state("search_authorized_provider",
    url: "/authorized_providers/:id/rucom_search",
    ncyBreadcrumb:
      label: 'Edición de proveedor'
      parent: 'search_authorized_provider' #'show_authorized_provider'
    views:
      'content':
        templateUrl: "partials/authorized_providers/rucom_search.html"
        controller: "AuthorizedProviderSearchCtrl"
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
  .state("edit_authorized_provider",
    url: "/authorized_provider/:id/edit",
    ncyBreadcrumb:
      label: 'Edición de proveedor'
      parent: 'show_authorized_provider'
    views:
      'content':
        templateUrl: "partials/authorized_providers/edit.html"
        controller: "AuthorizedProviderEditCtrl"
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

  .state("edit_authorized_provider_company",
    url: "/authorized_provider/:id/edit_company",
    ncyBreadcrumb:
      label: 'Edición de compañia'
      parent: 'show_authorized_provider'
    views:
      'content':
        templateUrl: "partials/authorized_providers/edit_company.html"
        controller: "AuthorizedProviderCompanyEditCtrl"
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
  .state("new_purchase.tab.orders_pending",
    url: "/orders_pending",
    ncyBreadcrumb:
      label: 'Ordenes de Compra Pendientes'
    views:
      'content':
        templateUrl: "partials/purchases/orders_pending.html"
        controller: "PurchaseOrdersPendingCtrl"
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

  .state("new_purchase.orders_details_agreetment",
    url: "/purchases/orders_details/agreetment",
    ncyBreadcrumb:
      label: 'Detalles de Ordenes de Compra Pendientes'
    views:
      'content':
        templateUrl: "partials/purchases/orders_details_purchase.html"
        controller: "PurchaseOrdersPendingCtrl"
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

  .state("new_purchase.orders_pending_agreetment",
    url: "/purchases/orders_pending/agreetment",
    ncyBreadcrumb:
      label: 'Ordenes de Compra Pendientes'
    views:
      'content':
        templateUrl: "partials/purchases/orders_pending_agreetment.html"
        controller: "PurchaseOrdersPendingCtrl"
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

  .state("new_purchase.orders_resume",
    url: "/purchases/orders_resume",
    ncyBreadcrumb:
      label: 'Resumen de la Orden de Compra'
    views:
      'content':
        templateUrl: "partials/purchases/orders_resume.html"
        controller: "PurchaseOrdersPendingCtrl"
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

  .state("new_purchase.tab.orders_canceled",
    url: "/orders_canceled",
    ncyBreadcrumb:
      label: 'Ordenes de Compra Rechazadas'
    views:
      'content':
        templateUrl: "partials/purchases/orders_canceled.html"
        controller: "PurchaseOrdersCanceledCtrl"
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

  .state("new_purchase",
    url: "/purchases",
    ncyBreadcrumb:
      label: 'Compra'
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

  .state("new_purchase.purchase_home",
    url: "/purchases/home",
    ncyBreadcrumb:
      label: 'Nueva compra'
    views:
      'content':
        templateUrl: "partials/purchases/purchase_home.html"
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

  .state("new_purchase.tab",
    url: "/purchases/tab",
    ncyBreadcrumb:
      label: 'Ordenes'
    views:
      'content':
        templateUrl: "partials/purchases/purchase_tabs.html"
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

  .state("new_purchase.step0",
    url: "/purchases/step0",
    ncyBreadcrumb:
      label: 'Consulta Productor'
    views:
      'content':
        templateUrl: "partials/purchases/step0.html"
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
      label: 'Certificado de Origen'
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

  .state("new_purchase.step4",
    url: "/step4",
    ncyBreadcrumb:
      label: 'Previsualizar Factura'
    views:
      'content':
        templateUrl: "partials/purchases/step4.html"
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
  # NOTE: This feature was disabled because it is not need anymore. But
  # if it is needed we have to fix it before to enable again.
  #
  # #  --- Origin Certificate Routes ---- #
  # .state("new_origin_certificate",
  #   url: "/origin_certificates/new",
  #   ncyBreadcrumb:
  #     label: 'Seleccion de Certificado de Origen'
  #   views:
  #     'content':
  #       templateUrl: "partials/origin_certificates/new.html"
  #       controller: "OriginCertificateCtrl"
  #     'top-nav':
  #       templateUrl: "partials/top-nav.html"
  #       controller: "SidebarCtrl"
  #     'flying-navbar':
  #       templateUrl: "partials/flying-navbar.html"
  #       controller: "SidebarCtrl"

  #   resolve:
  #     authenticated: ($q, $location, $auth) ->
  #       deferred = $q.defer()
  #       unless $auth.isAuthenticated()
  #         $location.path "/login"
  #       else
  #         deferred.resolve()
  #       deferred.promise
  # )

  # .state("new_origin_certificate.barequero_chatarrero",
  #   url: "/origin_certificates/barequero_chatarrero/new",
  #   ncyBreadcrumb:
  #     label: 'Certificado de Origen Barequeros y Chatarreros'
  #   views:
  #     'content':
  #       templateUrl: "partials/origin_certificates/barequero_chatarrero/new.html"
  #       controller: "BarequeroChatarreroOriginCertificateCtrl"
  #   resolve:
  #     authenticated: ($q, $location, $auth) ->
  #       deferred = $q.defer()
  #       unless $auth.isAuthenticated()
  #         $location.path "/login"
  #       else
  #         deferred.resolve()
  #       deferred.promise
  # )

  # .state("new_origin_certificate.beneficiation_plant",
  #   url: "/origin_certificates/beneficiation_plant/new",
  #   ncyBreadcrumb:
  #     label: 'Certificado de Origen Planta de Beneficio' ######## REFERENCIA ######
  #   views:
  #     'content':
  #       templateUrl: "partials/origin_certificates/beneficiation_plant/new.html"
  #       controller: "BeneficiationPlantOriginCertificateCtrl"
  #   resolve:
  #     authenticated: ($q, $location, $auth) ->
  #       deferred = $q.defer()
  #       unless $auth.isAuthenticated()
  #         $location.path "/login"
  #       else
  #         deferred.resolve()
  #       deferred.promise
  # )

  # .state("new_origin_certificate.pawnshops",
  #   url: "/origin_certificates/pawnshops/new",
  #   ncyBreadcrumb:
  #     label: 'Acreditacion de Facturas Casas de Compra y Venta'
  #   views:
  #     'content':
  #       templateUrl: "partials/origin_certificates/pawnshops/new.html"
  #       controller: "PawnshopsOriginCertificateCtrl"
  #   resolve:
  #     authenticated: ($q, $location, $auth) ->
  #       deferred = $q.defer()
  #       unless $auth.isAuthenticated()
  #         $location.path "/login"
  #       else
  #         deferred.resolve()
  #       deferred.promise
  # )


  # .state("new_origin_certificate.authorized_miner",
  #   url: "/origin_certificates/authorized_miner/new",
  #   ncyBreadcrumb:
  #     label: 'Certificado de Origen de Explotador Minero Autorizado'
  #   views:
  #     'content':
  #       templateUrl: "partials/origin_certificates/authorized_miner/new.html"
  #       controller: "AuthorizedMinerOriginCertificateCtrl"
  #   resolve:
  #     authenticated: ($q, $location, $auth) ->
  #       deferred = $q.defer()
  #       unless $auth.isAuthenticated()
  #         $location.path "/login"
  #       else
  #         deferred.resolve()
  #       deferred.promise
  # )

  # ------- Inventory routes ----------- #

  .state("inventory",
    url: "/inventory", # <-- inventory
    ncyBreadcrumb:
      label: 'Inventario'
    views:
      'content':
        templateUrl: "partials/inventory/tabs.html" # partial list_inventory (tabs control)
        controller: "InventoryTabsCtrl" # tab inventory controller
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


  .state("inventory.purchases",
    url: "/purchases",
    ncyBreadcrumb:
      label: 'Inventario de compras'
    views:
      'content':
        templateUrl: "partials/inventory/purchases_tab.html" # TODO: Refactor to leave the old version
        controller: "PurchasesTabCtrl"
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
  .state("inventory.purchase_details",
    url: "/purchase/details",
    ncyBreadcrumb:
      label: 'Detalle de compra'
    views:
      'content':
        templateUrl: "partials/inventory/purchase_details.html"
        controller: "PurchaseDetailsCtrl"
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
  .state("inventory.sales",
    url: "/sales",
    ncyBreadcrumb:
      label: 'Inventario de ventas'
    views:
      'content':
        templateUrl: "partials/inventory/sales_tab.html"
        controller: "SalesTabCtrl"
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
  .state("inventory.sale_details",
    url: "/sale/details",
    ncyBreadcrumb:
      label: 'Detalle de venta'
    views:
      'content':
        templateUrl:'partials/inventory/sale_details.html'
        controller:'SaleDetailsCtrl'
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

  .state('inventory.royalties',
    url: '/inventory/royalties',
    ncyBreadcrumb:
      label: 'Regalias'
    views:
      'content':
        templateUrl: 'partials/inventory/royalties.html'
        controller: 'RoyaltiesTabCtrl'
      'top-nav':
        templateUrl: 'partials/top-nav.html'
        controller: 'SidebarCtrl'
      'flying-navbar':
        templateUrl: 'partials/flying-navbar.html'
        controller: 'SidebarCtrl'

    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  )

  # ------- Sales routes ----------- #

  # this route is called from inventory sale and It should be reubicated inside sales folder
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
# new sales routes

  .state("new_sale",
    url: "/sales/new",
    ncyBreadcrumb:
      label: 'Nueva Venta'
    views:
      'content':
        templateUrl: "partials/sales/new.html"
        controller: "SalesCtrl"
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

  .state("new_sale.sale_home",
    url: "/sales/home",
    ncyBreadcrumb:
      label: 'Venta'
    views:
      'content':
        templateUrl: "partials/sales/sale_home.html"
        controller: "SalesCtrl"
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

  .state("new_sale.tab",
    url: "/sales/tab",
    ncyBreadcrumb:
      label: 'Ordenes'
    views:
      'content':
        templateUrl: "partials/sales/sale_tabs.html"
        controller: "SalesCtrl"
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

  .state("new_sale.tab.orders_pending_sale",
    url: "/orders_pending_sale",
    ncyBreadcrumb:
      label: 'Ordenes de venta pendientes'
    views:
      'content':
        templateUrl: "partials/sales/orders_pending_sale.html"
        controller: "SaleOrdersPendingCtrl"
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

  .state("new_sale.resume_sale_pending",
    url: "/resume_sale_pending",
    ncyBreadcrumb:
      label: 'Resumen de la orden de venta pendiente'
    views:
      'content':
        templateUrl: "partials/sales/orders_pending_resume_sale.html"
        controller: "SaleOrdersPendingCtrl"
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

  .state("new_sale.tab.orders_marketplace",
    url: "/orders_marketplace",
    ncyBreadcrumb:
      label: 'Ordenes de Venta Marketplace'
    views:
      'content':
        templateUrl: "partials/sales/orders_marketplace.html"
        controller: "SaleOrdersMarketplaceCtrl"
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

  .state("new_sale.order_marketplace",
    url: "/order_marketplace",
    params: {
          id: null
      },
    ncyBreadcrumb:
      label: 'Ordene de Venta Marketplace'
    views:
      'content':
        templateUrl: "partials/sales/order_marketplace.html"
        controller: "SaleOrderMarketplaceCtrl"
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

  .state("new_sale.tab.orders_canceled_sale",
    url: "/orders_canceled_sale",
    ncyBreadcrumb:
      label: 'Ordenes de venta canceladas'
    views:
      'content':
        templateUrl: "partials/sales/orders_canceled_sale.html"
        controller: "SaleOrdersCanceledCtrl"
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

# Fixed Sale Agreetment
  .state("new_sale.step1",
    url: "/sales/step1",
    ncyBreadcrumb:
      label: 'Selección de Bloques de Oro'
    views:
      'content':
        templateUrl: "partials/sales/step1.html"
        controller: "SalesCtrl"
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

# GoldBatch Select
  .state("new_sale.step2",
    url: "/sales/step2",
    ncyBreadcrumb:
      label: 'Selección de lotes'
    views:
      'content':
        templateUrl: "partials/sales/step2.html"
        controller: "SalesCtrl"
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

# Sale Detail
  .state("new_sale.step3",
    url: "/sales/step3",
    ncyBreadcrumb:
      label: 'Fijación de Precio'
    views:
      'content':
        templateUrl: "partials/sales/step3.html"
        controller: "SaleOrderLiquidateCtrl"
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

# Sale Order Detail
  .state("new_sale.step4",
    url: "/sales/step4",
    ncyBreadcrumb:
      label: 'Detalle de Orden de Venta'
    views:
      'content':
        templateUrl: "partials/sales/step4.html"
        controller: "SaleOrderLiquidateCtrl"
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

  # Marketplace
  .state("marketplace",
    url: "/marketplace",
    ncyBreadcrumb:
      label: 'Marketplace'
    views:
      'content':
        templateUrl: "partials/marketplace/index.html"
        controller: "MarketplaceCtrl"
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

# --------- End Sales Routes ------------------#

  $urlRouterProvider.otherwise "/home"

  # Satellizer config
  $authProvider.loginUrl = '/api/v1/auth/login';
  $authProvider.loginRedirect = '/dashboard';
  $authProvider.tokenName = 'access_token'

