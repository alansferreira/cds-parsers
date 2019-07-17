import "reflect-metadata";
import { expect } from 'chai';
import { describe } from 'mocha';
import { DB2ColumnResolver } from "./column-resolver";
import { Inject } from 'typedi';
import Container from 'typedi';
import { IColumn } from '../db2.model';
describe('Test DB2 parser service', () => {
    it('should deserialize statement', async () => {
        const columnResolver: DB2ColumnResolver = Container.get(DB2ColumnResolver);

        try {
            const result: IColumn[] | IColumn = columnResolver.resolve('cod_cli int');

            expect(result).to.not.null;
            expect((<IColumn[]>result).length).to.eq(1);

        } catch (error) {
            throw new Error(error);
        }
    });
});