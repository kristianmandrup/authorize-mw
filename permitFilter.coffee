_ = require 'lodash'
Permit = require './permit'

module.exports = class PermitFilter
  # go through all permits that apply
  # if any of them allows, then yes
  @filter: (access) ->
    console.log "access: #{access}"
    _.filter Permit.permits, (permit) ->
      permit.matches(access)

