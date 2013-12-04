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
        _.is-type 'Object', user

    guest-permit := permit-for 'Guest',
      match: (access) ->
        user = access.user
        _.is-type 'Object', user
        user.role is 'guest'

    admin-permit := permit-for 'Admin',
      rules:
        admin: ->
          can 'manage', 'all'

    userless-access := {ctx: {area: 'guest'}}
    user-access     := {user: user-kris}

    permit-matcher := new PermitMatcher user-permit

  describe 'init' ->
    specify 'has user-permit' ->
      permit-matcher.permit.should.eql user-permit

    specify 'has own intersect object' ->
      permit-matcher.intersect.should.have.property 'on'

  describe 'intersect-on partial, access-request' ->
    specify 'intersects when same object' ->
      permit-matcher.intersectOn(user-access, user-access).should.be.true

  describe 'include' ->
    specify 'matches access-request on includes intersect' ->

    specify 'does NOT match access-request since NO includes intersect' ->

  describe 'exclude' ->
    specify 'matches access-request on excludes intersect' ->

    specify 'does NOT match access-request since NO excludes intersect' ->

  describe 'custom-match' ->
    specify 'matches access-request using permit.match' ->

    specify 'does NOT match access-request since permit.match does NOT match' ->

  describe 'custom-match' ->
    specify 'matches access-request using permit.ex-match' ->

    specify 'does NOT match access-request since permit.match does NOT match' ->

  describe 'match access' ->
    specify 'does not match access without user' ->
      permit-matcher.match(userless-access).should.be.false

    specify 'matches access with user' ->
      permit-matcher.match(user-access).should.be.true

    # more here...