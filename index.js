module.exports = {
    DB2: function(){return require('./src/db2-table.parser');}, 
    SqlServer: function(){return require('./src/mssql-table.parser');}, 
}