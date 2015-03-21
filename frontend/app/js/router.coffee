angular.module("app").config ($stateProvider, $urlRouterProvider, $authProvider) ->

  $stateProvider.state("home",
    url: "/home"
    templateUrl: "home.html"
    controller: "HomeCtrl"
  ).state("login",
    url: "/login"
    templateUrl: "login.html"
    controller: "LoginCtrl"
  )
  .state("logout",
    url: "/logout"
    template: null
    controller: "LogoutCtrl"
  ).state("scanner",
    url: "/scanner",
    templateUrl: "scanner.html"
  ).state("providerList",
    url: "/provider/all",
    templateUrl: "provider_list.html"
  ).state("inventoryList",
    url: "/inventory/all",
    templateUrl: "inventory/list_inventory.html"
  ).state "dashboard",
    url: "/dashboard"
    templateUrl: "dashboard.html"
    controller: "DashboardCtrl" 
    resolve:
      authenticated: ($q, $location, $auth) ->
        deferred = $q.defer()
        unless $auth.isAuthenticated()
          $location.path "/home"
        else
          deferred.resolve()
        deferred.promise

  $urlRouterProvider.otherwise "/home"

  # Satellizer config
  $authProvider.loginUrl = '/api/v1/auth/login';
  $authProvider.loginRedirect = '/dashboard';
  $authProvider.tokenName = 'access_token'