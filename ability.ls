_   = require 'prelude-ls'
lo  = require 'lodash'

permit-filter = require './permit_filter'
Allower       = require './allower'
AccessRequest = require './access_request'

# Always one Ability per User
module.exports = class Ability
  (@user) ->

  # adds the user of the ability to the access-request object
  # TODO: should use AccessRequest here!?
  accessObj: (access-request) ->
    lo.merge access-request, @user

  permits: (access-request) ->
    permits = permit-filter.filter access-request

  allower: (access-request) ->
    new Allower(@accessObj access-request)

  allowed-for: (access-request) ->
    @allower(access-request).allows!

  not-allowed-for: (access-request) ->
    @allower(access-request).disallows!

  # alias for: allowed-for
  can: (access-request) ->
    allowed-for access-request

  # alias for: not-allowed-for
  cannot: (access) ->
    not-allowed-for access-request
