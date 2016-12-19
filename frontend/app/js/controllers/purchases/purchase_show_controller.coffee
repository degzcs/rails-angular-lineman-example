angular.module('app').controller 'PurchasesShowCtrl', ($scope, PurchaseService, GoldBatchService, CameraService, $timeout, $q, $mdDialog, CurrentUser,  $sce) ->

  #
  # Instances
  #

  PurchaseService.restoreState()
  GoldBatchService.restoreState()
  $scope.purchase = PurchaseService
  $scope.goldBatch = GoldBatchService
  $scope.barcode_html = $sce.trustAsHtml($scope.purchase.model.barcode_html)
  CurrentUser.get().success (data) ->
    $scope.current_user = data
    $scope.buyer_data = buyer_data_from($scope.current_user)
    # window.scope = $scope

  #
  # Fuctions
  #

  buyer_data_from = (current_user)->
    if current_user.company
      {
        company_name: current_user.company.name,
        office: current_user.office,
        nit: current_user.company.nit_number,
        rucom_number: current_user.company.rucom.rucom_number,
        first_name: current_user.company.legal_representative.profile.first_name,
        last_name: current_user.company.legal_representative.profile.last_name,
        address: current_user.company.address,
        phone: current_user.company.phone_number,
      }
    else
      {
        company_name: 'NA',
        office: 'NA',
        nit: 'NA',
        rucom_number: 'NA',
        first_name: current_user.profile.first_name,
        last_name: current_user.profile.last_name,
        address: current_user.profile.address,
        phone: current_user.profile.phone_number,
      }


  $scope.flushData =->
    PurchaseService.deleteState()
    GoldBatchService.deleteState()

    PurchaseService.model =
      price: 0
      seller_picture: ''
      seller: {}
      origin_certificate_sequence: ''
      origin_certificate_file: ''
      proof_of_purchase_file_url: ''
      fine_gram_unit_price: 0 # this is set up for current buyer (currently logged user )
      reference_code: ''
      barcode_html: ''
      code: ''

    GoldBatchService.model =
      parent_batches: ''
      grade: 1
      grams: 0 # the introduced grams  by the seller or seller
      castellanos: 0
      ozs: 0
      tomines: 0
      reales: 0
      granos: 0
      inventory_id: 1
      total_grams: 0
      total_fine_grams: 0
      mineral_type: ''

    # console.log 'deleting sessionStorage ...'


  $scope.DownloadPurchaseFiles =->
    window.open($scope.purchase.model.proof_of_purchase_file_url, "_blank")
    window.open($scope.purchase.model.origin_certificate_file_url, "_blank")
    return true


  #
  # Flush data on change state
  #

  $scope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    PurchaseService.flushModel()
    return