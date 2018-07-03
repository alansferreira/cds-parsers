function initializeCOBOLProgramParser(){
    /**
     * @typedef RegexSpec
     * @prop {RegExp} REGEX
     * @prop {string} STMT_TYPE
     * @prop {} CAP_INDEX
     * @prop {(match: RegExpExecArray, startedAtLine: Number, endedAtLine: Numbwe)} toJson
     */

     /**
      * @typedef ParsedStatement
      * @prop {string} STMT_TYPE
      * @prop {number} startedAtLine
      * @prop {number} endedAtLine
      * @prop {boolean} isDivision
      * @prop {boolean} isKeywordSection
      * @prop {boolean} isCustomSection
      */


    const regexMap = {        
        DIVISION: {
            REGEX: / {0,}([a-zA-Z0-9-#]+) +DIVISION {0,}\./g,
            STMT_TYPE: 'DIVISION',
            CAP_INDEX: {
                NAME: 1
            },
            toJson: (match, startedAtLine, endedAtLine) => { 
                return { 
                    STMT_TYPE: regexMap.DIVISION.STMT_TYPE, 
                    name: match[regexMap.DIVISION.CAP_INDEX.NAME], 
                    startedAtLine, 
                    endedAtLine, 
                    isDivision: true 
                }; 
            }
        }
    };

    var regexSpecs = [];
    for (const key in regexMap) {
        if (regexMap.hasOwnProperty(key)) {
            const regexSpec = regexMap[key];
            regexSpecs.push(regexSpec);
        }
    }



    function* getStatemantIterator(content){
        const lines = content.replace(/\r\n/g,'\n').replace(/\n\n/g,'\n').split('\n');
        var statement = '';
        var startedAtLine;

        function getUtilLine(line){
            return line.padEnd(72, ' ').substr(0, 72).replace(/ +$/g, ''); //rtrim
        }

        for (let l = 0; l < lines.length; l++) {
            
            const line = '' + getUtilLine(lines[l]);
            if(line.length < 7) continue;
            if(line.substr(2, 1) === '*') continue;

            if(statement == '') startedAtLine = l + 1;
            statement += line.substring(2).replace(/^ +/g, '');

            if(l + 2 < lines.length && getUtilLine(lines[l+1]).startsWith('//         ')) continue;

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
     * @param {string} stmt 
     * @returns {ParsedStatement[]} return an yield for multiples match statements
     */
    function parseStatemant(stmt, startedAtLine, endedAtLine, matchFilters){
        const parsedStatements = [];
        

        for (let m = 0; m < matchFilters.length; m++) {
            const regexSpec = matchFilters[m];
            const regex = regexSpec.REGEX;
            if( !regex.test(stmt) ) continue;
            
            parsedStatements.push(...fetchAllMarches(regexSpec, stmt, startedAtLine, endedAtLine));
        
        }
        
        return parsedStatements;
    }
    /**
     * 
     * @param {RegexSpec} regexSpec 
     * @param {string} statement 
     */
    function fetchAllMarches(regexSpec, stmt, startedAtLine, endedAtLine){
        var regex = regexSpec.REGEX;
        var parsedStatements = [];
        regex.test(stmt);
        var m;
        while ((m = regex.exec(stmt)) !== null) {
            // This is necessary to avoid infinite loops with zero-width matches
            if (m.index === regex.lastIndex) regex.lastIndex++;
            
            parsedStatements.push(regexSpec.toJson(m, startedAtLine, endedAtLine));
        }
        return parsedStatements;
    }

    /**
     * @typedef ParseOptions
     * @prop {RegexSpec[]} filters filters to extract information, default is all
     * 
     */
    
    /**
     * 
     * @param {string} content full program cobol 
     * @param {ParseOptions} options 
     */
    function parseProgram(content, options){
        var sttIterator = getStatemantIterator(content);
        var iteratee = {done: false};
        var statements = [];

        var program = {
            divisions: [],
            statements: []
        };
        var currentDivision;
        var currentSection;

        const opt = (options || {filters: regexSpecs});


        while( iteratee.done == false ){
            iteratee = sttIterator.next();
            if(iteratee.value === undefined) continue;
            
            var {statement, startedAtLine, endedAtLine} = iteratee.value;
            
            var parsedStatements = parseStatemant(statement, startedAtLine, endedAtLine, opt.filters);
            if(!parsedStatements || parsedStatements.length == 0) continue;
            

            if(parsedStatements[0].STMT_TYPE==regexMap.DIVISION.STMT_TYPE){
                currentDivision = Object.assign({ sections: [], statements: []}, parsedStatements[0]);
                program.divisions.push(currentDivision);
                continue;
            }
            if(parsedStatements[0].STMT_TYPE==regexMap.SECTION.STMT_TYPE){
                currentSection = Object.assign({ statements: [] }, parsedStatements[0]);
                currentDivision.sections.push(currentSection);
                continue;
            }

            (currentSection || currentDivision || program).statements.push( ...parsedStatements );
            
        }
        
        return program;
    }
    
    var cobol_program = {
        parseProgram, 
        parseFilters: regexMap,
        getStatemantIterator,
    };
    
   return cobol_program;
};

if(typeof module !== "undefined") {
    module.exports = initializeCOBOLProgramParser();
}
