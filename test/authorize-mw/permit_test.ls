rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

_         = require 'prelude-ls'

Permit          = requires.file 'permit'
RuleRepo        = requires.file 'rule_repo'
RuleApplier     = requires.file 'rule_applier'
PermitMatcher   = requires.file 'permit_matcher'
PermitAllower   = requires.file 'permit_allower'
permit-for      = requires.file 'permit_for'

Book            = requires.fix  'book'

permits         = requires.fix 'permits'

setup           = permits.setup
AdminPermit     = permits.AdminPermit
GuestPermit     = permits.GuestPermit

describe 'Permit' ->
  var permit

  describe 'use' ->
    var permit

    before ->
      Permit.clear-all!
      permit := new Permit 'hello'

    context 'single permit named hello' ->
      specify 'using Object adds object to permit' ->
        permit.use {state: 'on'}
        permit.state.should.eql 'on'

      specify 'using Function adds object received from calling function to permit' ->
        permit.use ->
          {state: 'off'}
        permit.state.should.eql 'off'

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

