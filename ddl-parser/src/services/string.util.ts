
export function allMatches(regexp: RegExp, inputText: string): Array<RegExpExecArray> {
    var matches = [];
    let m: RegExpExecArray;

    regexp.lastIndex = -1;

    const result = [];
    while ((m = regexp.exec(inputText)) !== null) {
        // This is necessary to avoid infinite loops with zero-width matches
        if (m.index === regexp.lastIndex) {
            regexp.lastIndex++;
        }
        result.push(Object.assign({}, m));
    }    
    
    return result;
};
