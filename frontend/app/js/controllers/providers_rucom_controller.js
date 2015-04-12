angular.module('app').controller('SearchRucomCtrl', ['$scope', 'RucomService' ,function($scope, RucomService){
  
  $scope.toggleSearch = false;      
  $scope.headers = [
    {
      name: 'RUCOM Number', 
      field: 'num_rucom',
      alternateField: 'rucom_record'
    },{
      name: 'Provider type', 
      field: 'provider_type',
      alternateField: 'provider_type'
    },{
      name: 'Name', 
      field: 'name',
      alternateField: 'name'
    },{
      name: 'RUCOM Status', 
      field: 'status',
      alternateField: 'status'
    },{
      name: 'Mineral', 
      field: 'mineral',
      alternateField: 'mineral'
    }
  ];
  
  $scope.count = 10; 
  $scope.pages = 0; 

  RucomService.retrieveRucoms.query({per_page: $scope.count, page: 1}, (function(rucoms, headers) {
    var content = [];
    for (var i=0; i<rucoms.length; i++) {
      var rucom = {
        id: rucoms[i].id,
        name: rucoms[i].name,
        num_rucom: rucoms[i].num_rucom,
        rucom_record: rucoms[i].rucom_record,
        provider_type: rucoms[i].provider_type,
        status: rucoms[i].status,
        mineral: rucoms[i].mineral          
      };
      content.push(rucom);
    }
    $scope.pages = parseInt(headers().total_pages);
    return $scope.content = content;
  }), function(error) {});  

  $scope.custom = {num_rucom: 'bold', provider_type: 'gray', name: 'gray', status: 'gray'};
  $scope.sortable = ['num_rucom', 'provider_type', 'name', 'status'];  
  
}]);

// angular.module('app').filter('startFrom',function (){
//   return function(input, start) {
//     if (!input || !input.length) { return; }
//       start = +start; //parse to int
//       return input.slice(start);
//   };
// });
