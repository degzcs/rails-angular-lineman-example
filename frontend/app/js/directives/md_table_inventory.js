angular.module('app').directive('mdTableInventory', function () {
    return {
        restrict: 'E',
        scope: {
            headers: '=',
            content: '=',
            sortable: '=',
            filters: '=',
            customClass: '=customClass',
            thumbs:'=',
            count: '=',
            grams: '=',
            selectall: '='
        },
        controller: function ($scope,$filter,$window) {
            var orderBy = $filter('orderBy');
            $scope.tablePage = 0;
            $scope.nbOfPages = function () {
                if($scope.content) {
                    return Math.ceil($scope.content.length / $scope.count);
                }
                else {return 1;}
            };
            $scope.handleSort = function (field) {
                if ($scope.sortable.indexOf(field) > -1) { return true; } else { return false; }
            };
            $scope.order = function(predicate, reverse) {
                $scope.content = orderBy($scope.content, predicate, reverse);
                $scope.predicate = predicate;
            };
            $scope.order($scope.sortable[0],false);
            $scope.getNumber = function (num) {
                return new Array(num);
            };
            $scope.goToPage = function (page) {
                $scope.tablePage = page;
            };
            //selects a single item in the inventory list
            //@params item [Object]
            $scope.selectItem = function (item,grams) {
                console.log('selecciona item' + item.date + ' ' + grams.value+ ' '+item.selected);
                if(item.selected){
                    grams.value=grams.value-1;
                }
                else{
                    grams.value=grams.value+1;
                }
            };
            //updates all checkboxes in the inventory list
            // @params inventoryList [Array]
            $scope.selectAll = function (inventoryList,grams,selectall) {
              i=0;
              while(i < inventoryList.length){
                  if (selectall) {
                      inventoryList[i].selected = false;
                      grams.value=0;
                  }
                  else {
                      inventoryList[i].selected = true;
                      grams.value=inventoryList.length;
                  }
                  i++;
              }

                console.log('select all value ' + selectall);
                console.log('rows selected number' + inventoryList.length);
            };




        },
        //template: angular.element(document.querySelector('#md-table-template')).html()
        templateUrl: 'directives/md-table-inventory.html'
    };
});