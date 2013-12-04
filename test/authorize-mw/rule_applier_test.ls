require '../test_setup'

_             = require 'prelude-ls'
RuleApplier   = require '../../rule_applier'

User      = require '../fixtures/user'
Book      = require '../fixtures/book'

describe 'Permit init' ->
  var access-request, rules, rule-repo, rule-applier
  var book

  # TODO: Fix test!

  can = (actions, subjects, ctx) ->
    @rule-repo.register-can-rule actions, subjects

  cannot = (actions, subjects, ctx) ->
    @rule-repo.register-cannot-rule actions, subjects

  before ->
    rule-applier  := new RuleApplier
    book          := new Book 'Far and away'

    rules         :=
      edit: ->
        can     'edit',   'Book'
        cannot  'write',  'Book'
      read: ->
        can    'read',   ['Book', 'Paper', 'Project']
        cannot 'delete', ['Paper', 'Project']

    access-request :=
      action: 'read'
      subject: book

  describe 'apply-all' ->
    specify 'applies all rules' ->
      rule-applier.apply-all
      can-rules.should.be.eql {
        edit: ['Book']
        read: ['Book', 'Paper', 'Project']
      }

      cannot-rules.should.be.eql {
        write: ['Book']
        delete: ['Paper', 'Project']
      }
