require '../test_setup'

_             = require 'prelude-ls'
RuleApplier   = require '../../rule_applier'
RuleRepo      = require '../../rule_repo'

User      = require '../fixtures/user'
Book      = require '../fixtures/book'

describe 'Rule Applier (RuleApplier)' ->
  var book

  debug-repo = (txt, repo) ->
    console.log txt, repo
    console.log repo.can-rules
    console.log repo.cannot-rules

  before ->
    book          := new Book 'Far and away'

  describe 'apply-rules-for' ->
    var access-request, rule-repo, rule-applier, rules

    before ->
      rules         :=
        edit: ->
          @ucan     'edit',   'Book'
          @ucannot  'write',  'Book'
        read: ->
          @ucan    'read',   ['Book', 'Paper', 'Project']
          @ucannot 'delete', ['Paper', 'Project']

      access-request :=
        action: 'read'
        subject: book

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

  describe 'apply-action-rules-for :read' ->
    var read-access-request, rule-repo, rule-applier, rules

    before ->
      rules         :=
        edit: ->
          @ucan     'edit',   'Book'
          @ucannot  'write',  'Book'
        read: ->
          @ucan    'read',   'Project'
          @ucannot 'delete', 'Paper'

      read-access-request :=
        action: 'read'
        subject: book

      # adds only the 'read' rules (see access-request.action)
      rule-repo     := new RuleRepo('action repo').clear!
      rule-applier  := new RuleApplier rule-repo, rules, read-access-request

      rule-applier.apply-action-rules!

    specify 'adds all can rules' ->
      rule-repo.can-rules.should.be.eql {
        read: ['Project']
      }

    specify 'adds all cannot rules' ->
      rule-repo.cannot-rules.should.be.eql {
        delete: ['Paper']
      }

  describe 'apply-rules' ->
    describe 'static' ->
      var read-access-request, rule-repo, rule-applier, rules

      before ->
        rules         :=
          edit: ->
            @ucan     'edit',   'Book'
            @ucannot  'write',  'Book'
          read: ->
            @ucan    'read',   'Project'
            @ucannot 'delete', 'Paper'
          default: ->
            @ucan    'read',   'Paper'

        read-access-request :=
          action: 'read'
          subject: book

        # adds only the 'read' rules (see access-request.action)
        rule-repo     := new RuleRepo('static repo').clear!
        rule-applier  := new RuleApplier rule-repo, rules

        rule-applier.apply-rules!

      specify 'adds all static can rules' ->
        rule-repo.can-rules.should.be.eql {
          read: ['Paper']
        }

      specify 'adds all static cannot rules' ->
        rule-repo.cannot-rules.should.be.eql {
        }

    describe 'dynamic' ->
      var read-access-request, rule-repo, rule-applier, rules

      before ->
        rules         :=
          edit: ->
            @ucan     'edit',   'Book'
            @ucannot  'write',  'Book'
          read: ->
            @ucan    'read',   'Project'
            @ucannot 'delete', 'Paper'

        read-access-request :=
          action: 'read'
          subject: book

        # adds only the 'read' rules (see access-request.action)
        rule-repo     := new RuleRepo('action repo').clear!
        rule-applier  := new RuleApplier rule-repo, rules, read-access-request

        rule-applier.apply-rules read-access-request

      specify 'adds all dynamic can rules (only read)' ->
        rule-repo.can-rules.should.be.eql {
          read: ['Project']
        }

      specify 'adds all dynamic cannot rules (only read)' ->
        rule-repo.cannot-rules.should.be.eql {
          delete: ['Paper']
        }

  describe 'apply-all' ->
    var read-access-request, rule-repo, rule-applier, rules

    before ->
      read-access-request :=
        action: 'read'
        subject: book

      rules         :=
        edit: ->
          @ucan     'edit',   'Book'
        read: ->
          @ucan     'read',   'Project'
        default: ->
          @ucannot  'write', 'Book'

      rule-repo     := new RuleRepo('action repo').clear!
      rule-applier  := new RuleApplier rule-repo, rules, read-access-request

      rule-applier.apply-all-rules!

    specify 'adds all can rules' ->
      rule-repo.can-rules.should.be.eql {
        edit: ['Book']
        read: ['Project']
      }

    specify 'adds all cannot rules' ->
      rule-repo.cannot-rules.should.be.eql {
        write: ['Book']
      }

  describe 'apply-all - double!' ->
    var read-access-request, rule-repo, rule-applier, rules

    before ->
      read-access-request :=
        action: 'read'
        subject: book

      rules         :=
        edit: ->
          @ucan     'edit',   'Book'
        read: ->
          @ucan     'read',   ['Project', 'project']
        default: ->
          @ucannot  'write', 'Book'
          @ucan     'edit',  'book'

      rule-repo     := new RuleRepo('action repo').clear!
      rule-applier  := new RuleApplier rule-repo, rules, read-access-request

      rule-applier.apply-all-rules!
      rule-applier.apply-all-rules!

    specify 'adds all can rules - one time' ->
      rule-repo.can-rules.should.be.eql {
        edit: ['Book']
        read: ['Project']
      }

    specify 'adds all cannot rules - one time' ->
      rule-repo.cannot-rules.should.be.eql {
        write: ['Book']
      }

  # TODO: Create tests to ensure we don't end up with duplication of subjects for a given action
  # See use of _.unique in rule_applier

  # Example from permit_test
          # dynamic application when access-request passed
          # guest-permit.apply-rules access-request

          # console.log 'can-rules', guest-permit.can-rules!

          # guest-permit.apply-rules access-request

          # console.log 'can-rules', guest-permit.can-rules!
