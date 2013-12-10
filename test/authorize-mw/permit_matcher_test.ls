require '../test_setup'

_             = require 'prelude-ls'

User          = require '../fixtures/user'
permit-for    = require '../../permit_for'
PermitMatcher = require '../../permit_matcher'

describe 'PermitMatcher' ->
  var user-kris
  var user-permit, guest-permit, admin-permit
  
  matching = {}
  none-matching = {}
  
  var permit-matcher
  var userless-access, user-access

  before ->
    user-kris   := new User name: 'kris'

    guest-permit := permit-for 'Guest',
      match: (access) ->
        user = access.user
        _.is-type 'Object', user
        user.role is 'guest'

    admin-permit := permit-for 'Admin',
      rules:
        admin: ->
          @ucan 'manage', 'all'

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
    describe 'includes user.name: kris' ->
      before ->
        permit-matcher.includes = {user: {name: 'kris'}}

      specify 'matches access-request on includes intersect' ->
        permit-matcher.include!.should.be.true

    describe 'includes empty {}' ->
      before ->
        permit-matcher.includes = {}

      specify 'does NOT match access-request since NO includes intersect' ->
        permit-matcher.include!.should.be.false

  describe 'exclude' ->
    describe 'excludes user.name: kris' ->
      before ->
        permit-matcher.excludes = {user: {name: 'kris'}}

      specify 'matches access-request on excludes intersect' ->
        permit-matcher.exclude!.should.be.true

    describe 'excludes empty {}' ->
      before ->
        permit-matcher.excludes = {}

    specify 'does NOT match access-request since NO excludes intersect' ->
        permit-matcher.exclude!.should.be.false

  describe 'custom-match' ->
    var access-request, access-request-alt
    var matching-permit-matcher, none-matching.permit-matcher
    before ->
      access-request := {}

      matching.permit-matcher := new PermitMatcher access-request
      none-matching.permit-matcher := new PermitMatcher access-request
      
      user-permit := permit-for 'User',
        match: (access) ->
          user = access.user
          _.is-type 'Object', user

    specify 'matches access-request using permit.match' ->
      matching-permit-matcher.custom-match.should.be.true

    specify 'does NOT match access-request since permit.match does NOT match' ->
      none-matching.permit-matcher.custom-match.should.be.false

    describe 'invalid match method' ->
      before ->
        user-permit := permit-for 'User',
          match: void

      specify 'should throw error' ->
        ( -> none-matching.permit-matcher.custom-match ).should.throw

  xdescribe 'custom-ex-match' ->
    var access-request, access-request-alt
    var matching-permit-matcher, none-matching.permit-matcher
    before ->
      access-request := {}

      matching.permit-matcher := new PermitMatcher access-request
      none-matching.permit-matcher := new PermitMatcher access-request

      user-permit := permit-for 'User',
        ex-match: (access) ->
          user = access.user
          _.is-type 'Object', user

    specify 'matches access-request using permit.ex-match' ->
      matching-permit-matcher.custom-ex-match.should.be.true

    specify 'does NOT match access-request since permit.match does NOT match' ->
      none-matching.permit-matcher.custom-ex-match.should.be.false

    describe 'invalid ex-match method' ->
      before ->
        user-permit := permit-for 'User',
          ex-match: void
          
      specify 'should throw error' ->
        ( -> none-matching.permit-matcher.custom-ex-match ).should.throw


  describe 'match access' ->
    specify 'does not match access without user' ->
      permit-matcher.match(userless-access).should.be.false

    specify 'matches access with user' ->
      permit-matcher.match(user-access).should.be.true

    # more here...
