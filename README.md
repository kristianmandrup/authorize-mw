# authorize-mw

Authorization middleware for Node.js and Javascript platform in general (with a little twist)

## Requirements

* Node.js installed on your computer (http://www.node.org)
* *LiveScript* (http://livescript.net/)

## Install

Install livescript for node globally, then install all the node dependencies (see `packages.json`)

```
$ npm install LiveScript -g
$ npm install
```

Compile LiveScript files!

This can be done either manually or from within an editor (such as WebStorm or Sublime Text) using a LiveScript editor plugin.

## Architecture

A `Permit` is the main conceptual class. It contains the logic to test if it makes sense to apply the permit in a given
access context. Calling `permit.matches(access)` returns true if the permit matches the `access` object.

The `access` object always contains the `user trying to ask permission.
It can also contain items to identify the current context.

`access = {user: user, ctx: context}`

## AccessRequest

This class holds the access request object.

`{user: user, action: 'read', subject: book, ctx: context}`

```LiveScript
class AccessRequest
  # factory method
  @from  = (obj) ->
    new AccessRequest(obj.user, obj.action, obj.subject, obj.ctx)

  # constructor
  (@user, @action, @subject, @ctx) ->

  # normalize action and subject if they are not each a String
  normalize: ->  
```

## Permit

The Permit class holds a list of all the registered permits in `Permit.permits`. You can get a named permit using `Permit.get(name)`. The `matches` method is used to see if the permit should be used for a given access-request.

```LiveScript
class Permit
  # class methods/variables
  @permits = []

  # get a named permit
  @get = (name) ->

  # constructor
  (@name = 'unknown', @description = '') ->
  
  matches: (access-request) ->
    @matcher(access-request).match!  
```

## Access rule

Example access rule

```LiveScript
@ucan 'edit', 'book', (obj) ->
  obj.author == @user.id
```

This `ucan` call is always executed in the context of the `RuleApplier` which contains the `ucan` and `ucannot` methods,
which both register the rule in the rule repository (see `RuleRepo`).

## Ability access

Example user access request (attempt)

```LiveScript
can 'edit', book
```

This `can` call will create/return an Ability for the current user and then create an `access-request` (`AccessRequest` instance).
This will then be sent to an `Allower` who will determine if the user has the permission (is allowed) to do the particular action
 on that particular object (optionally: given the current context).

## PermitFilter

The `PermitFilter` is used to filter a set of permits for a given access request. The filter will return only those permits that match for the access object.
Typically the permit filter will be applied on all the registered permits in `Permit.permits`).

## Permit Allower

The Permit Allower has the responsibility to determine if the permit allows a given action on a subject (an access request).

```LiveScript
class PermitAllower
  (@permit, @access-request) ->

  # ...

  allows: 
    return false if @disallows @access-request
    @can-rules.include @access-request

  disallows: (rule) ->
    @cannot-rules.include @access-request
```

Each permit that matches for the given access context is then resolved to see if the user really can (is allowed)
to perform the particular action on the subject (optionally also given the context-rule).

```LiveScript
class Permit
  permit-allower (access-request) ->
    new PermitAllower(@, access-request)

  # ...
  allows: (access-request) ->
    permit-allower(access-request).allows!

  disallows: (rule) ->
    permit-allower(access-request).disallows!
```

## Rule Repository

Each permit also has a Rule Repository `rule-repo`, an instance of RuleRepo class.
The rule-repo stores all the access rules that the permit allows or disallows for.

```LiveScript
class RuleRepo
  can-rules: {}
  cannot-rules: {}

  match-rule: (act, access-request) ->
    # matching logic
  register-rule: (act, actions, subjects)
    # add rule to can-rules or cannot-rules
```

## Rule Applier

Used to apply a set of rules and add them to the rule repository.
A permit would have a set of rules defined on itself (the rules key) and use the rule applier to add all or
some of these rules to the rule repo.
This can be done either dynamically, just before testing or allow/disallow an access-request, or it can be
done statically, as the permit is initially created or even using a combination of these approaches.

```LiveScript
class RuleApplier
  (@repo, @rules) ->
  
  apply-rules-for: (name, access-request) ->
  
  apply-all-rules: ->

  # ...
```

## Permit Matcher

The Permit Matcher is used to test if a permit matches for a given access request and should be used to grant
permission or not for that request.

```LiveScript
class PermitMatcher
  (@permit) ->
    @intersect = Intersect()

  match: (access) ->
```

## Rule Repository

Each permit also has a Rule Repository `rule-repo`, an instance of RuleRepo class. The rule-repo stores all the access rules that the permit allows or disallows for.

## Using permit-for

A Permit class can be created via the `permit-for` factory method.

Example:

```LiveScript
sexy-permit = permit-for 'a sexy woman',
  # return true if this permit does not apply (should be excluded!) this access obj
  ex-match: (access) ->
    user = access.user
    user.gender is 'female' and user.looks is 'sexy'

  rules:
    manage: ->
      @ucan 'manipulate', ['person'], (obj) ->
        obj.gender is 'male'
```

## Building Permits

`permit-for` should optionally take a `Permit` class argument, such as `AdminPermit` to further greater reuse.
i.e so that you specify the base class to be used for the instance constructed and not always just use the `Permit` class.
It should test if the first argument is a string or not. If not a string, use this as the permit class,
then proceed normally with remaining arguments.

Example:

`admin-bar-permit = permit-for AdminPermit, 'a man walking into the bar', custom-permit`

The `custom-permit` can be either an Object or a Function.

## Permit Matching

To facilitate creating generic matchers, a set of `MatchMaker` classes have been defined for each of the keys in the
access request. These are `UserMatcher`, `ActionMatcher`, `SubjectMatcher`, `ContextMatcher`.
The can be used either directly by instantiation or via the `matching(access)` convenience methods of `Permit`,
which employs the `AccessMatcher` that in turn contains convenience methods for
using all the specific access matchers just mentioned!

The `Permit.matching(access)` method returns an `AccessMatcher` instance with convenience methods:
  * user
  * role
  * action
  * subject
  * subject-clazz
  * context

Access `user` method:

```LiveScript
sexy-permit = permit-for 'a sexy woman',
  match: (access) ->
    @matching(access).user type: 'sexy' # matches if access intersects with {user: {type: 'sexy'}}
```

Access `action` method:

```LiveScript
read-permit = permit-for 'a sexy woman',
  match: (access) ->
    @matching(access).action 'read' # matches if access intersects with {action: 'read'}
```

Access  `subject` method:

```LiveScript
read-permit = permit-for 'a sexy woman',
  match: (access) ->
    @matching(access).subject 'Book' # matches if access intersects with {subject: 'Book'}
```

Access  `context` method:

```LiveScript
read-permit = permit-for 'a sexy woman',
  match: (access) ->
    @matching(access).context area: 'members' # matches if access intersects with {area: 'members'}
```

Access `role` method:

```LiveScript
sexy-permit = permit-for 'a sexy woman',
  match: (access) ->
    @matching(access).has-role 'sexy' # matches if access intersects with {user: {role: 'sexy'}}

    # same as
    @matching(access).role('sexy').result!
```

Access `subject-clazz` method (chaining):

```LiveScript
sexy-permit = permit-for 'a sexy woman',
  match: (access) ->
    # matches if {subject: sexy-woman} and sexy-woman.constructor is a Woman class
    @matching(access).subject-clazz('Man').has-user(type: 'sexy')
```

The `match-on` method takes a hash and executes chaining as above:

`@matching(access).match-on(subject-clazz: 'Man', user: {type: 'sexy'}, action: 'read')`

Using `@matching(access).match-on` is the recommended way as it's the most elegant, easy to use DSL.

## Rules

The `permit`, when matched successfully for the `access` object, should run all the rules.
This will populate the `canRules` and `cannotRules` of the permit.

Another strategy would be to only run the rules that matches the incoming action,
f.ex for the `sexy-permit` only run the `manage` rules if the user is trying to `manage` something.

It has yet to be decided which of these strategies to use or if it should be up to the developer to define
the strategy somehow.

## Ability

Ability wraps the permit execution for a given user.

## Authorizer

`Authorizer` should be used to wrap an Ability for the current user. It is a middleware component that should be
used with a middleware runner (see *middleware* project). The authorizer should be used to authorize a user to
access and perfor a given action on a data object of some kind.

## Normalize

The `normalize` module, contains a function that is used to normalize such things as rule actions and rule subjects.
This is used to ensure a permit access rule is *splatted out* before adding it to `canRules` or `cannotRules`

## Intersect

Intersect is used as a convenient way to easily set up a matching function for a permit.
If the object intersects on the incoming access object,
the permit can be used for that access object (in that context for that user).

If the access object is: `{user: {role: 'admin'}, ctx: {area: 'guest'}}` and the match access of the permit is `{user: {role: 'admin'}`,
then the permit match access fully intersects the access object and so the permit should apply (be used).
Otherwise the permit should be ignored for that access object (if not a full intersection).

## Allower

Determines if a given access rule should be allowed... (see test)

## PermitMatcher

Matches a permit on either user, action or context:

* UserMatcher
* ActionMatcher
* ContextMatcher

## Testing

Run `mocha` on all files in test folder

Just run all test like this:

`$ mocha`

To execute individual test, do like this:

`$ mocha test/authorize-mw/permit_test.js`

## Test coverage

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

Enjoy!
