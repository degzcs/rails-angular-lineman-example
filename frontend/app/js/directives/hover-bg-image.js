angular.module('app').directive('hoverBgImage',function(){
    return {
        link: function(scope, elm, attrs){
            elm.bind('mouseenter',function(){
                elm.attr('src',attrs.hoverBgImage);
            });
            elm.bind('mouseleave',function(){
                elm.attr('src','');
            })
        }
    };
});
