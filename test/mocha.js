var mocha = require('mocha');
mocha.addFile('./db2.full-script.sql');
mocha.addFile('./read-script.test.js');
mocha.run();