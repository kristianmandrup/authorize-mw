_       = require 'prelude-ls'
Permit  = require './permit'

class PermitFilter
  # go through all permits
  # and match on access being requested by user
  # if the permit matches, then we will later check to see
  # if the permit allows the action on the subject in the given context
  @filter = (access-request) ->
    matching = (permit) ->
      permit.matches access-request

    unless _.is-type 'Array', Permit.permits
      throw Error "Permit.permits which contain all registered permits, must be an Array, was: #{typeof Permit.permits}"

    console.log access-request, Permit.permits

    _.filter matching, Permit.permits

module.exports = PermitFilter
