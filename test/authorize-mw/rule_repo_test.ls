require '../test_setup'

_           = require 'prelude-ls'
RuleRepo    = require '../../rule_repo'
User        = require '../fixtures/user'
Book        = require '../fixtures/book'

describe 'Rule Repository (RuleRepo)' ->
  var access-request, rule, rule-repo
  var book

  rule-repo = new RuleRepo

  can = (actions, subjects, ctx) ->
    rule-repo.register-rule 'can', actions, subjects

  cannot = (actions, subjects, ctx) ->
    rule-repo.register-rule 'cannot', actions, subjects

  before ->

    book      := new Book 'Far and away'

    rule      := can 'read', 'Book'

    access-request :=
      action: 'read'
      subject: book

  specify 'has can-rules' ->
    rule-repo.can-rules.should.be.an.instance-of Object

  specify 'has cannot-rules' ->
    rule-repo.can-rules.should.be.an.instance-of Object

  specify 'has cannot-rules' ->
    rule-repo.can-rules.should.be.an.instance-of Object

  describe 'container-for' ->
    specify 'can' ->
      rule-repo.container-for('can').should.eql rule-repo.can-rules

    specify 'cannot' ->
      rule-repo.container-for('cannot').should.eql rule-repo.cannot-rules

  describe 'register-rule' ->
    specify 'can register a valid rule' ->
      rule-repo.register-rule('can', 'read', 'Book')

    specify 'throws error on invalid rule' ->
      ( -> rule-repo.register-rule 'can', 'read', null).should.throw!

  describe 'add-rule' ->
    var container
    before ->
      container := {}

    specify 'can add a valid rule' ->
      rule-repo.add-rule(container, 'read', 'Book')
      container['read'].should.include 'Book'

    specify 'throws error if container is null' ->
      ( -> rule-repo.add-rule null, 'read', 'Book' ).should.throw!

    specify 'throws error if container is not an Object' ->
      ( -> rule-repo.add-rule [], 'read', 'Book' ).should.throw!

  describe 'match-rule' ->
    var read-book-rule, publish-book-rule

    before ->
      rule-repo.can-rules :=
        'read': ['Book']

      read-book-rule := {action: 'read', subject: 'Book'}
      publish-book-rule := {action: 'publish', subject: 'Book'}

    specify 'can find rule that allows user to read a book' ->
      rule-repo.match-rule('can', read-book-rule).should.be.true

    specify 'can NOT find rule that allows user to publish a book' ->
      rule-repo.match-rule('can', publish-book-rule).should.be.false