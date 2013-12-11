Permit        = require './permit'
PermitFilter  = require './permit_filter'

module.exports = class Allower
  # access rule
  # example
  # { user: user, action: 'read', subject: book, ctx: {} }

  (@access-request) ->
    # filter to only use permits that make sense for current access request
    @permits = PermitFilter.filter(@access-request)
    console.log @permits

  # go through all permits that apply
  # if any of them allows, then yes
  allows: ->
    @test 'allows'

  # go through all permits that apply
  # if any of them disallows, then yes
  disallows: ->
    @test 'disallows'

  test: (allow-type) ->
    for permit in @permits
      # apply dynamic rules
      permit.apply-rules @access-request
      return true if permit[allow-type] @access-request
    false
