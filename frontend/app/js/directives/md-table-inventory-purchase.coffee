angular.module('app').directive 'mdTableInventoryPurchase', ($mdDialog, LiquidationService, $state, PurchaseService) ->
  {
    

    controller: ($scope, $filter, $window, PurchaseService)->
      
      


      

      $scope.nbOfPages = ->
        # if $scope.content
        #   Math.ceil $scope.content.length / $scope.count
        # else
        #   1
        $scope.pages || 0

      $scope.handleSort = (field) ->
        if $scope.sortable.indexOf(field) > 1
          true
        else
          false

      $scope.order = (predicate, reverse) ->
        $scope.content = orderBy($scope.content, predicate, reverse)
        $scope.predicate = predicate
        return

      $scope.order $scope.sortable[0], false

      $scope.getNumber = (num) ->
        new Array(num)

      $scope.loadMore = ->
        if $scope.pages > 0
          #i.e. if it's not the first time we retreve data from the API
          $scope.currentPage = $scope.currentPage + 1
          if $scope.currentPage <= $scope.pages
            return PurchaseService.all($scope.currentPage).success((purchases, status, headers, config)->
              i = undefined
              purchase = undefined
              i = 0
              while i < purchases.length
                purchase =
                  id: purchases[i].id
                  user_id: purchases[i].user_id
                  price: purchases[i].price
                  origin_certificate_file: purchases[i].origin_certificate_file
                  seller_picture: purchases[i].seller_picture
                  origin_certificate_sequence: purchases[i].origin_certificate_sequence
                  created_at: purchases[i].created_at
                  reference_code: purchases[i].reference_code
                  access_token: purchases[i].access_token
                  provider: purchases[i].provider
                  gold_batch: purchases[i].gold_batch
                  inventory: purchases[i].inventory
                  provider_name: purchases[i].provider.first_name + ' ' + purchases[i].provider.last_name
                  inventory_remaining_amount: purchases[i].inventory.remaining_amount
                  gold_batch_grams: purchases[i].gold_batch.grams
                  sold: purchases[i].gold_batch.sold
                $scope.content.push purchase
                i++
              $scope.pages = parseInt(headers().total_pages)
              $scope.count = $scope.content.length
            ).error((data, status, headers, config) ->
              $scope.infoAlert 'ERROR', 'No se pudo realizar la solicitud'
            )
        return

      #selects a single item in the inventory list
      #@params item [Object]

      #Show simple information dialog
      show_dialog = (title, message, ev)->
        $mdDialog.show(
          $mdDialog.alert()
          .title(title)
          .content(message)
          .ariaLabel('Alert Dialog Demo').ok('Ok')
          .targetEvent(ev))

      return

    

    templateUrl: 'partials/inventory/purchase_tab.html'
    link: (scope, element, attrs)->

      angular.element(element[0].querySelector('#hideButton')).on 'click', ->

        result = document.getElementsByClassName('purchase-empty')
        angular.element(result).toggleClass('hidden')
  }