angular.module("app").config ($stateProvider, $urlRouterProvider, $authProvider) ->

  $stateProvider.state("home",
    url: "/home"
    templateUrl: "home.html"
    controller: "HomeCtrl"
    ncyBreadcrumb: 
      label: 'Home page'
  ).state("login",
    url: "/login"
    templateUrl: "login.html"
    controller: "LoginCtrl"
    ncyBreadcrumb: 
      label: 'Login'
      skip: true
  )
  .state("logout",
    url: "/logout"
    template: null
    controller: "LogoutCtrl"
  ).state("scanner",
    url: "/scanner",
    templateUrl: "scanner.html"
    ncyBreadcrumb: 
      label: 'PDF scanner'
  ).state("providerList",
    url: "/provider/all",
    templateUrl: "provider_list.html"
    ncyBreadcrumb: 
      label: 'Providers'
  ).state("inventoryList",
    url: "/inventoryList",
    templateUrl: "inventory/list_inventory.html"
    ncyBreadcrumb: 
      label: 'Inventory'
  ).
  state "dashboard",
    url: "/dashboard"
    templateUrl: "dashboard.html"
    controller: "DashboardCtrl" 
    ncyBreadcrumb: 
      label: 'Dashboard'
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