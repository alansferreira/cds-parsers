function initializeCOBOLProgramParser(){
    const regexes = {
        CALL_PROGRAM: {
            REGEX: / CALL[ ]{1,}([a-zA-Z0-9\r\n\-]+)/g,
            FIELD_TYPE: 'CALL_PROGRAM',
            CAP_INDEX: { 
                PROGRAM_NAME: 1
            },
            toJson: (match, startedAtLine, endedAtLine)=>{
                return {
                    startedAtLine, endedAtLine,
                    programName: match[regexes.CALL_PROGRAM.PROGRAM_NAME.CAP_INDEX.PROGRAM_NAME],
                }
            }
        },

    };
    function* getStatemantIterator(content){
        const lines = content.replace(/\r\n/g,'\n').replace(/\n\n/g,'\n').split('\n');
        var statement = '';
        var startedAtLine;
        for (let l = 0; l < lines.length; l++) {
            
            const line = '' + lines[l].padEnd(72, ' ').substr(0, 72).replace(/ +$/g, ''); //rtrim
            if(line.length < 7) continue;
            if(line.substr(6, 1) != ' ') continue;

            if(statement == '') startedAtLine = l + 1;
            statement += line.substring(7);
            if(!line.endsWith('.')) continue;

            yield { 
                statement,
                startedAtLine,
                endedAtLine: l + 1
            };
            statement = '';
        }
    }
    
    /**
     * Return multiple statements match because IF statements can be long 
     * @param {string} statement 
     * @returns {any} return an yield for multiples match statements
     */
    function* matchStatement(statement){
        const regs = [regexes.CALL_PROGRAM];
        for (let m = 0; m < regs.length; m++) {
            const regex = regs[m].REGEX;
            if( regex.test(statement) ) yield regs[m];
        }
    }

    function* parseStatemant(statement){
        var matcherIterator = matcherIterator(statement);
        var iteratee = {done: false};

        while( iteratee.done == false ){
            var iteratee = matcherIterator.next();
            if(iteratee.value === undefined) continue;
            
            var rex = iteratee.value;
            var  m;
            if((m = rex.REGEX.exec(statement)) == null) return ;

            yield rex.toJson(m);

        }
    }

    function parseProgram(){
        var sttIterator = getStatemantIterator(content);
        var iteratee = {done: false};
        var statements = [];

        var book = [];
        var lastField;
        var currentParent;
        var rootFields = [];

        while( iteratee.done == false ){
            iteratee = sttIterator.next();
            if(iteratee.value === undefined) continue;
            
            var {statement, startedAtLine} = iteratee.value;
            
            var newStatement = parseStatemant(statement);
            
            statements.push(newStatement);

        }
    }
    
    var cobol_program = {
        parseProgram, 
        getStatemantIterator
    };
    
   return cobol_program;
};

if(typeof module !== "undefined") {
    module.exports = initializeCOBOLProgramParser();
}
