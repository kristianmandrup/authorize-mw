_ = require 'prelude-ls'
Permit = require './permit'

# makes an instance of a Permit class, adds specific functionality (such as rules) and registers the permit globally

# we should take class to use as an optional argument, not always use Permit
module.exports = (name, baseObj) ->
  permit = new Permit(name)
  if baseObj? and _.is-type 'Function', baseObj
    baseObj = baseObj()

  # extend permit with custom functionality
  permit = permit.use baseObj
  # register permit in Permit.permit
  Permit.permits.push permit
  permit
