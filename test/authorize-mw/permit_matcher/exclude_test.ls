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
    users.kris    := create-user.kris
    users.emily   := create-user.emily
    requests.user :=
      user: users.kris

    permits.user   := setup.user-permit!
    permit-matcher := new PermitMatcher permits.user, requests.user

  describe 'exclude' ->
    describe 'excludes user.name: kris' ->
      before ->
        permits.user.excludes =
          user: users.kris

      specify 'matches access-request on excludes intersect' ->
        permit-matcher.exclude!.should.be.true

    describe 'excludes empty {}' ->
      before ->
        permits.user.excludes = {}

      specify 'matches access-request since empty excludes always intersect' ->
        permit-matcher.exclude!.should.be.true

    describe 'excludes other user' ->
      before ->
        permits.user.excludes =
          user: users.emily

      specify 'does NOT match access-request since NO excludes intersect' ->
        permit-matcher.exclude!.should.be.false