require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'

Ability   = require '../../ability'
Permit    = require '../../permit'
permit-for    = require '../../permit_for'
PermitMatcher = require '../../permit_matcher'

describe 'Ability' ->
  var user-kris, guest-user, admin-user
  var kris-ability, guest-ability, admin-ability
  var empty-access, user-access, guest-access, admin-access, kris-access
  var user-permit, guest-permit, admin-permit, auth-permit

  before ->
    user-kris   := new User name: 'kris'
    guest-user  := new User role: 'guest'
    admin-user  := new User name: 'kris', role: 'admin'

    kris-ability    := new Ability user-kris
    guest-ability   := new Ability guest-user
    admin-ability   := new Ability admin-user

    empty-access  := {}
    user-access   :=
      user: {}

    guest-access  :=
      user:
        role: 'guest'

    admin-access  :=
      user:
        role: 'admin'

    kris-access   :=
      user:
        role: 'admin'
        name: 'kris'
      ctx:
        auth: true

    user-permit   := permit-for 'User',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'
      rules: ->
        can ['read', 'edit'], 'book'

    guest-permit  := permit-for 'Guest',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'
        user.role is 'guest'
      rules: ->
        can 'read', 'book'

    admin-permit  := permit-for 'admin',
      match: (access) ->
        user = access.user
        _.is-type user 'Object'
        user.role is 'admin'
      rules: ->
        can 'manage', '*'

    auth-permit   := permit-for 'admin',
      match: (access) ->
        access.ctx.auth
      rules: ->
        can 'manage', 'book'

  specify 'creates an Ability' ->
    ability.constructor.should.be.an.instanceOf Ability

  specify 'Ability has user kris' ->
    ability.user.should.be.eql user

  describe 'accessObj' ->
    before ->
      # init local vars

    specify 'extends empty access with user' ->
      ability.accessObj(empty-access).should.eql {
        user:
          name: 'kris'
      }

    specify 'extends access with user.name' ->
      ability.accessObj(guest-access).should.eql {
        user:
          role: 'guest'
          name: 'kris'
      }

  describe 'permits' ->
    before ->
      # init local vars

    specify 'find no permits matching empty access' ->
      ability.permits(empty-access).should.eql []

    specify 'find 1 permits matching user access' ->
      ability.permits(user-access).should.eql [user-permit]

    specify 'find 2 permits matching guest user access' ->
      ability.permits(guest-access).should.eql [user-permit, guest-permit]

  describe 'allower' ->
    before ->
      # init local vars

    specify 'return Allower instance' ->
      ability.allower(access).constructor.should.be.an.instanceOf Allower

    specify 'Allower sets own access obj' ->
      ability.allower(user-access).access.should.eql user-access

  describe 'allowed-for' ->
    before ->
      # init local vars

    specify 'read a book access should be allowed for admin user' ->
      guest-ability.allowed-for(action: 'read', subject: book).should.be true

    specify 'write a book access should NOT be allowed for guest user' ->
      guest-ability.allowed-for(action: 'write', subject: book).should.be false

    specify 'write a book access should be allowed for admin user' ->
      admin-ability.allowed-for(action: 'write', subject: book).should.be true

  describe 'not-allowed-for' ->
    before ->
      # init local vars

    specify 'read a book access should be allowed for admin user' ->
      guest-ability.not-allowed-for(action: 'read', subject: book).should.be false

    specify 'write a book access should NOT be allowed for guest user' ->
      guest-ability.not-allowed-for(action: 'write', subject: book).should.be true

    specify 'write a book access should be allowed for admin user' ->
      admin-ability.not-allowed-for(action: 'write', subject: book).should.be false
