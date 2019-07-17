import { allMatches } from '../../string.util';
import { RegisterResolver } from '../../../regex-resolver.service';
import { IColumn } from '../db2.model';
import { IRegexResolver } from '../../../interfaces';
import { Service } from 'typedi';

@Service()
export class DB2ColumnResolver implements IRegexResolver<IColumn> {
    uniqueId = 'DB2ColumnResolver';
    regex = /((\"([^\"]+)\")|\w+)([ ]+((\"([^\"]+)\")|\w+)([ ]{0,}\([ ]{0,}(([0-9]+)([ ]{0,},[ ]{0,}([0-9]+))?)[ ]{0,}\))?)([^,]+)?/ig;
    resolve(input: string): Array<IColumn> | IColumn {
        const matches = allMatches(this.regex, input);
        const result: IColumn[] = [];

        for (let r = 0; r < matches.length; r++) {
            const match = matches[r];
            result.push(<IColumn>{
                name: (match[3] || match[1]),
                type: match[5] || 'int',
                precision: Number.parseInt(match[10] || '0'),
                scale: Number.parseInt(match[12] || '0')
            });  
        }
        return result;
    }
};