rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

PermitRegistry  = requires.file 'permit_registry'
RuleRepo        = requires.file 'rule_repo'
permit          = requires.fix  'permit'

permits = {}

describe 'PermitRegistry' ->
  describe 'create instance' ->
    specify 'should throw error' ->
      ( -> new PermitRegistry ).should.throw

  context 'singleton' ->
    describe 'initial state' ->
      describe 'permits' ->
        specify 'should be empty' ->
          PermitRegistry.permits.should.eql {}

      describe 'permit-counter' ->
        specify 'should be 0' ->
          PermitRegistry.permit-counter.should.eql 0

      describe 'calc-name' ->
        context 'no argument' ->
          specify 'should generate name Permit-0' ->
            PermitRegistry.calc-name!.should.eql 'Permit-0'

    describe 'register-permit' ->
      context 'cleared permits' ->
        before ->
          PermitRegistry.clear-all!

        describe 'permit-counter' ->
          specify 'should reset to 0' ->
            PermitRegistry.calc-name!.should.eql 'Permit-0'

    describe 'create a permit' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest = permit.setup.guest!

      describe 'permits' ->
        specify 'should have guest permit' ->
          PermitRegistry.permits['guest books'].should.eql permits.guest

      describe 'permit-counter' ->
        specify 'should be 1' ->
          PermitRegistry.permit-counter.should.eql 1


    context 'guest permit' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest = permit.setup.guest!

      describe 'clear-all' ->
        context 'cleared permits' ->
          before ->
            PermitRegistry.clear-all!

          describe 'permit-counter' ->
            specify 'should reset to 0' ->
              PermitRegistry.calc-name!.should.eql 'Permit-0'

          describe 'permits' ->
            specify 'should be empty' ->
              PermitRegistry.permits.should.eql {}

      describe 'clean-all' ->
        context 'cleaned permits' ->
          var old-counter, old-permits, old-repo

          before ->
            PermitRegistry.clear-all!
            permits.guest = permit.setup.guest!

            old-counter := PermitRegistry.permit-counter
            old-permits := PermitRegistry.permits
            old-repo    := permits.guest.rule-repo

            PermitRegistry.clean-all!

          specify 'old repo is a RuleRepo' ->
            old-repo.constructor.should.eql RuleRepo

          describe 'permit-counter' ->
            specify 'should not change' ->
              PermitRegistry.permit-counter.should.eql old-counter

          describe 'permits' ->
            specify 'should not change' ->
              PermitRegistry.permits.should.eql old-permits

          describe 'repo' ->
            describe 'should be cleaned' ->
              var cleaned-permit

              before ->
                cleaned-permit := PermitRegistry.permits['guest books']

              specify 'repo is same instance' ->
                cleaned-permit.rule-repo.should.eql old-repo

              specify 'repo can-rules are empty' ->
                cleaned-permit.rule-repo.can-rules.should.eql {}

              specify 'repo cannot-rules are empty' ->
                cleaned-permit.rule-repo.cannot-rules.should.eql {}

              specify 'can-rules are empty' ->
                cleaned-permit.can-rules!.should.eql {}

              specify 'cannot-rules are empty' ->
                cleaned-permit.cannot-rules!.should.eql {}
