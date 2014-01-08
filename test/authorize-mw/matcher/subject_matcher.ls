require '../test_setup'

Book            = require '../fixtures/book'
matchers        = require '../../matchers'
SubjectMatcher  = matchers.SubjectMatcher

describe 'SubjectMatcher' ->
  var subject-matcher
  var book-access-request
  var book, book-title

  before ->
    book-title := 'the return of the jedi'
    book := new Book title: book-title
    book-access-request :=
      subject: book

  describe 'create' ->
    before-each ->
      subject-matcher  := new SubjectMatcher book-access-request

    specify 'must have admin access request' ->
      subject-matcher.access-request.should.eql book-access-request

  describe 'match' ->
    before-each ->
      subject-matcher  := new SubjectMatcher book-access-request

    specify 'should match book: the return of the jedi' ->
      subject-matcher.match(title: book-title).should.be.true

    specify 'should NOT match book: the return to oz' ->
      subject-matcher.match(title: 'the return to oz').should.be.false

    specify 'should match on no argument' ->
      subject-matcher.match!.should.be.true