var {from} = require('linq');

const sortModel = { ASC: "ASC", DESC: "DESC" };
const regexes = {
    COMMENT: /(\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/)|(\/\/.*)/g,

    DATABASE_START_POINT: /(((CREATE)|(ALTER)) {1,}(DATABASE)|(USE)) {1,}([a-zA-Z0-9]+)/igm,

    CREATE_TABLE_HEADER: {
        EXPRESSION: /(CREATE|ALTER) {1,}(TABLE) {1,}(((\[[^\]]+\]|[a-zA-Z0-9_]+)\.(\[[^\]]+\]|[a-zA-Z0-9_]+))|(\[[^\]]+\]|[a-zA-Z0-9_]+))[ ]{0,}\([ ]{0,}/igm,
        CAPTURES_INDEXES: {
            COMMAND_TYPE: 1,
            SCHEMA_NAME: 5,
            TABLE_NAME: 6,
            TABLE_NAME_ALTERNATIVE: 7,
        }
    },
    CONSTRAINT_INLINE: /CONSTRAINT[ ]{0,}(\[{0,}[^\[]+\]{0,})(.+(CLUSTERED)?)?[ ]{0,}\(([^\)]+)\)+/igm,
    CONSTRAINT_PRIMARY_KEY_HEADER: {
        EXPRESSION: /CONSTRAINT +\[?([^\]]+)\]? {0,}(PRIMARY +KEY)[^\(]+(\([^\)]+\))/img,
        CAPTURES_INDEXES: {
            CONSTRANTI_NAME: 1,
            COLUMNS_SPEC: 3
        },
        FIELDS_DEF: {
            EXPRESSION: / {0,},? {0,}\[?([^\)\(\]]+)\]? +(ASC|DESC)/img,
            CAPTURES_INDEXES: {
                FIELD_NAME: 1,
                SORT_TYPE: 2
            }
        }
    },

    CONSTRAINT_FOREIGN_KEY_HEADER: {
        EXPRESSION: /CONSTRAINT +\[?([^\]]+)\]? {0,}(FOREIGN {0,}KEY)[^\(]+\(/img,
        CONSTRANTI_NAME: 1,
    },
    CONSTRAINT_FOREIGN_KEY_HEADER: {
        EXPRESSION: /CONSTRAINT +\[?([^\]]+)\]? {0,}(FOREIGN {0,}KEY)[^\(]+\(/img,
        CONSTRANTI_NAME: 1,
    },


    TABLE_COLUMN: {
        EXPRESSION: /(\[[^\]]+\]|[a-zA-Z0-9_]+)[ ]+((\[[^\]]+\]|[a-zA-Z0-9_]+)([ ]{0,}\([ ]{0,}(([0-9]+)([ ]{0,},[ ]{0,}([0-9]))?)[ ]{0,}\))?)([ ]{1,}(FOR[ ]{1,}[^ ]+[ ]{1,}DATA))?([ ]{1,}(NOT[ ]{1,})?NULL)?([ ]{1,}(WITH[ ]{1,}DEFAULT[ ]{1,})([^ ]+))?([ ]{1,}(GENERATED +BY +DEFAULT +AS +IDENTITY([ ]{0,}\([^\)]+\))))?[ ]{0,}[,]{0,}[ ]{0,}([ ]{1,}(PRIMARY[ ]{1,}KEY([ ]{1,}ASC|[ ]{1,}DESC)))?[,\)] ?/ig,
        CAPTURES_INDEXES: {
            NAME: 1,
            DATA_TYPE: 3,
            PRECISION: 6,
            SCALE: 8,
            IS_IDENTITY: 13,
            IDENTITY_SEED: 15,
            IDENTITY_STEP: 16,
            IS_NOT_NULL: 10,
            IS_PRIMARY: 99,
        }
    }
};


function Column(initialData) {
    this.name = "";
    this.isPrimary = false;
    this.table = null; //new Table();
    this.type = "";
    this.precision = 0;
    this.scale = 0;
    this.isNullable = true;
    this.isAutoIncrement = false;
    this.increment = { seed: 0, step: 1 };

    Object.deepExtend(this, initialData || {});

    this.name = clearSysname(this.name);
};

