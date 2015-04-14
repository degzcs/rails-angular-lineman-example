angular.module('app').controller 'InventoryIndexCtrl', ($scope)->


  $scope.toggleSearch = false
  $scope.headers = [
    {
      name:'',
      field:'thumbs'
    },{
      name: 'Proovedor',
      field: 'provider_name'
    },{
      name:'Gramos Comprados',
      field: 'grams'
    },{
      name: 'Gramos Restantes',
      field: 'quien'
    },{
      name: 'Cuantos',
      field: 'cuantos'
    },{
      name: 'Fecha',
      field: 'created_at'
    },{
      name: 'Valor',
      field: 'price'
    }
  ]

  # get the list value from server response ans setup the list
  #InventoryService.query ((res) ->
  #  $scope.list = res.list
  #  $scope.count = res.list.length
  # ), (error) ->
    # Error handler code

  $scope.custom = {date: 'bold', hour:'grey', quien: 'grey', cuantos: 'grey', law:'grey', value: 'grey'}
  $scope.sortable = ['date', 'hour', 'quien', 'cuantos', 'law', 'value']
  $scope.thumbs = 'thumb';
  #$scope.count= $scope.list.length;

  # define scope values
  $scope.selectall = false
  $scope.grams = { value: 0 }

  #
  # Functions
  #

  # show detail of the inventory item
  # @params item [Object]
  $scope.show = (item) ->
    console.log 'selecciona item' + item.selected
    InventoryServic.setItem(item)