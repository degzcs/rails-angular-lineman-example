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
        templateUrl: "pages/home.html"
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

  .state("scanner",
    url: "/scanner",
    ncyBreadcrumb: 
      label: 'PDF scanner'
    views:
      'content':
        templateUrl: "pages/scanner.html"
      'sidebar':
        templateUrl: "partials/partials/sidebar.html"
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

  .state "dashboard",
    url: "/dashboard"
    ncyBreadcrumb: 
      label: 'Dashboard'
    views:
      'content':
        templateUrl: "pages/dashboard.html"
        controller: "DashboardCtrl" 
      'sidebar':
        templateUrl: "partials/sidebar.html"
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
        templateUrl: "pages/sessions/new.html"
        controller: "SessionsNewCtrl"
  )

  #  --- Providers Routes ---- #
  
  .state("providers",
    url: "/providers",
    ncyBreadcrumb:
      label: 'Providers'
    views:
      'content':
        templateUrl: "pages/providers/index.html"
        controller: "ProvidersIndexCtrl"
      'sidebar':
        templateUrl: "partials/sidebar.html"
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

  .state("edit_provider",
    url: "/provider",
    ncyBreadcrumb:
      label: 'Provider'
    views:
      'content':
        templateUrl: "pages/providers/edit.html"
        controller: "ProvidersEditCtrl"
      'sidebar':
        templateUrl: "partials/sidebar.html"
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
        templateUrl: "pages/batches/index.html"
        controller: "BatchesIndexCtrl"
      'sidebar':
        templateUrl: "partials/sidebar.html"
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

  .state( "show_batch",
    url: "/inventory/detail",
    ncyBreadcrumb:
      label: 'Detail'
    views:
      'content':
        templateUrl: "pages/batches/show.html"
        controller: "BatchesShowCtrl"
      'sidebar':
        templateUrl: "partials/sidebar.html"
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

  .state( "liquidate_batches",
    url: "/inventory/liquidate",
    ncyBreadcrumb:
      label: 'Inventory'
    views:
      'content':
        templateUrl: "pages/batches/liquidate.html"
        controller: "BatchesLiquidateCtrl"
      'sidebar':
        templateUrl: "partials/sidebar.html"
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


  #  --- Transporters Routes ---- #

  .state("new_transporter",
    url: "/tranporter",
    ncyBreadcrumb:
      label: 'Tranporter'
    views:
      'content':
        templateUrl: "pages/transporters/new.html"
        controller: "TransportersNewCtrl"
      'sidebar':
        templateUrl: "partials/sidebar.html"
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