function Table(initialData) {
    this.name = "";
    this.schema = "";
    this.database = null;//new Database();
    this.columns = []; //[new Column()]
    this.indexes = []; //[new IndexContraint()]
    this.foregnKeys = []; //[new ForegnKeyContraint()]

    Object.deepExtend(this, initialData || {});

    this.name = clearSysname(this.name);

};

function PrimaryKey(initialData) {
    this.name = "";
    this.colunms = []; //[new ColumnIndexSpec()]
    Object.deepExtend(this, initialData || {});

    this.name = clearSysname(this.name);

};

function ColumnIndexSpec(initialData) {
    this.name = "";
    this.sort = SORT.ASC;

    Object.deepExtend(this, initialData || {});

    this.name = clearSysname(this.name);
};

function parseTableScript(scriptData){
    var tables = [];
    var script = scriptData.toString();
    var offset = 0;

    script = clearCommentsAndLines(script);

    iterateRegex(regexes.CREATE_TABLE_HEADER.EXPRESSION, script, function (regexp, inputText, match) {
        var tableScript = script.substring(match.index, script.indexOfCloser(match.index + match[0].length, "(", ")") + 1);
        var tableConstraints = [];

        var table = new Table({
            src: tableScript,
            schema: match[regexes.CREATE_TABLE_HEADER.CAPTURES_INDEXES.SCHEMA_NAME],
            name: match[regexes.CREATE_TABLE_HEADER.CAPTURES_INDEXES.TABLE_NAME] || match[regexes.CREATE_TABLE_HEADER.CAPTURES_INDEXES.TABLE_NAME_ALTERNATIVE]
        });

        tableScript = tableScript.substring(match[0].length);


        ////TABLE CONSTRAINTS
        //iterateRegex(regexes.CONSTRAINT_INLINE, tableScript, function (regexp, inputText, match) {
        //    tableConstraints.push(match);

        //    tableScript = tableScript.substring(0, match.index) + tableScript.substring(match.index + match[0].length);
        //});

        table.primaryKey = new PrimaryKey();
        tableScript.replaceAll(regexes.CONSTRAINT_PRIMARY_KEY_HEADER.EXPRESSION, function (primaryExpr, constraintName, type, columnsSpec) {
            columnsSpec.replaceAll(regexes.CONSTRAINT_PRIMARY_KEY_HEADER.FIELDS_DEF.EXPRESSION, function (columnSpec, fieldName, sortType) {

                table.primaryKey.colunms.push(new ColumnIndexSpec({ name: fieldName, sort: sortType }));

            });
        });

        ////iterateRegex(regexes.CONSTRAINT_PRIMARY_KEY_HEADER.EXPRESSION, tableScript, function (regexp, inputText, match) {
        ////    //tableConstraints.push(match);

        ////    table.primaryKey = new PrimaryKey(); 
        ////    iterateRegex(regexes.CONSTRAINT_PRIMARY_KEY_HEADER.FIELDS_DEF.EXPRESSION, match[regexes.CONSTRAINT_PRIMARY_KEY_HEADER.CAPTURES_INDEXES.COLUMNS_SPEC], function (regexp1, inputText1, match1) {
        ////        table.primaryKey.colunms.push(new ColumnIndexSpec({
        ////            name: match1[regexes.CONSTRAINT_PRIMARY_KEY_HEADER.FIELDS_DEF.CAPTURES_INDEXES.FIELD_NAME],
        ////            sort: match1[regexes.CONSTRAINT_PRIMARY_KEY_HEADER.FIELDS_DEF.CAPTURES_INDEXES.SORT_TYPE]
        ////        }));

        ////    });
        ////    tableScript = tableScript.substring(0, match.index) + tableScript.substring(match.index + match[0].length);
        ////});

        ////TABLE COLUMNS
        //iterateRegex(regexes.COLUMN_SPECIFICATION, tableScript, function (regexp, inputText, match) {
        //    table.columns.push(new _parser.columnScript(match[0]));

        //    tableScript = tableScript.substring(0, match.index) + tableScript.substring(match.index + match[0].length);
        //});


        table.columns = parseColumnScript(tableScript);

        from(table.primaryKey.colunms).forEach(function (pk) {

            var column = from(table.columns)
            .where(function (c) {
                return (c.name == pk.name);
            }).firstOrDefault();
            
            if (!column) return true;

            column.isPrimary = true;
        });
        for (var c in table.columns) {
            c.table = table;
        }

        tables.push(table);

    });

    return tables;
};
function parseColumnScript(scriptColumns){
    var columns = [];
    var script = scriptColumns.toString();

    script = clearCommentsAndLines(script);
    
    iterateRegex(regexes.TABLE_COLUMN.EXPRESSION, script, function (regexp, inputText, match) {
        var columnSpec = match[0];
        var currentColumn = new Column({
            name: match[regexes.TABLE_COLUMN.CAPTURES_INDEXES.NAME],
            type: match[regexes.TABLE_COLUMN.CAPTURES_INDEXES.DATA_TYPE],
            precision: match[regexes.TABLE_COLUMN.CAPTURES_INDEXES.PRECISION],
            scale: match[regexes.TABLE_COLUMN.CAPTURES_INDEXES.SCALE],
            isPrimary: !!match[regexes.TABLE_COLUMN.CAPTURES_INDEXES.IS_PRIMARY],
            isAutoIncrement: !!match[regexes.TABLE_COLUMN.CAPTURES_INDEXES.IS_IDENTITY],
            increment: {
                seed: match[regexes.TABLE_COLUMN.CAPTURES_INDEXES.IDENTITY_SEED],
                step: match[regexes.TABLE_COLUMN.CAPTURES_INDEXES.IDENTITY_STEP]
            },
            isNullable: !match[regexes.TABLE_COLUMN.CAPTURES_INDEXES.IS_NOT_NULL],

            src: columnSpec
        });
        columns.push(currentColumn);

    });

    return columns;
};
function parseDatabaseScript(scriptData){

}


