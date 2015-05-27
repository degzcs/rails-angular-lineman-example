angular.module('app').controller 'ExternalUserCreateCtrl', ($scope, $state, $stateParams, $window, ExternalUser, RucomService, LocationService,$mdDialog,CameraService,ScannerService) ->
  $scope.newExternalUser = ExternalUser.restoreModelToCreate()
  
  # ****** Tab directive variables and methods ********** #
  $scope.tabIndex =
    selectedIndex: 0
  $scope.next = ->
    $scope.data.selectedIndex = Math.min($scope.data.selectedIndex + 1, 1) 
  $scope.previous = ->
    $scope.data.selectedIndex = Math.max($scope.data.selectedIndex - 1, 0)
  goToDocumentation = ->
    $scope.tabIndex.selectedIndex = 1 
  
  # ********* Scanner variables and methods *********** #
  $scope.photo = CameraService.getLastScanImage()
  if CameraService.getJoinedFile() and CameraService.getJoinedFile().length > 0
    $scope.file = CameraService.getJoinedFile()
  else if ScannerService.getScanFiles() and ScannerService.getScanFiles().length > 0
    $scope.file = ScannerService.getScanFiles()
  
  if $scope.photo and CameraService.getTypeFile() == 1
    ExternalUser.modelToCreate.external_user.photo_file = $scope.photo
    ExternalUser.saveModelToCreate()
    CameraService.clearData()

  if $scope.file
    if CameraService.getTypeFile() == 2
      ExternalUser.modelToCreate.external_user.document_number_file = $scope.file
      goToDocumentation()
    if CameraService.getTypeFile() == 3
      ExternalUser.modelToCreate.external_user.mining_register_file = $scope.file
      goToDocumentation()
    if CameraService.getTypeFile() == 4
      ExternalUser.modelToCreate.external_user.rut_file = $scope.file
      goToDocumentation()
    if CameraService.getTypeFile() == 5
      ExternalUser.modelToCreate.external_user.chamber_commerce_file = $scope.file
      goToDocumentation()
    ExternalUser.saveModelToCreate()
    CameraService.clearData()
    ScannerService.clearData()
  $scope.scanner = (type) ->
    CameraService.setTypeFile type
    return

  #****************************************************** #
  console.log $scope.newExternalUser
  