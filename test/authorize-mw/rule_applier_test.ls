require '../test_setup'

_             = require 'prelude-ls'
RuleApplier   = require '../../rule_applier'
RuleRepo      = require '../../rule_repo'

User      = require '../fixtures/user'
Book      = require '../fixtures/book'

describe 'Permit init' ->
  var access-request, rules, rule-repo, rule-applier
  var book

  # TODO: Fix test!

  rule-repo = new RuleRepo

  can = (actions, subjects, ctx) ->
    rule-repo.register-can-rule actions, subjects

  cannot = (actions, subjects, ctx) ->
    rule-repo.register-cannot-rule actions, subjects

  before ->
    book          := new Book 'Far and away'

    rules         :=
      edit: ->
        can     'edit',   'Book'
        cannot  'write',  'Book'
      read: ->
        can    'read',   ['Book', 'Paper', 'Project']
        cannot 'delete', ['Paper', 'Project']
      default: ->
        can     'read',   'Book'
        cannot  'write',  'Book'

    rule-applier  := new RuleApplier rule-repo, rules

    access-request :=
      action: 'read'
      subject: book

  describe 'apply-rules-for' ->
    before ->
      rule-applier.apply-rules-for 'edit'

    specify 'adds all can rules' ->
      can-rules.should.be.eql {
        edit: ['Book']
      }

    specify 'adds all cannot rules' ->
      cannot-rules.should.be.eql {
        write: ['Book']
      }

  describe 'apply-action-rules-for' ->
    before ->
      # adds only the 'read' rules (see access-request.action)
      rule-applier.apply-action-rules-for access-request

    specify 'adds all can rules' ->
      can-rules.should.be.eql {
        read: ['Book', 'Paper', 'Project']
      }

    specify 'adds all cannot rules' ->
      cannot-rules.should.be.eql {
        delete: ['Paper', 'Project']
      }

  describe 'apply-default-rules' ->
    before ->
      rule-applier.apply-default-rules

    specify 'adds all can rules' ->
      can-rules.should.be.eql {
        read: ['Book']
      }

    specify 'adds all cannot rules' ->
      cannot-rules.should.be.eql {
        write: ['Book']
      }

  describe 'apply-all' ->
    before ->
      rule-applier.apply-all

    specify 'adds all can rules' ->
      can-rules.should.be.eql {
        edit: ['Book']
        read: ['Book', 'Paper', 'Project']
      }

    specify 'adds all cannot rules' ->
      cannot-rules.should.be.eql {
        write: ['Book']
        delete: ['Paper', 'Project']
      }

