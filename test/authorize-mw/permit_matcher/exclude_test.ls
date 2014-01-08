requires = require '../../../requires'

requires.test 'test_setup'

Book            = requires.fixture 'book'
User            = requires.fixture 'user'
permit-for      = requires.file 'permit-for'
PermitMatcher   = requires.file 'permit_matcher'
Permit          = requires.file 'permit'
PermitRegistry  = requires.file 'permit-registry'
setup           = require('./permits').setup

describe 'PermitMatcher' ->
  var user-kris, user-emily
  var user-permit
  var permit-matcher

  before ->
    user-kris   := new User name: 'kris'
    user-emily  := new User name: 'emily'

    user-permit     := setup.user-permit!
    permit-matcher := new PermitMatcher user-permit, user-access

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