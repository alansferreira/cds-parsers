var db2Parser = require('./src/db2.parsers');
var fs = require('fs');



// fs.readFile('scripts/db2.column.identity.test.sql', function(err, data){
//     var script = new String(data).toString();
//     var tables = db2Parser.parseColumn(script);
//     console.log(tables);
// });


fs.readFile('scripts/db2.tables.test.sql', function(err, data){
    var script = new String(data);
    var tables = db2Parser.parseTable(script);
    console.log(tables);
});
