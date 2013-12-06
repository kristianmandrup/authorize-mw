require '../test_setup'

_           = require 'prelude-ls'
RuleRepo    = require '../../rule_repo'
User        = require '../fixtures/user'
Book        = require '../fixtures/book'

describe 'Rule Repository (RuleRepo)' ->
  var access-request, rule, rule-repo
  var book
  var can, cannot

  before ->
    console.log RuleRepo.canrules

    rule-repo := new RuleRepo

    can := (actions, subjects, ctx) ->
      rule-repo.register-rule 'can', actions, subjects

    cannot := (actions, subjects, ctx) ->
      rule-repo.register-rule 'cannot', actions, subjects

    book      := new Book 'Far and away'
    rule      := can 'read', 'Book'

    access-request :=
      action: 'read'
      subject: book





  xspecify 'has can-rules' ->
    console.log 'hola '+rule-repo.can-rules
    rule-repo.can-rules.should.be.an.instanceof Object

  xspecify 'has cannot-rules' ->
    rule-repo.can-rules.should.be.an.instanceof Object

  xspecify 'has cannot-rules' ->
    rule-repo.can-rules.should.be.an.instanceof Object

  xdescribe 'container-for' ->
    specify 'can' ->
      rule-repo.container-for('can').should.eql rule-repo.can-rules

    specify 'cannot' ->
      rule-repo.container-for('cannot').should.eql rule-repo.cannot-rules

  xdescribe 'register-rule' ->

    var repo
    before ->
      repo := new RuleRepo.clear!

    specify 'can register a valid rule' ->
      repo.register-rule('can', 'read', 'Book')
      repo.can-rules.should.eql {
        'read': ['Book']
      }

    specify 'throws error on invalid rule' ->
      ( -> repo.register-rule 'can', 'read', null).should.throw!

  xdescribe 'add-rule' ->
    var container
    var repo
    before ->
      container := {}
      repo := new RuleRepo.clear!

    specify 'can add a valid rule' ->
      repo.add-rule(container, 'read', 'Book')
      repo.can-rules.should.eql {
        'read': ['Book']
      }
      container['read'].should.include 'Book'

    specify 'throws error if container is null' ->
      ( -> repo.add-rule null, 'read', 'Book' ).should.throw!

    specify 'throws error if container is not an Object' ->
      ( -> repo.add-rule [], 'read', 'Book' ).should.throw!

  xdescribe 'match-rule' ->
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