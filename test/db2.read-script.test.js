var assert = require('mocha');
var db2Parser = require('../src/db2-table.parser');
var fs = require('fs');
var path = require('path');

var script = new String(fs.readFileSync('./test/db2.full-script.sql'));

describe('should read script and load tables definition', function(){
    it('should parse 8 tables', function(){
        var tables = db2Parser.parseTable(script);
        
        assert(tables.length==8);
    });
});




// fs.readFile('scripts/db2.column.identity.test.sql', function(err, data){
//     var script = new String(data).toString();
//     var tables = db2Parser.parseColumn(script);
//     console.log(tables);
// });


