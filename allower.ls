_ = require 'lodash'
Permit = require './permit'

module.exports = class Allower
  # access rule
  # example
  # action: 'read', subject: book

  # TODO: perhaps rename to access-rule
  (@access) ->
    # set reference to 'global' permits registered
    @permits = Permit.permits

  # go through all permits that apply
  # if any of them allows, then yes
  allows: ->
    for permit in @permits
      return true if permit.allows access
    false

  # go through all permits that apply
  # if any of them disallows, then yes
  disallows: ->
    for permit in @permits
      return true if permit.disallows access
    false
