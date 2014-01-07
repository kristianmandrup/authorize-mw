require '../test_setup'

_          = require 'prelude-ls'
RuleRepo   = require '../../rule_repo'
PermitAllower = require '../../permit_allower'

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
      permit-allower.should.have.a.property 'ruleRepo'

    specify 'rule repo is a RuleRepo' ->
      permit-allower.rule-repo.constructor.should.be.eql RuleRepo

  describe 'test-access' ->
    var read-book-rule, publish-book-rule, lc-publish-book-rule
    
    before ->
      read-book-rule :=
        action: 'read'
        subject: 'Book'

      publish-book-rule :=
        action: 'publish'
        subject: 'Book'

      lc-publish-book-rule :=
        action: 'publish'
        subject: 'book'

    context 'can read book' ->
      before-each ->
        rule-repo.clean!
        rule-repo.register-rule 'can', 'read', 'Book'
        console.log rule-repo

      specify 'finds match for can read/Book' ->
        permit-allower.test-access('can', read-book-rule).should.be.true

    context 'can publish book' ->
      before-each ->
        rule-repo.clean!
        rule-repo.register-rule('can', 'publish', 'Book')
        console.log rule-repo

      specify 'does NOT find match for can read/Book' ->
        permit-allower.test-access('can', read-book-rule).should.be.false

      specify 'finds match for can publish/Book' ->
        permit-allower.test-access('can', publish-book-rule).should.be.true

      specify 'finds match for can publish/book' ->
        permit-allower.test-access('can', lc-publish-book-rule).should.be.true


  describe 'allows' ->
    var read-book-request, publish-book-request

    before-each ->
      rule-repo.clear!
      read-book-request  := book-request 'read'
      publish-book-request := book-request 'publish'

    context 'can read book' ->
      before ->
        rule-repo.register-rule 'can', 'read', 'Book'
        console.log rule-repo

      specify 'should allow guest user to read a book' ->
        permit-allower.allows(read-book-request).should.be.true

    context 'cannot publish book' ->
      before ->
        rule-repo.register-rule 'cannot', 'publish', 'Book'
        console.log rule-repo

      specify 'does NOT allow guest user to publish a book' ->
        permit-allower.allows(publish-book-request).should.be.false

  describe 'disallows' ->
    var read-book-request, publish-book-request

    before-each ->
      rule-repo.clear!
      read-book-request  := book-request 'read'
      publish-book-request := book-request 'publish'

    context 'cannot publish book' ->
      before ->
        rule-repo.register-rule 'cannot', 'publish', 'Book'
        console.log rule-repo

      specify 'should disallow guest user from publishing a book' ->
        permit-allower.disallows(publish-book-request).should.be.true

    context 'can read book' ->
      before ->
        rule-repo.register-rule 'can', 'read', 'Book'
        console.log rule-repo

      specify 'does NOT disallow guest user from reading a book' ->
        permit-allower.disallows(read-book-request).should.be.false
