import 'reflect-metadata';
import { IRegexResolver, IMap } from './interfaces';
import { Container, Service } from 'typedi';

@Service()
export class ResolverRegistry {
    resolverMap: IMap<IRegexResolver<any>> = {};
    resolverArr: Array<IRegexResolver<any>> = [];

    constructor(){

    }

    registerResolver(resolver: IRegexResolver<any>){
        if (!this.resolverMap[resolver.uniqueId]) {
            this.resolverMap[resolver.uniqueId] = resolver;
            this.resolverArr.push(resolver);
            return;
        }

        console.warn(`The resolver '${resolver.uniqueId}' aleady has registred and will be replaced!`);
        
        this.resolverArr.splice(this.resolverArr.indexOf(this.resolverMap[resolver.uniqueId]), 1, resolver);
        this.resolverMap[resolver.uniqueId] = resolver;
    }
    get resolvers(): Array<IRegexResolver<any>>{
        return this.resolverArr;
    }

    getResolver(uniqueId: string): IRegexResolver<any>{
        return this.resolverMap[uniqueId];
    }
}

export function RegisterResolver<T>(resolver: IRegexResolver<any>, registry?: ResolverRegistry){    
    const _registry = (registry || Container.get(ResolverRegistry));
    _registry.registerResolver(resolver);
}

