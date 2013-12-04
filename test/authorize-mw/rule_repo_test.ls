require '../test_setup'

_          = require 'prelude-ls'
RuleRepo   = require '../../rule_repo'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

describe 'Rule Repository (RuleRepo)' ->
  var access-request, rule, rule-repo
  var book

  can = (actions, subjects, ctx) ->
    @rule-repo.register-can-rule actions, subjects

  cannot = (actions, subjects, ctx) ->
    @rule-repo.register-cannot-rule actions, subjects

  before ->
    rule-repo := new RuleRepo
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

  describe 'register-rule' ->
    specify 'can register a valid rule' ->
      # TODO

    specify 'throws error on invalid rule' ->
      # TODO

    # ...
  describe 'some other function in RuleRepo ...' ->
