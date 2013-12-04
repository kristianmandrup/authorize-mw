# authorize-mw

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

A `Permit` is the main conceptual class. It contains the logic to test if it makes sense to apply the permit in a given
access context. Calling `permit.matches(access)` returns true if the permit matches the `access` object.

The `access` object always contains the `user trying to ask permission. It can also contain items to identify the current context.

`access = {user: user, context: context}`

## PermitFilter

The `PermitFilter` is used to filter all the registered permits (`Permit.permits`).
For a given access object it will return only those permits that match for that given access object.

Each permit that passes this filter can then be applied to an access rule: (action, subject, context-rule).

Example access rule

```LiveScript
can 'edit', 'book', (obj) ->
  obj.author == @user.id
```

This `can` call is always executed in the context of a user (typically the current user), by means of an `Ability`.
Each permit that matches for the given access context is then resolved to see if the user really can (is allowed)
to perform the particular action on the subject (optionally also given the context-rule).
This is done by executing `allows` and `disallows` for the permit, passing in the access rule.

allows: If the permit contains a matching rule in canRules, the access rule will be allowed.
disallows: If the permit contains a matching rule in cannotRules the rule will be disallowed.

```LiveScript
class Permit
  # ...
  allows: (rule) ->
    return false if @disallows(rule)
    @canRules.include rule

  disallows: (rule) ->
    @cannotRules.include rule
```

## Using permit-for

A Permit class can be created via the `permit-for` factory method.

Example:

```LiveScript
sexy-permit = permit-for 'a sexy woman',
  # return true if this permit does not apply (should be excluded!) this access obj
  exMatch: (access) ->
    user = access.user
    user.gender is 'female' and user.looks is 'sexy'

  rules:
    manage: ->
      can 'manipulate', ['person'], (obj) ->
        obj.gender is 'male'
```

## Building Permits

`permit-for` should optionally take a `Permit` class argument, such as `AdminPermit` to further greater reuse.
i.e so that you specify the base class to be used for the instance constructed and not always just use the `Permit` class.
It should test if the first argument is a string or not. If not a string, use this as the permit class,
then proceed normally with remaining arguments.

Example:

`admin-bar-permit = permitFor AdminPermit, 'a man walking into the bar', customPermit`

The `customPermit` can be either an Object or a Function.

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

`Authorizer` should be used to wrap an Ability for the current user. It is a middleware component that should be  used with a middleware runner (see *middleware* project). The authorizer should be used to authorize a user to access and perfor a given action on a data object of some kind.

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

It really works :)

## Allower

Determines if a given access rule should be allowed... (see test)

Note: Currently it looks like it iterates all registered permits. It should be using filtered permits somehow,
so it only iterates the set of permits that matches the given access object (i.e user and context)

## Testing

Run `mocha` on all files in test folder

Just run all test like this:

`$ mocha`

To execute individual test, do like this:

`$ mocha test/authorize-mw/permit_test.js`


