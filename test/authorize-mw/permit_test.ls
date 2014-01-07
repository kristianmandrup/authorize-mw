require '../test_setup'

_         = require 'prelude-ls'
Permit    = require '../../permit'

RuleRepo        = require '../../rule_repo'
RuleApplier     = require '../../rule_applier'
PermitMatcher   = require '../../permit_matcher'
PermitAllower   = require '../../permit_allower'
permit-for      = require '../../permit_for'
Book            = require '../fixtures/book'

class AdminPermit extends Permit
  includes: ->
    'user':
      'role': 'admin'

  # and must NOT include the following
  excludes: ->
    'context': 'dashboard'

class GuestPermit extends Permit
  (name, desc) ->
    super ...

  match: (access) ->
    true


describe 'Permit' ->
  var access, permit, guest-permit, admin-permit

  before ->
    permit          := new Permit
    guest-permit    := new GuestPermit
    admin-permit    := new AdminPermit


  describe 'init creates a permit ' ->
    specify 'with the name unknown' ->
      permit.name.should.eql 'unknown'

    specify 'and no description' ->
      permit.description.should.eql ''

  describe 'use' ->
    var permit

    before ->
      permit := new Permit 'hello'

    specify 'using Object adds object to permit' ->
      permit.use {state: 'on'}
      permit.state.should.eql 'on'

    specify 'using Function adds object received from calling function to permit' ->
      permit.use ->
        {state: 'off'}
      permit.state.should.eql 'off'

  describe 'rules' ->
    var permit

    before ->
      permit := new Permit 'hello'
      permit.clear!

    specify 'has an empty canRules list' ->
      permit.can-rules!.should.be.empty

    specify 'has an empty cannotRules list' ->
      permit.cannot-rules!.should.be.empty

  describe 'rule-applier-class' ->
    specify 'permit by default has rule-applier-class = RuleApplier' ->
      guest-permit.rule-applier-class.should.eql RuleApplier

  describe 'matcher' ->
    var access-request

    before ->
      access-request := {}

    specify 'can NOT create matcher without access request' ->
      ( -> permit.matcher!).should.throw

    specify 'create matcher with access request' ->
      permit.matcher(access-request).constructor.should.eql PermitMatcher

  describe 'rule-applier' ->
    var access-request

    before ->
      access-request := {}
      permit.rules = ->

    specify 'has a rule-applier' ->
      permit.rule-applier!.constructor.should.eql RuleApplier

    describe 'constructed with access request' ->
      specify 'has a rule-applier ' ->
        permit.rule-applier(access-request).constructor.should.eql RuleApplier

      specify 'and rule-applier has access request' ->
        permit.rule-applier(access-request).access-request.should.eql access-request

  describe 'rule-repo' ->
    specify 'has a rule-repo' ->
      permit.rule-repo.constructor.should.eql RuleRepo

  describe 'allower' ->
    specify 'has an allower' ->
      permit.allower!.constructor.should.eql PermitAllower

  describe 'permit-matcher-class' ->
    specify 'permit by default has permit-matcher-class = PermitMatcher' ->
      guest-permit.permit-matcher-class.should.eql PermitMatcher

  describe 'matches' ->
    var book, read-book-request, publish-book-request

    make-request = (action) ->
        user: {}
        action: action
        subject: book

    before ->
      book                  := new Book 'a book'
      read-book-request     := make-request 'read'
      publish-book-request  := make-request 'publish'

      permit.match = (access) ->
        @matching(access).has-action 'read'

    specify 'will match request to read a book' ->
      permit.matches(read-book-request).should.be.true

    specify 'will NOT match request to publish a book' ->
      permit.matches(publish-book-request).should.be.false

  describe 'can rules' ->
    specify 'are empty' ->
      permit.can-rules!.should.be.empty

    specify 'same as repo rules' ->
      permit.can-rules!.should.be.eql permit.rule-repo.can-rules

  describe 'cannot rules' ->
    specify 'are empty' ->
      permit.cannot-rules!.should.be.empty

    specify 'same as repo rules' ->
      permit.cannot-rules!.should.be.eql permit.rule-repo.cannot-rules

  describe 'Rules application' ->
    var guest-permit
    before ->
      guest-permit    := permit-for GuestPermit, 'books', ->
        rules:
          read: ->
            @ucan 'read' 'Book'
          write: ->
            @ucan 'write' 'Book'
          default: ->
            @ucan 'read' 'any'

    # auto applies static rules by default (in init) as part of construction!
    describe 'static rules application' ->
      before ->

      specify 'registers a read-any rule (using default)' ->
        guest-permit.can-rules!['read'].should.eql ['any']

    describe 'dynamic rules application' ->
      var book, access-request

      before ->
          book := new Book 'a book'
          access-request :=
            user:
              role: 'admin'
            action: 'read'
            subject: book

          guest-permit.clear!
          # dynamic application when access-request passed
          guest-permit.apply-rules access-request

      specify 'registers a read-book rule' ->
        guest-permit.can-rules!['read'].should.eql ['Book']

      specify 'does NOT register a write-book rule' ->
        ( -> guest-permit.can-rules!['write'].should).should.throw