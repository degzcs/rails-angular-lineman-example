angular.module('app').controller 'ClientShowCtrl', ($scope,$sce, $state, $stateParams, $window, ClientService, RucomService, LocationService,$mdDialog) ->
  # *** Loading Variables **** #
  $scope.showLoading = true
  $scope.loadingMode = "indeterminate"
  $scope.loadingMessage = "Cargando ..."
  # *********************************** VARIABLES ********************************** #
  $scope.currentExternalUser = null
  $scope.company = null
  $scope.rucomIDField =
    label: 'Numero'
    field: 'num_rucom'
  # ******************************************************************************** #
  if $stateParams.id
    ClientService.get($stateParams.id).success (data)->
      console.log data
      # 1. Cancel loading map
      $scope.showLoading = false
      # 2. Set scope variables
      $scope.company = data.company
      $scope.currentExternalUser = data
      # 3. Set map
      map = "<iframe width='600' height='450' frameborder='0' style='border:0' src='https://www.google.com/maps/embed/v1/place?key=AIzaSyBSvGJkkB0CyXnEQsd16bgVBEeNm49tQZM &q=#{data.city.name},#{data.state.name}'></iframe>"
      $scope.map_iframe = $sce.trustAsHtml(map);
  