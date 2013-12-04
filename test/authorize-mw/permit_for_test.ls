require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

Permit        = require '../../permit'
permit-for    = require '../../permit_for'

class AdminPermit extends Permit
  type: 'admin'

describe 'permit-for' ->
  var user-permit, guest-permit, admin-permit

  before ->
    user-permit := permit-for 'User',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'

    guest-permit := permit-for 'Guest',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'
        user.role is 'guest'

    admin-permit := permit-for AdminPermit, 'Admin',
      rules:
        admin: ->
          can 'manage', 'all'

  describe 'guest permit' ->
    specify 'creates a permit' ->
      guest-permit.constructor.display-name.should.be.eql 'Permit'

    specify 'permit has the name Guest' ->
      guest-permit.name.should.eql 'Guest'

    specify 'has empty canRules' ->
      guest-permit.canRules.should.eql []

    specify 'has empty cannotRules' ->
      guest-permit.cannotRules.should.eql []

  describe 'admin permit' ->
    specify 'creates a permit' ->
      admin-permit.constructor.display-name.should.be.eql 'Permit'

    specify 'has the name Admin' ->
      admin-permit.name.should.eql 'Admin'

    # from AdminPermit class :)
    specify 'has the type Admin' ->
      admin-permit.type.should.eql 'admin'

    specify 'sets rules to run' ->
      admin-permit.rules.should.be.an.instanceOf Object
