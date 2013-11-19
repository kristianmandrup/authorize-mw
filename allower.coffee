_ = require 'lodash'
Permit = require './permit'

module.exports = class Allower
  @permits = Permit.permits
  # go through all permits that apply
  # if any of them allows, then yes
  @allows: (access) ->
    for permit in @permits
      return true if permit.allows(access)
    false

  # go through all permits that apply
  # if any of them disallows, then yes
  @disallows: (access) ->
    for permit in @permits
      return true if permit.disallows(access)
    false
