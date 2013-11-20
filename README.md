authorize-mw
============

Authorization middleware for Node.js and Javascript platform in general (with a little twist)

## Contribute

Requires Node.s installed on your computer (http://www.node.org)
Also currently requires Coffee-script! (TODO: convert to LiveScript ASAP!)

```
$ npm install coffee-script -g
$ npm install
```

Compile coffee-script files!

This can be done either manually or from within an editor using a coffee-script plugin

target file could fx be `permit.js` or `permitFactories.js` for now.

Soon will be via tests only!

`$ node <target file>`

## Architecture

A `Permit` is the main conceptual class. It contains the logic to test if it makes sense to apply in a given
access context (given the access object). By calling `permit.matches(access)` you can see if the permit matches for
the particular access object.
This is used by the PermitFilter class, to filter out all the registered permits (in Permit.permits) for a given access object.
Each permit that passes this filter can then be applied for a given access permission: (user, action, object or class)

This is where the canRules come into play!

```coffeescript
class Permit
  # ...
  allows: (rule) ->
    return false if @disallows(rule)
    @canRules.include rule

  disallows: (rule) ->
    @cannotRules.include rule
```

```
myPermit = permitFor 'a man walking into the bar', ->
  # return true if this permit applies for this access obj
  match: (access) ->
    access is 'x'

  # we will execute all methods under rules :)
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


## TODO

Create tests using *mocha* in /test folder

Setup Mocha!

## Testing

Should run mocha on all files in test folder?

Use different report type with `-R` option

`$ mocha test -R spec`

`$ mocha test -R list`


