var db2 = require('./sql/db2-table.parser');
var mssql = require('./sql/mssql-table.parser');
var copybook = require('./cobol/cobol-copybook.parser');

module.exports = {
    SQL: {
        DB2: db2, 
        MSSQL: mssql, 
    },
    COBOL: {
        COPYBOOK: copybook, 
    }
}