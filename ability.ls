rek      = require 'rekuire'
requires = rek 'requires'

_   = require 'prelude-ls'
lo  = require 'lodash'

deep-extend   = require 'deep-extend'

permit-filter = requires.file 'permit_filter'
Allower       = requires.file 'allower'
AccessRequest = requires.file 'access_request'

Debugger = requires.file 'debugger'

# Always one Ability per User
module.exports = class Ability implements Debugger
  (@user) ->

  # adds the user of the ability to the access-request object
  access-obj: (access-request) ->
    deep-extend access-request, {user : @user}

  permits: (access-request) ->
    permit-filter.filter access-request

  allower: (access-request) ->
    new Allower(@access-obj access-request)

  allowed-for: (access-request) ->
    @allower(access-request).allows!

  not-allowed-for: (access-request) ->
    @allower(access-request).disallows!

  # alias for: allowed-for
  can: (access-request) ->
    @debug 'can', access-request
    @allowed-for access-request

  # alias for: not-allowed-for
  cannot: (access) ->
    @debug 'cannot', access-request
    @not-allowed-for access-request
