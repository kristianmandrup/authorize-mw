require '../test_setup'

_             = require 'prelude-ls'
lo            = require 'prelude-ls'
User          = require '../fixtures/user'

Ability       = require '../../ability'
Permit        = require '../../permit'
permit-for    = require '../../permit_for'
PermitMatcher = require '../../permit_matcher'

describe 'Ability' ->
  var user-kris, guest-user, admin-user
  var kris-ability, guest-ability, admin-ability
  var empty-access, user-access, guest-access, admin-access, kris-access
  var user-permit, guest-permit, admin-permit, auth-permit

  before ->
    user-kris       := new User name: 'kris'
    guest-user      := new User role: 'guest'
    admin-user      := new User name: 'kris', role: 'admin'

    kris-ability    := new Ability user-kris
    guest-ability   := new Ability guest-user
    admin-ability   := new Ability admin-user

    empty-access  := {}
    
    # TODO: Some or all of these access object should have an action as well!!
    role-access = (role) ->
      user:
        role: role
    
    user-access   := 
      user: {}

    guest-access  := role-access 'guest'

    admin-access  := role-access 'admin'

    kris-access   := lo.extend admin-access, {
      user:
        name: 'kris'
      ctx:
        auth: true
    }

    user-permit   := permit-for 'User',
      match: (access) ->
        user = if access? then access.user else void
        _.is-type user 'Object'
      rules: ->
        @ucan ['read', 'edit'], 'book'

    guest-permit  := permit-for 'Guest',
      match: (access) ->
        user = if access? then access.user else void
        _.is-type user 'Object'
        user.role is 'guest'
      rules: ->
        @ucan 'read', 'book'

    admin-permit  := permit-for 'admin',
      match: (access) ->
        user = if access? then access.user else void
        _.is-type user 'Object'
        user.role is 'admin'
      rules: ->
        @ucan 'manage', '*'

    auth-permit   := permit-for 'admin',
      match: (access) ->
        access.ctx.auth
      rules: ->
        @ucan 'manage', 'book'

  specify 'creates an Ability' ->
    ability.constructor.should.eql Ability

  specify 'Ability has user kris' ->
    ability.user.should.eql user

  describe 'accessObj' ->
    before ->
      # init local vars

    specify 'extends empty access with user' ->
      ability.access-obj(empty-access).should.eql {
        user:
          name: 'kris'
      }

    specify 'extends access with user.name' ->
      ability.access-obj(guest-access).should.eql {
        user:
          role: 'guest'
          name: 'kris'
      }

  xdescribe 'permits' ->
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
      ability.allower(access).constructor.should.eql Allower

    specify 'Allower sets own access obj' ->
      ability.allower(user-access).access.should.eql user-access

  xdescribe 'allowed-for' ->
    before ->
      # init local vars

    specify 'read a book access should be allowed for admin user' ->
      guest-ability.allowed-for(action: 'read', subject: book).should.be.true

    specify 'write a book access should NOT be allowed for guest user' ->
      guest-ability.allowed-for(action: 'write', subject: book).should.be.false

    specify 'write a book access should be allowed for admin user' ->
      admin-ability.allowed-for(action: 'write', subject: book).should.be.true

  xdescribe 'not-allowed-for' ->
    before ->
      # init local vars

    specify 'read a book access should be allowed for admin user' ->
      guest-ability.not-allowed-for(action: 'read', subject: book).should.be.false

    specify 'write a book access should NOT be allowed for guest user' ->
      guest-ability.not-allowed-for(action: 'write', subject: book).should.be.true

    specify 'write a book access should be allowed for admin user' ->
      admin-ability.not-allowed-for(action: 'write', subject: book).should.be.false
