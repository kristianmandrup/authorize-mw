_ = require 'lodash'

# Always one Ability per User
module.exports = class Ability
  constructor: (user) ->
    @user = user

  accessObj: (access) ->
    _.extend(access, user)

  permits: (access) ->
    permits = permitFilter.matches access

  allower: () ->
    Allower

  # access  {action: ACT, subject: SUBJ, context: CTX}
  can: (access) ->
    return @allower.allows(@accessObj)

  # access  {action: ACT, subject: SUBJ, context: CTX}
  cannot: (access) ->
    return @allower.disallows(@accessObj)