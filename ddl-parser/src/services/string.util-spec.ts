import 'reflect-metadata';
import { expect } from 'chai';
import { describe } from 'mocha';
import { allMatches } from "./string.util";
describe('Test String utils', () => {
    it('should found all expressions matches', async () => {
        try {

            const input = 'word1, word2';
            const expr = /(\w+)(\d+)/gi;
            const result = allMatches(expr, input);

            expect(result.length).to.equal(2, "local");
        } catch (error) {
            throw new Error(error);
        }
    });
});