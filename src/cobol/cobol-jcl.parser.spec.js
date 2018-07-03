const assert = require('mocha');
var jclParser = require('./cobol-jcl.parser');
var fs = require('fs');

describe('Read and parse program definitions', function(){
    it('should parse job program statement iterator model', function(){
        var script = new String(fs.readFileSync('./src/cobol/JOBSPL01L.JCL'));
        
        var sttIterator = jclParser.getStatemantIterator(script);
        var iteratee = {done: false};
        var countStatements = 0;
        var countStatementsWithDot = 0;
        fs.writeFileSync('./readed-statements.JOBSPL01L.JCL.txt', '');
        while( iteratee.done==false ){
            iteratee = sttIterator.next();
            if(iteratee.value === undefined) continue;
            
            var {statement, startedAtLine, endedAtLine} = iteratee.value;
            countStatements++;
            countStatementsWithDot += (statement.endsWith('.') ? 1: 0);
            fs.appendFileSync('./readed-statements.JOBSPL01L.JCL.txt', `[${startedAtLine}, ${endedAtLine}]: ${statement}\n`);
        }
        console.log(`Statements: ${countStatements}, with dot: ${countStatementsWithDot}`);
        assert(countStatements === countStatementsWithDot, 'error');
    });
    
    // it('should parse cobol program', function(){
    //     var script = new String(fs.readFileSync('./src/cobol/JOBSPL01L.JCL'));
        
    //     var program = programParser.parseProgram(script);
        
    //     console.log(program);
    //     fs.writeFileSync('./parsed-program.JOBSPL01L.JCL.json', JSON.stringify(program, null, 2));
        
        
    //     assert(program.length==83, 'error');
    // });


    // it('should parse cobol program statement iterator model: with exceding chars before position 6 and after position 72 ', function(){
    //     var script = new String(fs.readFileSync('./src/cobol/CCP0002.CBL'));
        
    //     var sttIterator = programParser.getStatemantIterator(script);
    //     var iteratee = {done: false};
    //     var countStatements = 0;
    //     var countStatementsWithDot = 0;
    //     fs.writeFileSync('./readed-statements.CCP0002.CBL.txt', '');
    //     while( iteratee.done==false ){
    //         iteratee = sttIterator.next();
    //         if(iteratee.value === undefined) continue;
            
    //         var {statement, startedAtLine, endedAtLine} = iteratee.value;
    //         countStatements++;
    //         countStatementsWithDot += (statement.endsWith('.') ? 1: 0);
    //         fs.appendFileSync('./readed-statements.CCP0002.CBL.txt', `[${startedAtLine}, ${endedAtLine}]: ${statement}\n`);
    //     }
    //     console.log(`Statements: ${countStatements}, with dot: ${countStatementsWithDot}`);
    //     assert(countStatements === countStatementsWithDot, 'error');
    // });

    // it('should parse cobol program: with exceding chars before position 6 and after position 72 ', function(){
    //     var script = new String(fs.readFileSync('./src/cobol/CCP0002.CBL'));
        
    //     var program = programParser.parseProgram(script);
        
    //     console.log(program);
    //     fs.writeFileSync('./parsed-program.CCP0002.CBL.json', JSON.stringify(program, null, 2));
        
        
    //     assert(program.length==83, 'error');
    // });

    // it('should parse cobol program: filtering only sql queries ', function(){
    //     var script = new String(fs.readFileSync('./src/cobol/CCP0002.CBL'));
        
    //     var program = programParser.parseProgram(script, {filters: [programParser.parseFilters.EXEC_SQL]});
        
    //     console.log(program);
    //     fs.writeFileSync('./parsed-program.CCP0002.CBL.json', JSON.stringify(program, null, 2));
        
        
    //     assert(program.length==83, 'error');
    // });


});

