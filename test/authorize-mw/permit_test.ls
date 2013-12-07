require '../test_setup'

_         = require 'prelude-ls'
Permit    = require '../../permit'

class AdminPermit extends Permit
  includes: ->
    'user':
      'role': 'admin'

  # and must NOT include the following
  excludes: ->
    'context': 'dashboard'

class GuestPermit extends Permit
  constructor: ->
    super

  match: (access) ->
    true


describe 'Permit' ->
  var access, guest-permit, admin-permit

  before ->
    guest-permit    := new GuestPermit
    admin-permit    := new AdminPermit


  describe 'init' ->
    specify 'creates a permit with the name unknown' ->
      permit.name.should.be('unknown')

    specify 'creates a permit with an Intersect' ->
      permit.intersect.should.be.instanceOf(Object).and.have.property('on')

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

    specify 'has an empty canRules list' ->
      permit.can-rules!.should.be.empty

    specify 'has an empty cannotRules list' ->
      permit.cannot-rules!.should.be.empty

  describe 'matcher' ->
    var access-request

    before ->
      access-request := {}

    specify 'can NOT create matcher without access request' ->
      ( -> permit.matcher!).should.throw

    specify 'create matcher with access request' ->
      permit.matcher(access-request).constructor.should.eql PermitMatcher

  describe 'rule-applier' ->
    specify 'has a rule-applier' ->
      permit.rule-applier.constructor.should.eql RuleApplier

  describe 'rule-repo' ->
    specify 'has a rule-repo' ->
      permit.rule-repo.constructor.should.eql RuleRepo

  describe 'allower' ->
    specify 'has an allower' ->
      permit.allower.constructor.should.eql PermitAllower

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

    specify 'will match request to read a book' ->
      permit.matches(read-book-request).should.be.true

    specify 'will NOT match request to publish a book' ->
      permit.matches(publish-book-request).should.be.true

  describe 'can rules' ->
    specify 'are empty' ->
      permit.can-rules.should.be.empty

    specify 'same as repo rules' ->
      permit.can-rules.should.be.eql permit.rule-repo.can-rules

  describe 'cannot rules' ->
    specify 'are empty' ->
      permit.cannot-rules.should.be.empty

    specify 'same as repo rules' ->
      permit.cannot-rules.should.be.eql permit.rule-repo.cannot-rules

  describe 'Rules application' ->
    var guest-permit
    before ->
      guest-permit    := permit-for GuestPermit, 'books', ->
      rules:
        read: ->
          @ucan 'read' 'Book'
        write: ->
          @ucan 'write' 'Book'

    describe 'static rules application' ->
      before ->
        guest-permit.register-rules!

      specify 'registers a read-book rule' ->
        guest-permit.rule-repo.can-rules['read'].should.eql ['Book']

      specify 'registers a write-book rule' ->
        guest-permit.rule-repo.can-rules['write'].should.eql ['Book']

    describe 'dynamic rules application' ->
      var book, access-request

      before ->
          book := new Book 'a book'
          access-request :=
            user:
              role: 'admin'
            action: 'read'
            subject: book

          guest-permit.register-rules access-request

      specify 'registers a read-book rule' ->
        guest-permit.rule-repo.can-rules['read'].should.eql ['Book']

      specify 'does NOT register a write-book rule' ->
        # guest-permit.rule-repo.can-rules['write'].should.be.undefined


