angular.module('app').directive 'mdTableInventory', ($mdDialog) ->
  {
    restrict: 'E'
    scope:
      headers: '='
      content: '='
      sortable: '='
      filters: '='
      customClass: '=customClass'
      thumbs: '='
      count: '='
      grams: '='
      selectall: '='

    controller: ($scope, $filter, $window)->
      orderBy = $filter('orderBy')
      $scope.tablePage = 0
      $scope.nbOfPages = ->
        if $scope.content
          Math.ceil $scope.content.length / $scope.count
        else
          1

      $scope.handleSort = (field) ->
        if $scope.sortable.indexOf(field) > -1
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

      $scope.goToPage = (page) ->
        $scope.tablePage = page
        return

      #selects a single item in the inventory list
      #@params item [Object]

      $scope.selectItem = (item, grams, ev) ->
        $scope.batch_picked = item
        console.log item
        console.log 'selecciona item' + item.date + ' ' + grams.value + ' ' + item.selected
        if item.selected
          grams.value = grams.value - 1
        else
          grams.value = grams.value + 1
        
        $mdDialog.show(
          controller: 'InventoryAmountCtrl'
          templateUrl: 'partials/inventory_amount_form.html'
          targetEvent: ev).then ((answer) ->
          $scope.alert = 'You said the information was "' + answer + '".'
          return
        ), ->
          $scope.alert = 'You cancelled the dialog.'
          return
        return


      #updates all checkboxes in the inventory list
      # @params inventoryList [Array]

      $scope.selectAll = (inventoryList, grams, selectall) ->
        i = 0
        while i < inventoryList.length
          if selectall
            inventoryList[i].selected = false
            grams.value = 0
          else
            inventoryList[i].selected = true
            grams.value = inventoryList.length
          i++
        console.log 'select all value ' + selectall
        console.log 'rows selected number' + inventoryList.length
        return

      return
    templateUrl: 'directives/md-table-inventory.html'
  }
