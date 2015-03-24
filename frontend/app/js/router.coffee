angular.module("app").config ($stateProvider, $urlRouterProvider, $authProvider) ->

  #TODO: apply some 'universal resolve' approach to avoid boilerplate code here
  # see this link: http://spin.atomicobject.com/2014/10/04/javascript-angularjs-resolve-routes/
  $stateProvider.state("home",
    url: "/home"
    ncyBreadcrumb: 
      label: 'Home page'
      skip: true
    views:
      'content':
        templateUrl: "home.html"
        controller: "HomeCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        if $auth.isAuthenticated()
          $location.path "/dashboard"
        else
          deferred.resolve()
        deferred.promise
  ).state("login",
    url: "/login"
    ncyBreadcrumb: 
      label: 'Login'
      skip: true
    views:
      'content':
        templateUrl: "login.html"
        controller: "AuthCtrl"
  ).state("scanner",
    url: "/scanner",
    ncyBreadcrumb: 
      label: 'PDF scanner'
    views:
      'content':
        templateUrl: "scanner.html"
      'sidebar':
        templateUrl: "sidebar.html"
        controller: "SidebarCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  ).state("providerEdition",
    url: "/provider",
    ncyBreadcrumb: 
      label: 'Provider'
    views:
      'content':
        templateUrl: "provider/provider_edition.html"
      'sidebar':
        templateUrl: "sidebar.html"
        controller: "SidebarCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  ).state("providerList",
    url: "/provider/all",
    ncyBreadcrumb: 
      label: 'Providers'
    views:
      'content':
        templateUrl: "provider/provider_list.html"
      'sidebar':
        templateUrl: "sidebar.html"
        controller: "SidebarCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  ).state("inventoryList",
    url: "/inventory/all",
    ncyBreadcrumb: 
      label: 'Inventory'
    views:
      'content':
        templateUrl: "partials/inventory/list.html"
      'sidebar':
        templateUrl: "sidebar.html"
        controller: "SidebarCtrl"
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise
  ).state("inventoryLiquidate",
  url: "/inventory/liquidate",
  ncyBreadcrumb:
    label: 'Inventory'
  views:
    'content':
      templateUrl: "partials/inventory/liquidate.html"
    'sidebar':
      templateUrl: "sidebar.html"
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
  # Transporters routes
  .state("newTransporter",
  url: "/tranporter",
  ncyBreadcrumb:
    label: 'Tranporter'
  views:
    'content':
      templateUrl: "partials/transporter/new.html"
    'sidebar':
      templateUrl: "sidebar.html"
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
        templateUrl: "dashboard.html"
        controller: "DashboardCtrl" 
      'sidebar':
        templateUrl: "sidebar.html"
        controller: "SidebarCtrl" 
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/login"
        else
          deferred.resolve()
        deferred.promise

  $urlRouterProvider.otherwise "/home"

  # Satellizer config
  $authProvider.loginUrl = '/api/v1/auth/login';
  $authProvider.loginRedirect = '/dashboard';
  $authProvider.tokenName = 'access_token'