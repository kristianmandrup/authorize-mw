require '../test_setup'

Book            = require '../fixtures/book'
match-makers    = require '../../permit_match_maker'

AccessMatcher = match-makers.AccessMatcher

describe 'AccessMatcher' ->
  var access-matcher, userless-access-matcher
  var complex-access-request, userless-access-request
  var book

  before ->
    book := new Book 'a book'
    complex-access-request :=
      user:
        role: 'admin'
      action: 'read'
      subject: book

    userless-access-request :=
      action: 'read'
      subject: book

    access-matcher  := new AccessMatcher complex-access-request
    userless-access-matcher  := new AccessMatcher userless-access-request

  describe 'create' ->
    specify 'must have complex access request' ->
      access-matcher.access-request.should.eql complex-access-request

  describe 'chaining' ->
    before-each ->
      access-matcher  := new AccessMatcher complex-access-request

    specify 'should match chaining: role(admin).action(read)' ->
      access-matcher.role('admin').action('read').result!.should.be.true

    describe 'has-action calls result!' ->
      specify 'should match chaining: role(admin).action(read)' ->
        access-matcher.role('admin').has-action('read').should.be.true

    describe 'has-user calls result!' ->
      specify 'should match chaining: role(admin).action(read).has-user()' ->
        access-matcher.role('admin').action('read').has-user!.should.be.true

      specify 'should match chaining: role(admin).action(read).has-user()' ->
        userless-access-matcher.role('admin').action('read').has-user!.should.be.false

    describe 'has-subject calls result!' ->
      specify 'should match chaining: role(admin).action(read).user().has-subject()' ->
        access-matcher.role('admin').action('read').user!.has-subject!.should.be.true

  describe 'match' ->
    before-each ->
      access-matcher  := new AccessMatcher complex-access-request

    specify 'should match action: read' ->
      access-matcher.match-on(action: 'read').should.be.true

    specify 'should match role: admin' ->
      access-matcher.match-on(role: 'admin').should.be.true

    specify 'should match role: admin and action: read' ->
      access-matcher.match-on(role: 'admin', action: 'read').should.be.true

    specify 'should NOT match role: admin and action: write' ->
      access-matcher.match-on(role: 'admin', action: 'write').should.be.false