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

create-user     = requires.fac 'create-user'
create-request  = requires.fac 'create-request'
create-permit   = requires.fac 'create-permit'

describe 'PermitMatcher' ->
  var permit-matcher, book

  users     = {}
  permits   = {}
  requests  = {}

  matching = {}
  none-matching = {}

  before ->
    users.kris        := create-user.kris
    requests.user     :=
      user: users.kris

    permits.user      := setup.user-permit!
    permit-matcher    := new PermitMatcher permits.user, requests.user

  describe 'include' ->
    describe 'includes user.name: kris' ->
      before ->
        permits.user.includes =
          user: users.kris

      specify 'matches access-request on includes intersect' ->
        permit-matcher.include!.should.be.true

    describe 'includes empty {}' ->
      before ->
        permits.user.includes = {}

      specify 'matches access-request since empty includes always intersect' ->
        permit-matcher.include!.should.be.true

    describe 'includes is nil' ->
      before ->
        permits.user.includes = void

      specify 'does NOT match access-request since NO includes intersect' ->
        permit-matcher.include!.should.be.false