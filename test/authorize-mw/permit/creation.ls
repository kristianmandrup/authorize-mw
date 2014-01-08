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
  var access, permit, guest-permit, admin-permit

  before ->
    permit          := new Permit

  describe 'init creates a permit ' ->
    specify 'first unnamed permit is named Permit-0' ->
      permit.name.should.eql 'Permit-0'

    specify 'with no description' ->
      permit.description.should.eql ''

  context 'extra Guest permit' ->
    before ->
      guest-permit    := new GuestPermit

    specify 'second unnamed is named Permit-1' ->
      guest-permit.name.should.eql 'Permit-1'


  context 'a single empty permit named hello' ->
    var permit

    before ->
      Permit.clear-all!
      permit := new Permit 'hello'

    # clean up
    after ->
      Permit.clear-all!

    describe 'rules' ->
      specify 'has an empty canRules list' ->
        permit.can-rules!.should.be.empty

      specify 'has an empty cannotRules list' ->
        permit.cannot-rules!.should.be.empty

    describe 'rule-applier-class' ->
      specify 'by default has rule-applier-class = RuleApplier' ->
        permit.rule-applier-class.should.eql RuleApplier

    describe 'allower' ->
      specify 'has an allower' ->
        permit.allower!.constructor.should.eql PermitAllower

    describe 'permit-matcher-class' ->
      specify 'permit by default has permit-matcher-class = PermitMatcher' ->
        permit.permit-matcher-class.should.eql PermitMatcher
