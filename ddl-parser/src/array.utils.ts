export enum SortDirectionEnum{
    Ascending = 'asc',
    Desscending = 'desc'
}

export interface ISortEvaluatorKey<T> {
    (obj: T): any;
}

export class PojoArrayUtil {
    static sortByProperty(arr: any[], sortBy: string, direction: SortDirectionEnum){
        return arr.sort((a, b) => {
            if (a[sortBy] > b[sortBy]) return direction=="desc" ? -1: 1;
            if (a[sortBy] < b[sortBy]) return direction=="desc" ? 1: -1;
            return 0;
        });
    }
    static sortByEvaluator<T>(arr: any[], sortByKeyEval: ISortEvaluatorKey<T>, direction: SortDirectionEnum){
        return arr.sort((a, b) => {
            const val1 = sortByKeyEval(a);
            const val2 = sortByKeyEval(b);
            if (val1 > val2) return direction=="desc" ? -1: 1;
            if (val1 < val2) return direction=="desc" ? 1: -1;
            return 0;
        });
    }
}

