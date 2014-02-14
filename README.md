# Authorize middleware

Authorization middleware for Node.js and the Javascript platform in general

See [wiki](https://github.com/kristianmandrup/authorize-mw/wiki) for more on design and architecture.


## Testing

Run `mocha` on all files in test folder

Just run all test like this:

`$ mocha`

To execute individual test, do like this:

`$ mocha test/authorize-mw/permit_test.js`

### Test coverage

The library [istanbul](http://ariya.ofilabs.com/2012/12/javascript-code-coverage-with-istanbul.html) is used for code coverage.

See [code-coverage-with-mocha](http://stackoverflow.com/questions/16633246/code-coverage-with-mocha) for use with mocha.

```
npm install -g istanbul
istanbul cover _mocha -- -R spec
open coverage/lcov-report/index.html
```

`$ instanbul cover _mocha`

 To measure coverage of individual test:

 `$ instanbul cover _mocha test/authorize-mw/permit_test.js`

## Contribution

Please help improve this project, suggest improvements, add better tests etc. ;)

## Status

Undergoing some refactoring...

## Licence

MIT License
Copyright 2014-2015 Kristian Mandrup
