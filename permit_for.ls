_ = require 'prelude-ls'
Permit = require './permit'

module.exports = (name, baseObj) ->
  permit = new Permit(name)
  if baseObj? and _.is-type 'Function', baseObj
    baseObj = baseObj()

  permit = permit.use baseObj
  Permit.permits.push permit
  permit
