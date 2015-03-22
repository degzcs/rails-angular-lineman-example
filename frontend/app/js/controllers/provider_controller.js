angular.module('app').controller('ProviderCtrl', ['$scope', function($scope){
  $scope.toggleSearch = false;   
  $scope.headers = [
    {
      name:'',
      field:'thumb'
    },{
      name: 'Name', 
      field: 'name'
    },{
      name:'Id', 
      field: 'id'
    },{
      name: 'Mineral', 
      field: 'mineral'
    },{
      name: 'Id RUCOM', 
      field: 'id_rucom'
    },{
      name: 'RUCOM Status', 
      field: 'rucom_status'
    },{
      name: 'Last Transaction', 
      field: 'last_transaction'
    }
  ];
  
  $scope.content = [
    {
      thumb:'https://ssl.gstatic.com/s2/profiles/images/silhouette48.png', 
      name: 'Diego Caicedo',
      id: '9800000-1',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201502204885',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction: '05/06/2014'
    },{
      thumb:'https://lh4.googleusercontent.com/-wx3BmJUhhpE/AAAAAAAAAAI/AAAAAAAAACM/R6R-aAQB62E/photo.jpg', 
      name: 'Andres Maya',
      id: '9800000-2',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201503014886',
      rucom_status: 'Certificado',
      last_transaction: '19/03/2014'
    },{
      thumb:'https://lh4.googleusercontent.com/-MPs16CJ6ZBI/AAAAAAAAAAI/AAAAAAAAAfw/qZNidz7KVvo/photo.jpg', 
      name: 'Carlos Mejía',
      id: '9800000-3',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201403014887',
      rucom_status: 'Certificado',
      last_transaction: '14/05/2014'
    },{
      thumb:'https://lh3.googleusercontent.com/-7qT3MgVr0rk/AAAAAAAAAAI/AAAAAAAAAJE/i1Yc_rFyVz8/photo.jpg', 
      name: 'Camilo Pedraza',
      id: '9800000-4',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201303014890',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction: '03/01/2014'
    },{
      thumb:'https://lh3.googleusercontent.com/-xUqWqzQQaZc/AAAAAAAAAAI/AAAAAAAAA88/M5EhGqXSItk/photo.jpg', 
      name: 'Jesus Muñoz',
      id: '9800000-5',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201503014892',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction: '01/02/2014'
    },{
      thumb:'https://lh6.googleusercontent.com/-KAhFBi4grKU/AAAAAAAAAAI/AAAAAAAABLM/hnWGNvV7D2k/photo.jpg', 
      name: 'Esteban Cerón',
      id: '9800000-6',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201203014810',
      rucom_status: 'Certificado',
      last_transaction: '01/01/2015'
    },{
      thumb:'https://plus.google.com/u/0/_/focus/photos/public/AIbEiAIAAABECOnz4JakhaOK_gEiC3ZjYXJkX3Bob3RvKihiMWQyMWNkZmRiYzIzM2EzODUyZDQyMjU3ZWVlZTU4MzU0MWE3ZjY3MAFLUhAwq57N0mPOSXuYPdiOmJZ9KQ?sz=48', 
      name: 'Juan Cerón',
      id: '9800000-7',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201303014800',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction: '06/10/2013'
    },{
      thumb:'https://lh3.googleusercontent.com/-q9i8c2WHh9I/AAAAAAAAAAI/AAAAAAAAAK0/p9wFW0PJ_oo/photo.jpg', 
      name: 'Diego Gómez',
      id: '9800000-8',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201403014802',
      rucom_status: 'Certificado',
      last_transaction: '04/12/2014'
    },{
      thumb:'https://lh4.googleusercontent.com/-kzZKDrB6wb4/AAAAAAAAAAI/AAAAAAAAAzU/CnnUA5Ygbjs/photo.jpg', 
      name: 'Javier Suarez',
      id: '9800000-9',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201303014201',
      rucom_status: 'Certificado',
      last_transaction: '11/05/2013'
    },{
      thumb:'https://lh5.googleusercontent.com/-K1ZinAJG6D0/AAAAAAAAAAI/AAAAAAAAAGk/vFy0NwAptgI/photo.jpg', 
      name: 'Luis Rojas',
      id: '9800001-0',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201403014833',
      rucom_status: 'Certificado',
      last_transaction: '03/03/2015'
    },{
      thumb:'https://lh4.googleusercontent.com/-9pJ7LbpZ_nA/AAAAAAAAAAI/AAAAAAAAFuc/VxoI6yvIzlE/photo.jpg', 
      name: 'Leandro Ordóñez',
      id: '9800001-1',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201403014943',
      rucom_status: 'Certificado',
      last_transaction: '04/08/2014'
    },{
      thumb:'https://ssl.gstatic.com/s2/profiles/images/silhouette48.png', 
      name: 'Conrado Franco',
      id: '9800001-2',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201503204884',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction: '08/07/2013'
    },{
      thumb:'https://ssl.gstatic.com/s2/profiles/images/silhouette48.png', 
      name: 'José Valdovino',
      id: '9800001-3',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201503204883',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction: '10/01/2015'
    },{
      thumb:'https://ssl.gstatic.com/s2/profiles/images/silhouette48.png', 
      name: 'Sandis Martinez',
      id: '9800001-4',
      mineral: 'Oro',
      id_rucom: 'RUCOM-201503194882',
      rucom_status: 'En trámite, pendiente de evaluación',
      last_transaction: '12/05/2013'
    }
  ];
  
  $scope.custom = {name: 'bold', id:'grey', mineral: 'grey', id_rucom: 'grey', rucom_status:'grey', last_transaction: 'grey'};
  $scope.sortable = ['name', 'id', 'mineral', 'id_rucom', 'rucom_status', 'last_transaction'];
  $scope.thumbs = 'thumb';
  $scope.count = 5;
}]);

angular.module('app').filter('startFrom',function (){
  return function(input, start) {
    if (!input || !input.length) { return; }
      start = +start; //parse to int
      return input.slice(start);
  };
});