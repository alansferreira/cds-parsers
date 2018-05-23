var assert = require('mocha');
var cdsParser = require('../src/index');
var fs = require('fs');

describe('Read and parse table scripts', function(){
    it('should parse cobol copybook', function(){
        var script = new String(fs.readFileSync('./test/CCP0001.CPY'));
        
        var book = cdsParser.COBOL.COPYBOOK.loadBook(script);
        
        assert(book.length==49, 'error');
    });


    it('should parse 13 DB2 tables', function(){
        var script = new String(fs.readFileSync('./test/db2.full-script.sql'));
        
        var tables = cdsParser.SQL.DB2.parseTable(script);
        
        assert(tables.length==13, 'error');
    });


    it('should parse 4 MSSQL tables', function(){
        var script = new String(fs.readFileSync('./test/mssql.full-script.sql'));
        
        var tables = cdsParser.SQL.MSSQL.parseTable(script);
        assert(tables.length==4, 'error');
    });

});



// fs.readFile('scripts/db2.column.identity.test.sql', function(err, data){
//     var script = new String(data).toString();
//     var tables = cdsParser.parseColumn(script);
//     console.log(tables);
// });


