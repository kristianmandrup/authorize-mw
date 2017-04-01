# Authorize middleware

[![Greenkeeper badge](https://badges.greenkeeper.io/kristianmandrup/authorize-mw.svg)](https://greenkeeper.io/)

Authorization middleware for Node.js and the Javascript platform in general

It leverages the authorization library [permit-authorize](https://github.com/kristianmandrup/permit-authorize)

See [wiki](https://github.com/kristianmandrup/authorize-mw/wiki) for an overview.

Most important sections:

* [Permits](https://github.com/kristianmandrup/authorize-mw/wiki/Permits)
* [Rules](https://github.com/kristianmandrup/authorize-mw/wiki/Rules)

## Installation

`AuthorizeMw = require 'authorize-mw'`


## Usage

The following is a complete example, using LiveScript syntax for a "clearer" picture.

```LiveScript
authorize = require 'authorize-mw'

Middleware  = require 'middleware' .Middleware
AuthorizeMw = authorize.AuthorizeMw

Permit      = authorize.Permit
permit-for  = authorize.permit-for

Book = require './models/book'
book = new Book title: title

GuestUser = require './models/users/guest'
guest-user   = new GuestUser name: 'unknown'

guest-permit = permit-for(GuestPermit, 'guest books',
  match: (access) ->
    @matches(access).user role: 'guest'

  rules:
    ctx:
      area:
        guest: ->
          @ucan 'publish', 'Paper'
        admin: ->
          @ucannot 'publish', 'Paper'

    read: ->
      @ucan 'read' 'Book'
    write: ->
      @ucan 'write' 'Book'
    default: ->
      @ucan 'read' 'any'
)

basic-authorize-mws = new AuthorizeMw current-user: guest-user

auth-middleware = new Middleware 'model' data: books.hello
auth-middleware.use authorize: basic-authorize-mws

read-books-request =
  action      :   'read'
  collection  :   'books'

allowed = auth-middleware.run read-books-request
```

Please note that the above middleware setup can be expanded with validator,
decorator and marshaller middleware for a complete stack.
This is especially useful when combined and used with a Real Time sync server.

Same example as above in pure Javascript:

```javascript

var authorize, Middleware, AuthorizeMw, Permit,
    permitFor, Book, book, GuestUser, guestUser,
    guestPermit, basicAuthorizeMws,
    authMiddleware, readBooksRequest, allowed;

AuthorizeMw = require('authorize-mw');
authorize   = require('permit-authorize');

Middleware = require('middleware').Middleware;
Permit = authorize.Permit;

permitFor = authorize.permitFor;

Book = require 'models/book'
book = new Book({
  title: title
});

GuestUser = require 'models/users/guest'
guestUser = new GuestUser({
  name: 'unknown'
});

guestPermit = permitFor('guest', {
  match: function(access){
    return this.matches(access).user({role: 'guest'});
  },
  rules: {
    ctx: {
      area: {
        guest: function(){
          return this.ucan('publish', 'Paper');
        },
        admin: function(){
          return this.ucannot('publish', 'Paper');
        }
      }
    },
    read: function(){
      return this.ucan('read', 'Book');
    },
    write: function(){
      return this.ucan('write', 'Book');
    },
    'default': function(){
      return this.ucan('read', 'any');
    }
  }
});

basicAuthorizeMws = new AuthorizeMw({
  currentUser: guestUser
});

authMiddleware = new Middleware('model', {
  data: books.hello
});

authMiddleware.use({
  authorize: basicAuthorizeMws
});

readBooksRequest = {
  action: 'read',
  collection: 'books'
};

allowed = authMiddleware.run(readBooksRequest);
```

You can also run with the user as part of the run context

```LiveScript
publish-book-request =
  user     :   guest-user
  action   :   'publish'
  data     :   book

allowed = auth-middleware.run publish-book-request
```

or you can use `model` instead of collection

```LiveScript
publish-book-request =
  user     :   guest-user
  action   :   'publish'
  model    :   `book`
```

## Current status

All tests are passing :)

## Design

*Why LiveScript?*

Since it is faster/easier to develop the basic functionality. We can always later refactor the code to use something else.

*Why classes and not prototypical inheritance?*

In one word "Productivity!", a class is a convenient abstraction for encapsulation.

Feel free to fork this project and provide a version without classes if that is a MUST for you...

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

## Licence

MIT License
Copyright 2014-2015 Kristian Mandrup
