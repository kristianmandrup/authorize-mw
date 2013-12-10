require '../test_setup'

_             = require 'prelude-ls'
RuleApplier   = require '../../rule_applier'
RuleRepo      = require '../../rule_repo'

User      = require '../fixtures/user'
Book      = require '../fixtures/book'

describe 'Permit init' ->
  var access-request, rule-repo, rules, rule-applier
  var book

  before ->
    book          := new Book 'Far and away'

    rules         :=
      edit: ->
        @ucan     'edit',   'Book'
        @ucannot  'write',  'Book'
      read: ->
        @ucan    'read',   ['Book', 'Paper', 'Project']
        @ucannot 'delete', ['Paper', 'Project']
      default: ->
        @ucan     'read',   'Book'
        @ucannot  'write',  'Book'

    access-request :=
      action: 'read'
      subject: book

  describe 'apply-rules-for' ->
    before ->
      rule-repo     := new RuleRepo
      rule-applier  := new RuleApplier rule-repo, rules, access-request

      rule-applier.apply-rules-for 'edit'

    specify 'adds all can rules' ->
      rule-repo.can-rules.should.be.eql {
        edit: ['Book']
      }

    specify 'adds all cannot rules' ->
      rule-repo.cannot-rules.should.be.eql {
        write: ['Book']
      }

  describe 'apply-action-rules-for read' ->
    before ->
      # adds only the 'read' rules (see access-request.action)
      rule-repo     := new RuleRepo
      rule-applier  := new RuleApplier rule-repo, rules, access-request
      rule-applier.apply-action-rules!

    specify 'adds all can rules' ->
      rule-repo.can-rules.should.be.eql {
        edit: ['Book']
      }

    specify 'adds all cannot rules' ->
      rule-repo.cannot-rules.should.be.eql {
        write: ['Book']
      }

  xdescribe 'apply-default-rules' ->
    before ->
      rule-applier.apply-default-rules!

    specify 'adds all can rules' ->
      can-rules.should.be.eql {
        read: ['Book']
      }

    specify 'adds all cannot rules' ->
      cannot-rules.should.be.eql {
        write: ['Book']
      }

  xdescribe 'apply-all' ->
    before ->
      rule-applier.apply-all!

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

