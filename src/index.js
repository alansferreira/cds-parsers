define('cds/parsers', 
    ['require', 'mssql.parsers.js'], 
    function(require, mssqlParsers) {
        'use strict';
        
        return {
            mssql: require('mssql.parsers')
        };
    }
);
