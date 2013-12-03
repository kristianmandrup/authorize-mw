_       = require 'prelude-ls'
Permit  = require './permit'

class PermitFilter
  # go through all permits that apply
  # if any of them allows, then yes
  @filter = (access) ->
    _.filter Permit.permits, (permit) ->
      permit.matches(access)

module.exports = PermitFilter
