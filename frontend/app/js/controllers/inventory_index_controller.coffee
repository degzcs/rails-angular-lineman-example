angular.module('app').controller 'InventoryIndexCtrl', ($scope)->


  $scope.toggleSearch = false
  $scope.headers = [
    {
      name:'',
      field:'thumbs'
    },{
      name: 'Fecha',
      field: 'date'
    },{
      name:'Hora',
      field: 'hour'
    },{
      name: 'Quien',
      field: 'quien'
    },{
      name: 'Cuantos',
      field: 'cuantos'
    },{
      name: 'Ley',
      field: 'law'
    },{
      name: 'Valor',
      field: 'value'
    }
  ]

  # get the list value from server response ans setup the list
  #InventoryService.query ((res) ->
  #  $scope.list = res.list
  #  $scope.count = res.list.length
  #), (error) ->
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