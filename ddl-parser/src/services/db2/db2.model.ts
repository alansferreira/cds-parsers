export interface IAutoIncrement {
    seed: number;
    step?: number;
}

export interface INamedObject {
    name: string;
}

export interface IColumn extends INamedObject{
    isPrimary: boolean;
    table: null; //new Table();
    type: string;
    precision: number;
    scale: number;
    isNullable: true;
    isAutoIncrement: boolean;
    increment: IAutoIncrement;
};

export interface IDatabase {
    tables: Array<ITable>;
}

export interface ITable extends INamedObject{
    schema: string;
    database: IDatabase;
    columns: Array<IColumn>;
    indexes: Array<IIndexConstraint>;
    foreignKeys: Array<IForeignKey>;
};


export interface IPrimaryKey extends INamedObject{
    columns: Array<IColumnIndexSpec>;
};

export interface IColumnReferenceSpec extends INamedObject{
    targetName: string
}

export interface IIndexConstraint extends INamedObject {
    type: string;
    columnsSpec: Array<IColumnIndexSpec>;
}

export interface IForeignKey extends INamedObject{
    columns: Array<IColumnReferenceSpec>;
    targetSchema: string;
    targetTable: string;
    targetColumns: Array<IColumn>;
    deleteActionType: string;
    updateActionType: string;
};

export enum SORT_TYPE{  
    ASC = 'ASC', 
    DESC = 'DESC' 
};

export interface IColumnIndexSpec extends INamedObject {
    sort: SORT_TYPE;
};