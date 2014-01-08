require '../test_setup'

_         = require 'prelude-ls'
Permit    = require '../../permit'

RuleRepo        = require '../../rule_repo'
RuleApplier     = require '../../rule_applier'
PermitMatcher   = require '../../permit_matcher'
PermitAllower   = require '../../permit_allower'
permit-for      = require '../../permit_for'
Book            = require '../fixtures/book'

permits         = require '../fixtures/permits'

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

