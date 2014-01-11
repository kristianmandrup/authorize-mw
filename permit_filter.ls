_       = require 'prelude-ls'
lo      = require 'lodash'

Permit          = require './permit'
PermitRegistry  = require './permit_registry'

Debugger  = require './debugger'

module.exports = class PermitFilter implements Debugger
  # go through all permits
  # and match on access being requested by user
  # if the permit matches, then we will later check to see
  # if the permit allows the action on the subject in the given context
  @filter = (access-request) ->
    matching-fun = (permit) ->
      permit.matches access-request

    unless _.is-type 'Object', @permits!
      throw Error "Permit.permits which contain all registered permits, must be an Object, was: #{typeof @permits!}"
    _.filter matching-fun, @permits!

  @permits = ->
    PermitRegistry.permits

lo.extend PermitFilter, Debugger
