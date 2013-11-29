require '../test_setup'

_             = require 'prelude-ls'

permit-for    = require '../../permit_for'
PermitMatcher = require '../../permit_matcher'

describe 'PermitMatcher' ->
  var user-kris, access

  before ->
    user-kris   = new User name: 'kris'

    user-permit = permit-for 'User',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'

    guest-permit = permit-for 'Guest',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'
        user.role is 'guest'

    admin-permit = permit-for 'Admin',
      rules:
        admin: ->
          can 'manage', 'all'

    permit-matcher = new PermitMatcher user-permit

  describe 'construct' ->
    specify 'has user-permit' ->
      permit-matcher.user-permit.should.eql user-permit

    specify 'has own intersect object' ->
      permit-matcher.intersect.should.have.property 'on'

  describe 'match access' ->
    # TODO

  describe 'intersectOn item' ->
    # TODO