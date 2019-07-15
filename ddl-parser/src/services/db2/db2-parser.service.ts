import { Service, Inject } from 'typedi';
import { ParserBase, IRegexResolver } from '../../interfaces/interfaces';
import { ITable } from '.';
import { DB2ColumnResolver } from './db2-parser.resolvers';



@Service()
export class DB2ParserTable extends ParserBase<ITable> {
    @Inject(type => DB2ColumnResolver) columnResolver: DB2ColumnResolver;
    // @Inject(type => DB2TableResolver) tableResolver: DB2TableResolver;
    // @Inject(type => DB2ColumnResolver) routerNavigator: DB2ColumnResolver;
    // @Inject(type => DB2ContraintResolver) routerNavigator: DB2ColumnResolver;
    // @Inject(type => DB2ColumnResolver) routerNavigator: DB2ColumnResolver;

    deserialize(input: string): ITable[] {
        throw new Error('Method not implemented.');
    }    
    
    serialize(input: ITable[]): string {
        throw new Error('Method not implemented.');
    }

    constructor(){
        super([
            // {
            //     name: 'CREATE_TABLE_DEFAULT',
            //     regex: /./g,
            //     resolver: null
            // }
        ]);
    }
}
