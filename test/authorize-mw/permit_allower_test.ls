require '../test_setup'

_          = require 'prelude-ls'
RuleRepo   = require '../../rule_repo'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

describe 'PermitAllower' ->
  var access-request, read-book-rule, publish-book-rule, rule-repo, permit-allower
  var book

  before ->
    rule-repo := new RuleRepo
    book      := new Book 'Far and away'

    read-book-rule := {action: 'read', subject: 'Book'}
    publish-book-rule := {action: 'publish', subject: 'Book'}

    permit-allower := new PermitAllower(rule-repo)

  describe 'init' ->
    specify 'has a rule repo' ->
      permit-allower.should.have.a.property 'rule-repo'

    specify 'rule repo is a RuleRepo' ->
      permit-allower.rule-repo.constructor.should.be.eql RuleRepo

  describe 'test-access' ->
    before ->
      # set up rule repo with can 'read', 'Book' rule!!!
      rule-repo :=
        'read': ['Book']

    specify 'finds match for can read/Book' ->
      permit-allower.test-access('can', read-book-rule).should.be.true

    specify 'does NOT find match for can publish/Book' ->
      permit-allower.test-access('can', publish-book-rule).should.be.true

  describe 'allows' ->
    before ->
      # set up rule repo with can 'read', 'Book' rule!!!
      rule-repo :=
        'read': ['Book']

    specify 'allows guest user to read a book' ->
      #

    specify 'does NOT allow guest user to write a book' ->
      #

  describe 'disallows' ->
    before ->
      # set up rule repo with can 'read', 'Book' rule!!!
      rule-repo :=
        'read': ['Book']

    specify 'disallows guest user from writinga book' ->
      #

    specify 'does NOT disallow guest user from reading a book' ->
      #
