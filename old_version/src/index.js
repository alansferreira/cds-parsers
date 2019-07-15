const db2 = require('./sql/db2-table.parser');
const mssql = require('./sql/mssql-table.parser');
const copybook = require('./cobol/cobol-copybook.parser');
const cobolProgram = require('./cobol/cobol-program.parser');

module.exports = {
    sql: {
        db2: db2, 
        mssql: mssql, 
    },
    cobol: {
        copybook: copybook, 
        program: cobolProgram
    }
}