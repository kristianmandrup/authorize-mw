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
  var user-kris, user-emily
  var user-permit
  var permit-matcher

  matching = {}
  none-matching = {}

  before ->
    user-kris   := new User name: 'kris'
    user-emily  := new User name: 'emily'

    user-permit := setup.user-permit!

    permit-matcher := new PermitMatcher user-permit, user-access

  describe 'match access' ->
    var access-request, user-access-request, access-request-alt
    matching = {}
    none-matching = {}

    before ->
      user-access-request := {user: {}}
      access-request := {ctx: ''}

      user-permit := setup.user-permit!

      matching.permit-matcher       := new PermitMatcher user-permit, user-access-request
      none-matching.permit-matcher  := new PermitMatcher user-permit, access-request

    specify 'does not match access without user' ->
      none-matching.permit-matcher.match!.should.be.false

    specify 'matches access with user' ->
      matching.permit-matcher.match!.should.be.true

  describe 'match access - complex' ->
    var valid-access-request, invalid-access-request, access-request-alt, book
    matching = {}
    none-matching = {}

    before-each ->
      book := new Book title: 'hello'
      valid-access-request    := {user: {type: 'person', role: 'admin'}, subject: book}
      invalid-access-request  := {user: {type: 'person', role: 'admin'}, subject: 'blip'}

      Permit.clean-all!

      user-permit := setup.complex-user!

      matching.permit-matcher       := new PermitMatcher user-permit, valid-access-request
      none-matching.permit-matcher  := new PermitMatcher user-permit, invalid-access-request

    specify 'does not match access without user' ->
      none-matching.permit-matcher.match!.should.be.false

    specify 'matches access with user' ->
      matching.permit-matcher.match!.should.be.true

  describe 'match access - complex invalid' ->
    var valid-access-request, permit-matcher

    before ->
      valid-access-request := {user: {type: 'person', role: 'admin'}, subject: book}

      user-permit       := setup.complex-invalid-user!
      permit-matcher    := new PermitMatcher user-permit, valid-access-request

      specify 'AccessMatcher chaining in .match which returns AccessMatcher should throw with usage warning' ->
        ( -> permit-matcher.match! ).should.throw