_   = require 'prelude-ls'
lo  = require 'lodash'

permit-filter = require './permit_filter'
Allower       = require './allower'
AccessRequest = require './access_request'

deep-extend = require 'deep-extend'

Debugger = require './debugger'

# Always one Ability per User
module.exports = class Ability implements Debugger
  (@user) ->

  # adds the user of the ability to the access-request object
  access-obj: (access-request) ->
    deep-extend access-request, {user : @user}

  permits: (access-request) ->
    permits = permit-filter.filter access-request

  allower: (access-request) ->
    new Allower(@access-obj access-request)

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
