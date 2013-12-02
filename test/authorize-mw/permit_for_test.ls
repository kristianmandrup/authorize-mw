require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

require '../fixtures/permits'
permit-for    = require '../../permit_for'

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

    admin-permit := permit-for 'Admin',
      rules:
        admin: ->
          can 'manage', 'all'

  describe 'guest permit' ->
    specify 'creates a permit' ->
      guest-permit.constructor.should.be.an.instanceOf Permit

    specify 'permit has the name Guest' ->
      guest-permit.name.should.eql 'Guest'

    specify 'has empty canRules' ->
      guest-permit.canRules.should.eql []

    specify 'has empty cannotRules' ->
      guest-permit.cannotRules.should.eql []

  describe 'admin permit' ->
    specify 'creates a permit' ->
      admin-permit.constructor.should.be.an.instanceOf Permit

    specify 'permit has the name Admin' ->
      admin-permit.name.should.eql 'Admin'

    specify 'sets rules to run' ->
      admin-permit.rules.should.be.an.instanceOf Object
