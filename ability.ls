_ = require 'prelude-ls'

permit-filter = require './permit_filter'
Allower = require './allower'

# Always one Ability per User
module.exports = class Ability
  (@user) ->

  accessObj: (access) ->
    _.extend(access, user)

  permits: (access) ->
    permits = permit-filter.matches access

  allower: (access) ->
    new Allower(@accessObj access)

  allowed-for: (access) ->
    @allower(access).allows!

  not-allowed-for: (access, rule) ->
    @allower(access).disallows!

  # access  {action: ACT, subject: SUBJ, context: CTX}
  can: (access) ->
    return allowed-for access

  # access  {action: ACT, subject: SUBJ, context: CTX}
  cannot: (access) ->
    return not-allowed-for access
