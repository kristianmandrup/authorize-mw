_ = require 'lodash'
Permit = require './permit'

module.exports = class Allower
  # access rule
  # example
  # { user: user, action: 'read', subject: book, ctx: {} }

  # TODO: perhaps rename to access-rule
  (@access) ->
    # set reference to 'global' permits registered
    @permits = PermitFilter.filter(@access)

  # go through all permits that apply
  # if any of them allows, then yes
  # TODO: use permit filter
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
