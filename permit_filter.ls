_       = require 'prelude-ls'
Permit  = require './permit'

class PermitFilter
  # go through all permits
  # and match on access being requested by user
  # if the permit matches, then we will later check to see
  # if the permit allows the action on the subject in the given context
  @filter = (access) ->
    _.filter Permit.permits, (permit) ->
      permit.matches(access)

module.exports = PermitFilter
