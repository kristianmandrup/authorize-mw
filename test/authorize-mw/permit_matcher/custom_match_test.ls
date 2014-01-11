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
  var subject
  var permit-matcher, book

  users     = {}
  permits   = {}
  requests  = {}

  matching = {}
  none-matching = {}

  before ->
    users.kris      := create-user.kris
    users.emily     := create-user.emily
    requests.user :=
      user: {}

    permits.user    := setup.user-permit!
    permit-matcher  := new PermitMatcher permits.user, requests.user

  describe 'custom-match' ->
    before ->
      book                := new Book title: 'far and away'
      requests.subject :=
        user: {}
        subject: book

      requests.ctx    :=
        ctx: void

      permits.book    := setup.book-permit!

      matching.permit-matcher       := new PermitMatcher permits.book, requests.subject
      none-matching.permit-matcher  := new PermitMatcher permits.book, requests.ctx

    context 'matching permit-matcher' ->
      before ->
        subject := matching.permit-matcher

      specify 'has permit' ->
        subject.permit.should.eql permits.book

      specify 'has subject access-request' ->
        subject.access-request.should.eql requests.subject

    context 'matching permit-matcher' ->
      before ->
        subject := none-matching.permit-matcher

      specify 'has permit' ->
        subject.permit.should.eql permits.book

      specify 'has access-request' ->
        subject.access-request.should.eql requests.ctx

    specify 'matches access-request using permit.match' ->
      matching.permit-matcher.custom-match!.should.be.true

    specify 'does NOT match access-request since permit.match does NOT match' ->
      none-matching.permit-matcher.custom-match!.should.be.false

    describe 'invalid match method' ->
      before ->
        permits.user := setup.invalid-user!

      specify 'should throw error' ->
        ( -> none-matching.permit-matcher.custom-match ).should.throw