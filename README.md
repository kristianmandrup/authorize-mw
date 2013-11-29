authorize-mw
============

Authorization middleware for Node.js and Javascript platform in general (with a little twist)

## Requirements

Node.s installed on your computer (http://www.node.org)
*LiveScript*

## Install

```
$ npm install LiveScript -g
$ npm install
```

Compile LiveScript files!

This can be done either manually or from within an Editor (such as WebStorm or Sublime Text) using a LiveScript editor plugin.

## Architecture

A `Permit` is the main conceptual class. It contains the logic to test if it makes sense to apply in a given
access context (given the access object). By calling `permit.matches(access)` you can see if the permit matches for
the particular access object.

This is used by the `PermitFilter` class, to filter out all the registered permits (in `Permit.permits`) for a given access object.
Each permit that passes this filter can then be applied for a given access permission: (user, action, object or class)

This is where the `canRules` come into play!

```coffeescript
class Permit
  # ...
  allows: (rule) ->
    return false if @disallows(rule)
    @canRules.include rule

  disallows: (rule) ->
    @cannotRules.include rule
```

Creating the permit using `permitFor factory

```
myPermit = permitFor 'a man walking into the bar', ->
  # return true if this permit applies for this access obj
  match: (access) ->
    access is 'x'

  # execute all methods in Object rules (or according to current context)
  rules:
    manage: ->
      can 'manage', ['post', 'comment']
    publish: ->
      can 'publish', ['post']
```

The permit, when constructed should run all the rules to build the `canRules` and `cannotRules`
Another strategy would be to only run the rule that matches the incoming action?

`permitFor` should also optionally take a `Permit` class argument, such as `AdminPermit` to further greater reuse!
It should test if the first argument in a string or not. if not a string, use this as the permit class,
then proceed normally with remaining arguments.

`myPermit = permitFor AdminPermit, 'a man walking into the bar', ->`

`permitFactories` shows how to use `permitFor` to build `Permits` and then how to use them using filters and allows.

Ability wraps the permit execution for a given user.

`Authorizer` is an even higher level wrapper to be used with `middleware` runner.

## Testing

Run `mocha` on all files in test folder

Just run all test like this:

`$ mocha`

To execute individual test, sth like this:

`$ mocha test/authorize-mw/permit_test.js`


