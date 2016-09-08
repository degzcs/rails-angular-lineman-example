angular.module('app').controller 'AuthorizedProviderShowCtrl', ($scope,$sce, $state, $stateParams, $window, AuthorizedProvider, RucomService, LocationService,$mdDialog) ->
  # *** Loading Variables **** #
  $scope.showLoading = true
  $scope.loadingMode = "indeterminate"
  $scope.loadingMessage = "Cargando ..."
  # *********************************** VARIABLES ********************************** #
  $scope.currentAuthorizedProvider = null
  $scope.company = null
  $scope.rucomIDField =
    label: 'Numero'
    field: 'num_rucom'
  # ******************************************************************************** #
  if $stateParams.id
    AuthorizedProvider.get($stateParams.id).success (data)->
      # 1. Cancel loading map
      $scope.showLoading = false
      # 2. Set scope variables
      $scope.company = data.company
      $scope.currentAuthorizedProvider = data
      # 3. Set map
      map = "<iframe width='800' height='450' frameborder='0' style='border:0' src='https://www.google.com/maps/embed/v1/place?key=AIzaSyA6ygHFh-nrWQhsmypiONtiriz2DiTwUSQ&q=#{data.city.name},#{data.state.name}'></iframe>"
      $scope.map_iframe = $sce.trustAsHtml(map);
