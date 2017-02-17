require(['mssql.parser'], function(mssqlParser){
  
   var app = angular.module('app', ['ngMaterial', 'ngPrettyJson'])
   .factory('$mssqlParser', function(){
     return mssqlParser;
   })
   .controller('demoCtrl', function($scope, $mssqlParser){
        $scope.data = {
            input: 'ddd', output: ''
        };
        $scope.textChange = function(){
            try {
                $scope.data.output = $mssqlParser.tableScript($scope.data.input);
            } catch (error) {
                $scope.data.output = error;
            }
        };
   }); 
  
   angular.bootstrap(document, ['app']);
   
});


