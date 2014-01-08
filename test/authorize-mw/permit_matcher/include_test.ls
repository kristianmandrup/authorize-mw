rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

Book            = requires.fixture 'book'
User            = requires.fixture 'user'
permit-for      = requires.file 'permit-for'
PermitMatcher   = requires.file 'permit_matcher'
Permit          = requires.file 'permit'
PermitRegistry  = requires.file 'permit-registry'
setup           = require('./permits').setup

describe 'PermitMatcher' ->
  var user-kris
  var user-permit
  var permit-matcher

  before ->
    user-kris       := new User name: 'kris'
    user-permit     := setup.user-permit!
    permit-matcher  := new PermitMatcher user-permit, user-access

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