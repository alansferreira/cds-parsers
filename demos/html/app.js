require(['mssql.parser'], function(mssqlParser){
  
    var app = angular.module('app', ['ngMaterial', 'ngPrettyJson'])
    .factory('$mssqlParser', function(){
        return mssqlParser;
    })
    .config(function($mdThemingProvider) {

        // Configure a dark theme with primary foreground yellow

        $mdThemingProvider.theme('docs-dark', 'default')
        .primaryPalette('grey')
        .dark();

    })

    
    .controller('demoCtrl', function($scope, $mssqlParser){
        $scope.data = {
            input: ' create table t1(       ' +
                   '\r     id int,          ' +
                   '\r     name varchar(50) ' +
                   '\r )                    ', 
            output: {}, 
            editedOutput: {}
        };
        $scope.textChange = function(){
            try {
                $scope.data.output = $mssqlParser.tableScript($scope.data.input);
                $scope.data.editedOutput = angular.copy($scope.data.output, []);
            } catch (error) {
                $scope.data.output = error;
            }
        };
   }); 
  
   angular.bootstrap(document, ['app']);
   
});


