import { Service } from 'typedi';
import { IRegexResolver } from '../../interfaces/interfaces';
import { IColumn } from './db2.model';
import { allMatches } from '../string.util';


@Service()
export class DB2ColumnResolver implements IRegexResolver<IColumn> {
    name = 'DB2TableCreateDefault';
    regex = /((\"([^\"]+)\")|\w+)([ ]+((\"([^\"]+)\")|\w+)([ ]{0,}\([ ]{0,}(([0-9]+)([ ]{0,},[ ]{0,}([0-9]+))?)[ ]{0,}\))?)([^,]+)?/ig;
    
    resolver(input: string): IColumn | IColumn[] {
        const matches = allMatches(this.regex, input);
        const result = [];

        for (let r = 0; r < matches.length; r++) {
            const match = matches[r];
            result.push({
                name: match[3] || match[1],
                type: match[5],
                precision: match[10],
                scale: match[12],
            });  
        }
        return result;
    }
}
