rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

PermitRegistry  = requires.file 'permit-registry'
permit          = requires.fix 'permit'

describe 'PermitRegistry' ->
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
    permit = {}

    before ->
      PermitRegistry.clear-all!
      permit.guest = permit.setup.guest!

    describe 'permits' ->
      specify 'should have guest permit' ->
        PermitRegistry.permits.should.eql {
          guest: permit.guest
        }

    describe 'permit-counter' ->
      specify 'should be 1' ->
        PermitRegistry.permit-counter.should.eql 1


  context 'guest permit' ->
    before-each ->
      permit.guest = permit.setup.guest!


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
          old-counter := PermitRegistry.permit-counter
          old-permits := PermitRegistry.permits
          old-repo    := PermitRegistry.permits.0.repo

          PermitRegistry.clean-all!

        describe 'permit-counter' ->
          specify 'should not change' ->
            PermitRegistry.permit-counter.should.eql old-counter

        describe 'permits' ->
          specify 'should not change' ->
            PermitRegistry.permits.should.eql old-permits

        describe 'repo' ->
          decribe 'should be cleaned' ->
            specify 'repo is same instance' ->
              PermitRegistry.permits.0.repo.should.eql old-repo

            specify 'can-rules are empty' ->
              PermitRegistry.permits.0.can-rules.should.eql {}

            specify 'cannot-rules are empty' ->
              PermitRegistry.permits.0.cannot-rules.should.eql {}
