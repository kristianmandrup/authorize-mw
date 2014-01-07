require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

Permit        = require '../../permit'
permit-for    = require '../../permit_for'

class AdminPermit extends Permit
  type: 'admin'

describe 'permit-for' ->

  context 'multiple guest permits' ->
    var guest-permit, other-guest-permit
    before ->
      guest-permit := permit-for 'Guest',
        number: 1
        match: (access) ->
          @matching(access).role 'guest'

      other-guest-permit := permit-for 'Guest',
        number: 2
        match: (access) ->
          @matching(access).role 'guest'

    specify 'guest permit is a Permit' ->
      guest-permit.constuctor.should.eql Permit

    specify 'guest permit name is Guest' ->
      guest-permit.name.should.eql 'Guest'

    specify 'other guest permit is void' ->
      assert other-guest-permit, void

    specify 'only one guest permit registered' ->
      Permit.permits.size.should.eql 1

    specify 'only first guest permit registered' ->
      Permit.permits['Guest'].number.should.eql 1

  describe 'guest permit' ->
    var guest-permit
    before ->
      guest-permit := permit-for 'Guest',
        match: (access) ->
          @matching(access).role 'guest'

        rules: ->
      guest-permit.clear!

    specify 'creates a permit made from Permit' ->
      guest-permit.constructor.should.eql Permit

    specify 'permit has the name Guest' ->
      guest-permit.name.should.eql 'Guest'

    specify 'has empty canRules' ->
      guest-permit.can-rules!.should.eql {}

    specify 'has empty cannotRules' ->
      guest-permit.cannot-rules!.should.eql {}

  describe 'admin permit' ->
    var admin-permit
    
    before ->
      admin-permit := permit-for AdminPermit, 'Admin',
        rules:
          admin: ->
            @ucan 'manage', 'all'

    specify 'creates a permit' ->
      admin-permit.constructor.should.eql AdminPermit

    specify 'has the name Admin' ->
      admin-permit.name.should.eql 'Admin'

    # from AdminPermit class :)
    specify 'has the type Admin' ->
      admin-permit.type.should.eql 'admin'

    specify 'sets rules to run' ->
      admin-permit.rules.should.be.an.instanceOf Object
