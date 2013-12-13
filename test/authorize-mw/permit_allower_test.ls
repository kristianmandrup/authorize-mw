require '../test_setup'

_          = require 'prelude-ls'
RuleRepo   = require '../../rule_repo'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

describe 'PermitAllower' ->
  var rule-repo, permit-allower
  var book

  user-request = (action, subject) ->
    user: {}
    action: action
    subject: subject

  book-request = (action) ->
    user-request 'read', 'book'

  before ->
    # setup for all tests
    rule-repo := new RuleRepo
    book      := new Book 'Far and away'

    permit-allower := new PermitAllower rule-repo

  describe 'init' ->
    specify 'has a rule repo' ->
      permit-allower.should.have.a.property 'rule-repo'

    specify 'rule repo is a RuleRepo' ->
      permit-allower.rule-repo.constructor.should.be.eql RuleRepo

  describe 'test-access' ->
    var read-book-rule, publish-book-rule
    
    before ->
      read-book-rule := {action: 'read', subject: 'Book'}
      publish-book-rule := {action: 'publish', subject: 'Book'}

    specify 'finds match for can read/Book' ->
      permit-allower.test-access('can', read-book-rule).should.be.true

    specify 'does NOT find match for can publish/Book' ->
      permit-allower.test-access('can', publish-book-rule).should.be.true

  describe 'allows' ->
    var read-book-request, write-book-request

    before ->
      read-book-request := book-request 'read'

      write-book-request := book-request 'write'

    specify 'allows guest user to read a book' ->
      permit-allower.allows(read-book-request).should.be.true

    specify 'does NOT allow guest user to write a book' ->
      permit-allower.allows(write-book-request).should.be.false

  describe 'disallows' ->
    var read-book-request, write-book-request

    before ->
      read-book-request :=
        user: {}
        action: 'read'

      write-book-request :=
        user: {}
        action: 'read'

    specify 'disallows guest user from writing a book' ->
      permit-allower.disallows(write-book-request).should.be.true

    specify 'does NOT disallow guest user from reading a book' ->
      permit-allower.allows(read-book-request).should.be.false
