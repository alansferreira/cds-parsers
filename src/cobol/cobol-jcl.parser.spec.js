const assert = require('mocha');
var jclParser = require('./cobol-jcl.parser');
var fs = require('fs');

describe('Read and parse program definitions', function(){
    it('should parse job program statement iterator model', function(){
        var script = new String(fs.readFileSync('./src/cobol/JOBSPL01L.JCL'));
        
        var sttIterator = jclParser.getStatementIterator(script);
        var iteratee = {done: false};
        var countStatements = 0;

        fs.writeFileSync('./readed-statements.JOBSPL01L.JCL.txt', '');
        while( iteratee.done==false ){
            iteratee = sttIterator.next();
            if(iteratee.value === undefined) continue;
            
            var {statement, startedAtLine, endedAtLine} = iteratee.value;
            countStatements++;
            fs.appendFileSync('./readed-statements.JOBSPL01L.JCL.txt', `[${startedAtLine}, ${endedAtLine}]: ${statement}\n`);
        }
        console.log(`Statements: ${countStatements}`);
        assert(countStatements === 9, 'error');
    });
    
    it('should parse jcl program', function(){
        var script = new String(fs.readFileSync('./src/cobol/JOBSPL01L.JCL'));
        
        var job = jclParser.parseJob(script);
        
        console.log(job);
        fs.writeFileSync('./parsed-program.JOBSPL01L.JCL.json', JSON.stringify(job, null, 2));
        
        assert(job.length==83, 'error');
    });


});