function iterateRegex(regexp, inputText, callback) {
    var matches = [];
    
    while ((m = regexp.exec(inputText)) !== null) {
        // This is necessary to avoid infinite loops with zero-width matches
        if (m.index === regexp.lastIndex) {
            regexp.lastIndex++;
        }
        
        callback(regexp, inputText, m);
    }    

};
function clearCommentsAndLines(content){
     var contentAux = content;
     while (regexes.COMMENT.test(contentAux)) {
        contentAux = contentAux.replace(regexes.COMMENT, "");
    }

    contentAux = contentAux.replaceAll("\t", " ").replaceAll("\r", " ").replaceAll("\n", " ");
    return contentAux;
}
function clearSysname(argName) {
    var sysname = argName;

    if (sysname.startsWith('[')) sysname = sysname.substring(1);
    if (sysname.endsWith(']')) sysname = sysname.substring(0, sysname.length - 1);

    return sysname;
};

/// <summary>the @param start should be after from opener</summary>
String.prototype.indexOfCloser = function findClosesOf(start, opener, closer) {
    var countOpener = 1;
    for (var i = start; i < this.length; i++) {
        if (this[i] == opener) { countOpener++; continue; }
        if (this[i] == closer) {
            countOpener--;
            if (countOpener == 0) {
                return i;
            }
            continue;
        }

    }
};

Object.deepExtend = function (destination, source) {
    for (var property in source) {
        if (source[property] && source[property].constructor &&
            source[property].constructor === Object) {
            destination[property] = destination[property] || {};
            arguments.callee(destination[property], source[property]);
        } else {
            destination[property] = source[property];
        }
    }
    return destination;
};

String.prototype.replaceAll = function (search, replacement) {
    var ret = this.toString().replace(search, replacement);

    while (ret.indexOf(search) != -1) {
        ret = ret.replace(search, replacement);
    }
    return ret;

};

String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/gm, '');
};
String.isNullOrWhiteSpace = function (value) {
    return value == null || value.toString().trim() == "";
};

var db2_module = {
    parseTable: parseTableScript, 
    parseColumn: parseColumnScript
};

module.exports = db2_module;

