var assert = require('mocha');
var programParser = require('./cobol-program.parser');
var fs = require('fs');

describe('Read and parse program definitions', function(){
    it('should parse cobol program statement iterator model', function(){
        var script = new String(fs.readFileSync('./src/cobol/CCP0001.CBL'));
        
        var sttIterator = programParser.getStatemantIterator(script);
        var iteratee = {done: false};
        var countStatements = 0;
        var countStatementsWithDot = 0;
        fs.writeFileSync('./readed-statements.CCP0001.CBL.txt', '');
        while( iteratee.done==false ){
            iteratee = sttIterator.next();
            if(iteratee.value === undefined) continue;
            
            var {statement, startedAtLine, endedAtLine} = iteratee.value;
            countStatements++;
            countStatementsWithDot += (statement.endsWith('.') ? 1: 0);
            fs.appendFileSync('./readed-statements.CCP0001.CBL.txt', `[${startedAtLine}, ${endedAtLine}]: ${statement}\n`);
        }
        console.log(`Statements: ${countStatements}, with dot: ${countStatementsWithDot}`);
        assert(countStatements === countStatementsWithDot, 'error');
    });
    
    // it('should parse cobol program', function(){
    //     var script = new String(fs.readFileSync('./src/cobol/CCP0001.CBL'));
        
    //     var book = cpyParser.loadBook(script);
        
    //     console.log(book);
    //     fs.writeFileSync('./parsed-book.CCP0001.CPY.json', JSON.stringify(book, null, 2));
        
        
    //     assert(book.length==83, 'error');
    // });



    // it('should parse cobol program PICX', function(){
    //     var script = "       77  WRK-LOCAL                   PIC  X(004)         VALUE SPACES.";
        
    //     var book = cdsParser.COBOL.program.loadBook(script);
        
    //     console.log(book);
    //     fs.writeFileSync('./parsed-book.CCP0000.CPY.json', JSON.stringify(book, null, 2));
        
        
    //     assert(book.length==49, 'error');
    // });

    // it('should parse cobol program', function(){
    //     var script = new String(fs.readFileSync('./src/cobol/CCP0001.CPY'));
        
    //     var book = cdsParser.COBOL.program.loadBook(script);
        
    //     console.log(book);
    //     fs.writeFileSync('./parsed-book.CCP0001.CPY.json', JSON.stringify(book, null, 2));
        
        
    //     assert(book.length==49, 'error');
    // });

    // it('should parse cobol program redefines', function(){
    //     var script = new String(fs.readFileSync('./src/cobol/CCP0000.CPY'));
        
    //     var book = cdsParser.COBOL.program.loadBook(script);
        
    //     console.log(book);
    //     fs.writeFileSync('./parsed-book.CCP0000.CPY.json', JSON.stringify(book, null, 2));
        
        
    //     assert(book.length==49, 'error');
    // });

});

