define('cds/parsers', ['mssql.parsers.js'], function(mssql){
  return {
      mssql: mssql
    };
});

 
require(['cds/parsers'], function(cdsParsers){
  
  var app = angular.module('app', [])
  .factory('$lib_x', function(){
    return lib_x;
  })
  .controller('demoCtrl', function($scope, $lib_x){
    $scope.msg = lib_x; 
  }); 
  
  /*app.controller('demoCtrl', function($scope, lib_x){
    $scope.msg = lib_x;  
  }); */
  
  angular.bootstrap(document, ['app']);
   
});





define('cds/parsers', 
    ['require', 'mssql.parsers.js'], 
    function(require, mssqlParsers) {
        'use strict';
        
        return {
            mssql: require('mssql.parsers')
        };
    }
);
