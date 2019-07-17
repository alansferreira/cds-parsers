export interface IMap<T> {
    [index: string]: T;
    [index: number]: T;
}

export interface IRegexResolver<T> {
    uniqueId: string;
    regex: RegExp;
    resolve(input: string): T | Array<T>;
}

export abstract class RegexResolverBase<T> implements IRegexResolver<T> {
    uniqueId: string;
    regex: RegExp;
    
    abstract resolve(input: string): T | Array<T>;
    
    constructor(uniqueId: string) {
        this.uniqueId = uniqueId;
    }

}


// export interface IParser<T> {
//     uniqueId: string;
        
//     isMatch(input: string): IRegexResolver;

//     deserialize(input: string ): Array<T>;
//     serialize(input: Array<T>): string;
// }

// export abstract class ParserBase<T> implements IParser<T> {
//     uniqueId: string;
    
//     constructor(
//         public matchExpressions: Array<IRegexResolver<T>>
//     ){
            
//     }

//     isMatch(input: string): IRegexResolver<T> {
        
//         for (let r = 0; r < this.matchExpressions.length; r++) {
//             const resolver = this.matchExpressions[r];
//             resolver.regex.lastIndex = -1;
//             if(resolver.regex.test(input)){
//                 return resolver;
//             }
//         }
//         return null;
//     }

//     abstract deserialize(input: string): T[];
//     abstract serialize(input: T[]): string;
// }




