_ = require 'lodash'
Permit = require './permit'

module.exports = class Allower
  # access rule
  # example
  # { user: user, action: 'read', subject: book, ctx: {} }

  (@access-request) ->
    # filter to only use permits that make sense for current access request
    @permits = PermitFilter.filter(@access-request)

  # go through all permits that apply
  # if any of them allows, then yes
  allows: ->
    execute-for 'allows'

  # go through all permits that apply
  # if any of them disallows, then yes
  disallows: ->
    execute-for 'disallows'

  pemits-allow: (type) ->
    for permit in @permits
      # apply dynamic rules
      permit.apply-rules! @access-request
      return true if permit[type] @access-request
    false
