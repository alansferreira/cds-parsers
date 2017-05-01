// var {from} = require('linq');

// var db2Parser = require('./src/db2-table.parser');
// var fs = require('fs');

// var tables1 = [];
// var tables2 = [];
// var script;

// script = fs.readFileSync('scripts/db2.compare.1.sql');
// var tables1 = db2Parser.parseTable(new String(script));

// script = fs.readFileSync('scripts/db2.compare.2.sql');
// var tables2 = db2Parser.parseTable(new String(script));



// tables1 = from(tables1).orderBy("$.name").toArray();
// from(tables1).forEach(function(t1){
//     var t2 = from(tables2)
//     .where(function(t){
//         return t.name.startsWith(t1.name);
//     })
//     .firstOrDefault();
    
//     if(!t2){
//         console.warn(`Table '${t1.name}' does not audited!`);
//         return true;
//     }
    
//     var t2Columns = from(t2.columns).where("',ID,REV,REVTYPE'.indexOf(','+$.name)==-1").orderBy("$.name").toArray();

//     t1.columns = from(t1.columns).orderBy("$.name").toArray();
//     t1.errors = [];

//     from(t1.columns).forEach(function(c1){
//         var c2 = from(t2Columns).where(function(c2){return c2.name == c1.name;}).firstOrDefault();
//         if(!c2) {
//             t1.errors.push(`'${t2.name}' does not contains '${c1.src}';`);
//             return true;
//         }
//         if(c1.type!=c2.type || c1.precision!=c2.precision || c1.scale!=c2.scale){
//             t1.errors.push(`The column '${c1.name}' has diferent data types:`);
//             t1.errors.push(`\t'${t1.name}' => '${c1.src}'`);
//             t1.errors.push(`\t'${t2.name}' => '${c2.src}'`);
//         }
//     });

//     if(t1.errors.length!=0){
//         var str = `\r\n\r\n Comparasion errors(${t1.errors.length}) between '${t1.name}' x '${t2.name}':`;
//         console.log(str);
//         fs.appendFileSync("./result.txt", str);
//         for (var err = 0; err < t1.errors.length; err++) {
//             var error = t1.errors[err];
//             console.error(error);
//             fs.appendFileSync("./result.txt", '\r\n' + error);
//         }
//     }
//     //out2 += `\r\n${t.name}.${c.name} as ${c.type}(${c.precision}, ${c.scale})`;
// });


// process.exit();