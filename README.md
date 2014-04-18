# Authorize middleware

Authorization middleware for Node.js and the Javascript platform in general

See [wiki](https://github.com/kristianmandrup/authorize-mw/wiki) for a guide on design and architecture.

Most important sections:

* [Permits](https://github.com/kristianmandrup/authorize-mw/wiki/Permits)
* [Rules](https://github.com/kristianmandrup/authorize-mw/wiki/Rules)

## Installation

The index.js file exposes the following:

```
  AuthorizeMw :  requires.mw 'authorize-mw'
  Authorizer :   requires.lib 'authorizer'
  Ability :      requires.lib 'ability'
  Allower :      requires.lib 'allower'
  Permit :       requires.lib 'permit'
  permit-for:    requires.permit 'permit-for'
```

So you can simply do:

```javascript
authorize = require('authorize-mw');
```

Then require the parts you need as demonstrated in the usage examples below.

```javascript
Permit      = authorize.Permit;
permit-for  = authorize.permit-for;
```

## Browser usage

Try [browserify](http://browserify.org)

`browserify index.js -o authorize-mw.js`

## Usage

The following is a complete example, using LiveScript syntax for a clearer picture.

```LiveScript
authorize = require 'authorize-mw'

Middleware  = require 'middleware' .Middleware
AuthorizeMw = authorize.AuthorizeMw
Permit      = authorize.Permit
permit-for  = authorize.permit-for

class Book extends Base
  (obj) ->
    super ...

book = new Book title: title

class GuestUser extends User
  (obj) ->
    super ...

  role: 'guest'

guest-user   = new GuestUser name: 'unknown'

GuestPermit = class GuestPermit extends Permit
  (name, desc) ->
    super ...

  match: (access) ->
    @matches(access).user role: 'guest'

guest-permit = permit-for(GuestPermit, 'guest books',
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

Same in Javascript:

```javascript

var authorize, Middleware, AuthorizeMw, Permit,
    permitFor, Book, book, GuestUser, guestUser,
    GuestPermit, guestPermit, basicAuthorizeMws,
    authMiddleware, readBooksRequest, allowed;

authorize = require('authorize-mw');

Middleware = require('middleware').Middleware;
AuthorizeMw = authorize.AuthorizeMw;
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

GuestPermit = lo.extend(Permit, {
  prototype: {
    match: function(access){
      return this.matches(access).user({role: 'guest'});
    }
  }
});

guestPermit = permitFor(GuestPermit, 'guest books', {
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

## Without middleware

Simple example using a user Ability directly, without the middleware layer...

```LiveScript
authorize = require 'authorize-mw'

Ability     = authorize.Ability

user = (name) ->
  new User name

book = (title) ->
  new Book title

ability = (user) ->
  new Ability user

a-book = book 'some book'
current-user = user 'kris'

if ability(current-user).allowed-for action: 'read', subject: a-book
  # do the read book action
  ...
```

Same in Javascript:

```javascript

var authorize, Ability, user, book, ability, aBook, currentUser;

authorize = require('authorize-mw');
Ability = authorize.Ability;

user = function(name){
  return new User(name);
};

book = function(title){
  return new Book(title);
};

ability = function(user){
  return new Ability(user);
};

aBook = book('some book');

currentUser = user('kris');

if (ability(currentUser).allowedFor({
  action: 'read',
  subject: aBook`
})) {
  // do the action
}
```

## Current status

All tests are passing :)

Note to self: *rule-applier* needs more tests...

To facilitate testing, each class implements `Debugger` which allows using `debug-on!` on the class or instance level to track
 what goes on inside.

Use `xdescribe`, `describe.skip` and `describe.only` to select which tests to execute.

### Caching via fingerprinting

A caching strategy should be implemented, so rules are not evaluated
each time for the same *action request* (action, subject, object, context) `AccReq`, instead a cached previous result for that
AccReq should be retrieved.

If any of these is an object, a `.hash` function should be attempted called on that object to get the "fingerprint"
If no `hash` function on object, fingerprinting is done via JSON stringify.

Then each of these fingerprints should be concatenated into one *access request fingerprint*.
If the same AccReq fingerprint comes in again, the cached permit rules should be used for better performance!

Please feel free to contribute a solution to this major performance enhancement.

## Design

*Why LiveScript?*

Since it is faster/easier to develop the basic functionality. We can always later refactor the code to use something else.

*Why classes and not prototypical inheritance?*

See reasoning for Livescript ;) Just easier to implement using classes. I started off using basic Javascript constructor functions
but since abandoned this approach because it was slowing me down. Just provides a nice encapsulation/abstraction layer.

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
