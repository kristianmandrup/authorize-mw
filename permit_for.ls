_ = require 'prelude-ls'
Permit = require './permit'

# makes an instance of a Permit class, adds specific functionality (such as rules) and registers the permit globally

# we should take class to use as base class an optional first argument
# use Permit class as default if first arg is a String (ie. name)
module.exports = (base-clazz, name, base-obj) ->
  # tweak args if no base class as first arg
  if _.is-type 'String', base-clazz
    base-clazz = Permit
    name = base-clazz
    base-obj = name

  permit = new base-clazz name

  if base-obj? and _.is-type 'Function', base-obj
    base-obj = base-obj!

  # extend permit with custom functionality
  if _.is-type 'Object', base-obj
    permit = permit.use base-obj
  # register permit in Permit.permit
  Permit.permits.push permit
  permit.init!
