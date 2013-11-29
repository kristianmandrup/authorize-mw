require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

require '../fixtures/permits'

Permit        = require '../../permit'
PermitFilter  = require '../../permit_filter'

describe 'permit-filter', ->
  var user, user-permit, guest-permit

  before ->
    guest-user  = new User role: 'guest'

    user-permit = permit-for 'User',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'

    guest-permit = permit-for 'Guest',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'
        user.role is 'guest'

  describe 'guest user filter' ->
    specify 'return only permits that apply for a guest user' ->
      PermitFilter.filter(guest-user).should.eql [user-permit, guest-permit]