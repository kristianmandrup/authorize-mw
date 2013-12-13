require '../test_setup'

_             = require 'prelude-ls'

User          = require '../fixtures/user'
permit-for    = require '../../permit_for'
PermitMatcher = require '../../permit_matcher'

describe 'PermitMatcher' ->
  var user-kris, user-emily
  var user-permit, guest-permit, admin-permit
  
  matching = {}
  none-matching = {}
  
  var permit-matcher
  var userless-access, user-access

  before ->
    user-kris   := new User name: 'kris'
    user-emily  := new User name: 'emily'

    user-permit := permit-for 'User',
      match: (access) ->
        user = if access? then access.user else {}
        _.is-type 'Object', user

      rules: ->

    guest-permit := permit-for 'Guest',
      match: (access) ->
        user = if access? then access.user else {}
        _.is-type 'Object', user
        user.role is 'guest'

      rules: ->
        @ucan 'read', 'Book'


    admin-permit := permit-for 'Admin',
      rules:
        admin: ->
          @ucan 'manage', 'all'

    userless-access := {ctx: {area: 'guest'}}
    user-access     := {user: user-kris}

    permit-matcher := new PermitMatcher user-permit, user-access

  describe 'init' ->
    specify 'has user-permit' ->
      permit-matcher.permit.should.eql user-permit

    specify 'has own intersect object' ->
      permit-matcher.intersect.should.have.property 'on'

  describe 'intersect-on partial, access-request' ->
    specify 'intersects when same object' ->
      permit-matcher.intersect-on(user-access).should.be.true

  describe 'include' ->
    describe 'includes user.name: kris' ->
      before ->
        user-permit.includes = {user: user-kris}

      specify 'matches access-request on includes intersect' ->
        permit-matcher.include!.should.be.true

    describe 'includes empty {}' ->
      before ->
        user-permit.includes = {}

      specify 'matches access-request since empty includes always intersect' ->
        permit-matcher.include!.should.be.true

    describe 'includes is nil' ->
      before ->
        user-permit.includes = void

      specify 'does NOT match access-request since NO includes intersect' ->
        permit-matcher.include!.should.be.false


  describe 'exclude' ->
    describe 'excludes user.name: kris' ->
      before ->
        user-permit.excludes = {user: user-kris}

      specify 'matches access-request on excludes intersect' ->
        permit-matcher.exclude!.should.be.true

    describe 'excludes empty {}' ->
      before ->
        user-permit.excludes = {}

      specify 'matches access-request since empty excludes always intersect' ->
          permit-matcher.exclude!.should.be.true

    describe 'excludes other user' ->
      before ->
        user-permit.excludes = {user: user-emily}

      specify 'does NOT match access-request since NO excludes intersect' ->
        permit-matcher.exclude!.should.be.false

  describe 'custom-match' ->
    var access-request, user-access-request, access-request-alt
    matching = {}
    none-matching = {}

    before ->
      user-access-request := {user: {}}
      access-request := {ctx: void}

      matching.permit-matcher := new PermitMatcher user-access-request
      none-matching.permit-matcher := new PermitMatcher access-request
      
      user-permit := permit-for 'User',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type 'Object', user

        rules: ->
          @ucan 'read', 'Book'

      specify 'matches access-request using permit.match' ->
        matching.permit-matcher.custom-match!.should.be.true

      specify 'does NOT match access-request since permit.match does NOT match' ->
        none-matching.permit-matcher.custom-match!.should.be.false

    describe 'invalid match method' ->
      before ->
        user-permit := permit-for 'invalid User',
          match: void
          rules: ->

      specify 'should throw error' ->
        ( -> none-matching.permit-matcher.custom-match ).should.throw

  describe 'custom-ex-match' ->
    var access-request, user-access-request, access-request-alt
    matching = {}
    none-matching = {}

    before ->
      user-access-request := {user: {}}
      access-request := {ctx: void}

      matching.permit-matcher := new PermitMatcher user-access-request
      none-matching.permit-matcher := new PermitMatcher access-request

      user-permit := permit-for 'ex User',
        ex-match: (access) ->
          user = if access? then access.user else void
          _.is-type 'Object', user

        rules: ->
          @ucan 'read', 'Book'

      specify 'matches access-request using permit.ex-match' ->
        matching.permit-matcher.custom-ex-match!.should.be.true

      specify 'does NOT match access-request since permit.match does NOT match' ->
        none-matching.permit-matcher.custom-ex-match!.should.be.false

    describe 'invalid ex-match method' ->
      before ->
        user-permit := permit-for 'User',
          ex-match: void
          rules: ->
          
      specify 'should throw error' ->
        ( -> none-matching.permit-matcher.custom-ex-match ).should.throw


  describe 'match access' ->
    var access-request, user-access-request, access-request-alt
    matching = {}
    none-matching = {}

    before ->
      user-access-request := {user: {}}
      access-request := {ctx: void}

      matching.permit-matcher := new PermitMatcher user-access-request
      none-matching.permit-matcher := new PermitMatcher access-request

      user-permit := permit-for 'ex User',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type 'Object', user

        rules: ->
          @ucan 'read', 'Book'

      specify 'does not match access without user' ->
        none-matching.permit-matcher.match!.should.be.false

      specify 'matches access with user' ->
        matching.permit-matcher.match!.should.be.true
