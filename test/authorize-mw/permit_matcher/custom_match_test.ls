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
  var user-permit, book-permit
  var permit-matcher

  matching = {}
  none-matching = {}

  before ->
    user-kris   := new User name: 'kris'
    user-emily  := new User name: 'emily'

    user-permit     := setup.user-permit!
    permit-matcher  := new PermitMatcher user-permit, user-access

  describe 'custom-match' ->
    var subj
    var access-request, subj-access-request, access-request-alt, book, book-permit
    matching = {}
    none-matching = {}

    before ->
      book                := new Book title: 'far and away'
      subj-access-request := {user: {}, subject: book}

      access-request := {ctx: void}
      book-permit    := setup.book-permit!

      matching.permit-matcher       := new PermitMatcher book-permit, subj-access-request
      none-matching.permit-matcher  := new PermitMatcher book-permit, access-request

    context 'matching permit-matcher' ->
      before ->
        subj := matching.permit-matcher

      specify 'has permit' ->
        subj.permit.should.eql book-permit

      specify 'has subject access-request' ->
        subj.access-request.should.eql subj-access-request

    context 'matching permit-matcher' ->
      before ->
        subj := none-matching.permit-matcher

      specify 'has permit' ->
        subj.permit.should.eql book-permit

      specify 'has access-request' ->
        subj.access-request.should.eql access-request

    specify 'matches access-request using permit.match' ->
      matching.permit-matcher.custom-match!.should.be.true

    specify 'does NOT match access-request since permit.match does NOT match' ->
      none-matching.permit-matcher.custom-match!.should.be.false

    describe 'invalid match method' ->
      before ->
        user-permit := setup.invalid-user!

      specify 'should throw error' ->
        ( -> none-matching.permit-matcher.custom-match ).should.throw