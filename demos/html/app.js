require(['mssql.parser'], function(mssqlParser){
  
   var app = angular.module('app', [])
   .factory('$mssqlParser', function(){
     return mssqlParser;
   })
   .controller('demoCtrl', function($scope, $mssqlParser){
     $scope.msg = $mssqlParser; 
   }); 
  
   angular.bootstrap(document, ['app']);
   
});


