require '../test_setup'

_             = require 'prelude-ls'

User          = require '../fixtures/user'
permit-for    = require '../../permit_for'
PermitMatcher = require '../../permit_matcher'

describe 'PermitMatcher' ->
  var user-kris, user-permit, guest-permit, admin-permit
  var permit-matcher
  var userless-access, user-access

  before ->
    user-kris   := new User name: 'kris'

    user-permit := permit-for 'User',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'

    guest-permit := permit-for 'Guest',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'
        user.role is 'guest'

    admin-permit := permit-for 'Admin',
      rules:
        admin: ->
          can 'manage', 'all'

    userless-access := {ctx: {area: 'guest'}}
    user-access     := {user: user-kris}

    permit-matcher := new PermitMatcher user-permit

  describe 'construct' ->
    specify 'has user-permit' ->
      permit-matcher.permit.should.eql user-permit

    specify 'has own intersect object' ->
      permit-matcher.intersect.should.have.property 'on'

  describe 'match access' ->
    specify 'does not match access without user' ->
      permit-matcher.match(userless-access).should.be.false

    specify 'matches access with user' ->
      permit-matcher.match(user-access).should.be.true

  describe 'intersectOn item' ->
    specify 'intersects with user-access' ->