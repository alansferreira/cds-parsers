# cds-parsers
## Install to use
>`bower i -s cds-parsers-amd`

>`npm i -s cds-parsers-amd`

## Using 

On AMD system
```javascript
var parser = require('mssql.parser');
```

On demand Html
```html
<!-- html -->
<script src="{bower_components}/requirejs/require.js"></script>
<script src="{bower_components}/cds-parsers-amd/src/mssql.parsers.js"></script>
<script>
var parser = require('mssql.parser');
var tables = parser.tableScript('CREATE TABLE table1 ( column1 int, column2 varchar(50) ');

console.log(tables);
</script>
```

On angular sync Load
```javascript
var mssqlParser = require('mssql.parser');

var app = angular.module('app', [])
.factory('$mssqlParser', function(){
    return mssqlParser;
})
.controller('demoCtrl', function($scope, $mssqlParser){
    
    $scope.output = $mssqlParser.tableScript('CREATE TABLE table1 ( column1 int, column2 varchar(50) ');

});

```

On angular with AMD system
```javascript
require(['mssql.parser'], function(mssqlParser){
    
    var app = angular.module('app', [])
    
    .factory('$mssqlParser', function(){
        return mssqlParser;
    })
    .controller('demoCtrl', function($scope, $mssqlParser){
        
        $scope.output = $mssqlParser.tableScript('CREATE TABLE table1 ( column1 int, column2 varchar(50) ');

    });

    angular.bootstrap(document, ['app']);

});
```



## Contributing

>`npm i`

>`npm run semver-sync`

>`npm publish`
