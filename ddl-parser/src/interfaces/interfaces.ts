export interface IMap<T> {
    [index: string]: T;
    [index: number]: T;
}

export interface IRegexResolver<T> {
    name?: string;
    regex: RegExp;
    resolver(input: string): T | Array<T>;
}

export interface IParser<T> {
        
    isMatch(input: string): IRegexResolver<T>;

    deserialize(input: string ): Array<T>;
    serialize(input: Array<T>): string;
}

export abstract class ParserBase<T> implements IParser<T> {
    
    constructor(
        public matchExpressions: Array<IRegexResolver<T>>
    ){
            
    }

    isMatch(input: string): IRegexResolver<T> {
        
        for (let r = 0; r < this.matchExpressions.length; r++) {
            const resolver = this.matchExpressions[r];
            resolver.regex.lastIndex = -1;
            if(resolver.regex.test(input)){
                return resolver;
            }
        }
        return null;
    }

    abstract deserialize(input: string): T[];
    abstract serialize(input: T[]): string;
    

}