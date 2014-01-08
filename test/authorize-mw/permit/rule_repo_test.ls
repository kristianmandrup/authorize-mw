rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

Permit    = requires.file 'permit'
RuleRepo  = requires.file 'rule_repo'

describe 'Permit' ->
  var permit

  describe 'rule-repo' ->
    before-each ->
      permit          := new Permit

    # clean up!
    after-each ->
      Permit.clear-all!

    specify 'has a rule-repo' ->
      permit.rule-repo.constructor.should.eql RuleRepo

    specify 'has same name as permit' ->
      permit.rule-repo.name.should.eql permit.name

    specify 'has empty can-rules' ->
      permit.rule-repo.can-rules.should.eql {}

    specify 'has empty cannot-rules' ->
      permit.rule-repo.can-rules.should.eql {}

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
