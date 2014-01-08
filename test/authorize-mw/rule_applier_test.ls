rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

_             = require 'prelude-ls'

User      = requires.fix 'user'
Book      = requires.fix 'book'

RuleApplier   = requires.file 'rule_applier'
RuleRepo      = requires.file 'rule_repo'

# Note: Use rule-repo.display! for debugging internals of RuleRepo instances after rule application

describe 'Rule Applier (RuleApplier)' ->
  var book
  var rule-repo
  var rule-applier

  rules = {}

  create-repo = ->
    new RuleRepo('static repo').clear!

  create-rule-applier = (rules) ->
    rule-repo := create-repo!
    rule-applier := new RuleApplier(rule-repo, rules)

  exec-rule-applier = (rules) ->
    rule-applier := create-rule-applier(rules).apply-rules!

  before ->
    book          := new Book 'Far and away'

  # can create, edit and delete a Book
  describe 'manage book' ->
    context 'applied default rule: manage Paper' ->
      before ->
        rules.manage-paper :=
          default: ->
            @ucan    'manage',   'Paper'

        exec-rule-applier rules.manage-paper

      specify 'should add create, edit and delete can-rules' ->
        rule-repo.can-rules.should.eql {
          manage: ['Paper']
          create: ['Paper']
          edit:   ['Paper']
          delete: ['Paper']
        }

    context 'applied action rule: manage Book' ->
      before ->
        rules.manage-book :=
          manage: ->
            @ucan    'manage',   'Book'

        create-rule-applier(rules.manage-book).apply-action-rules 'manage'

      specify 'should add create, edit and delete can-rules' ->
        rule-repo.can-rules.should.eql {
          manage: ['Book']
          create: ['Book']
          edit:   ['Book']
          delete: ['Book']
        }


  # can read any subject
  xdescribe 'read any' ->
    context 'applied default rule: read any' ->
      before ->
        rules.read-any :=
          default: ->
            @ucan    'read',   'any'

        exec-rule-applier rules.read-any

      specify 'should add can-rule: read *' ->
        rule-repo.can-rules.should.eql {
          read: ['*']
        }

  # can read any subject
  xdescribe 'read *' ->
    context 'applied default rule: read any' ->
      var read-rules

      before ->
        rules.read-star :=
          default: ->
            @ucan    'read',   '*'

        exec-rule-applier rules.read-star

      specify 'should add can-rule: read *' ->
        rule-repo.can-rules.should.eql {
          read: ['*']
        }

  # can create, edit and delete any subject
  xdescribe 'manage any' ->
    context 'applied default rule: manage any' ->
      var manage-rules

      before ->
        rules.manage-any :=
          default: ->
            @ucan    'manage',   'any'

        exec-rule-applier rules.manage-any

      specify 'should add can-rule: read *' ->
        rule-repo.can-rules.should.eql {
          create: ['Book']
          edit:   ['Book']
          delete: ['Book']
        }

