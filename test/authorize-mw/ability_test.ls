rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

_             = require 'prelude-ls'
lo            = require 'lodash'
User          = requires.fix 'user'
Book          = requires.fix 'book'

Allower       = requires.file 'allower'
Ability       = requires.file 'ability'
Permit        = requires.file 'permit'
permit-for    = requires.file 'permit_for'
PermitMatcher = requires.file 'permit_matcher'

deep-extend = require 'deep-extend'

describe 'Ability' ->
  var user-kris, guest-user, admin-user
  var kris-ability, guest-ability, admin-ability
  var empty-access, user-access, guest-access, admin-access, kris-access, read-book-access
  var user-permit, guest-permit, admin-permit, auth-permit
  var book

  setup-permits = ->
    Permit.clear-all!

    user-permit   := permit-for 'User',
      match: (access) ->
        @matching(access).has-user!
      rules: ->
        console.log 'User permit Repo', @repo
        console.log 'can-rules', @repo.can-rules
        console.log 'cannot-rules', @repo.cannot-rules
        @ucan ['read', 'edit'], 'book'

    guest-permit  := permit-for 'Guest',
      match: (access) ->
        @matching(access).has-role 'guest'

      rules: ->
        @ucan 'read', 'book'

    admin-permit  := permit-for 'admin',
      match: (access) ->
        @matching(access).has-role 'admin'

      rules: ->
        @ucan 'write', 'book'
        @ucan 'manage', '*'

    auth-permit   := permit-for 'auth',
      match: (access) ->
        @matching(access).has-ctx!

      rules: ->
        @ucan 'manage', 'book'

  before ->
    user-kris       := new User name: 'kris'
    guest-user      := new User role: 'guest'
    admin-user      := new User name: 'kris', role: 'admin'

    kris-ability    := new Ability user-kris
    guest-ability   := new Ability guest-user
    admin-ability   := new Ability admin-user

    empty-access  := {}

    book          := new Book 'Far and away'
    
    # TODO: Some or all of these access object should have an action as well!!
    role-access = (role) ->
      user:
        role: role
    
    user-access   := 
      user: user-kris

    guest-access  := role-access 'guest'

    admin-access  := role-access 'admin'

    kris-access   := deep-extend {}, admin-access, {
      user:
        name: 'kris'
      ctx:
        auth: true
    }

    read-book-access :=
      action: 'read'
      subject: book


  specify 'creates an Ability' ->
    kris-ability.constructor.should.eql Ability

  specify 'Ability has user kris' ->
    kris-ability.user.should.eql user-kris

  describe 'access-obj' ->
    before ->
      # init local vars

    context 'kris-ability' ->
      specify 'extends empty access with user thas has a name' ->
        kris-ability.access-obj(empty-access).user.should.have.property 'name'

      specify 'extends empty access with user' ->
        kris-ability.access-obj(empty-access).user.name.should.eql 'kris'

      specify 'extends access with user.role' ->
        kris-ability.access-obj(guest-access).user.should.have.property 'role'

    context 'guest-ability' ->
      specify 'extends access with read book' ->
        console.log 'access-obj', guest-ability.access-obj(read-book-access)

        guest-ability.access-obj(read-book-access).user.role.should.eql 'guest'
        guest-ability.access-obj(read-book-access).action.should.eql 'read'


  # TODO work but not in grunt, some state is changed with other test
  describe 'permits' ->
    before ->
      setup-permits!

    context 'kris-ability' ->
      specify 'user permit always present, since ability always has non-empty user' ->
        kris-ability.permits(empty-access).should.eql [user-permit]

      specify 'find 1 extra permit matching admin user access' ->
        kris-ability.permits(admin-access).should.eql [user-permit, admin-permit]

      specify 'find 1 extra permit matching guest user access' ->
        kris-ability.permits(guest-access).should.eql [user-permit, guest-permit]

    context 'guest-ability' ->
      specify 'no permits allow read book' ->
        guest-ability.permits(read-book-access).should.eql [user-permit, guest-permit]


  describe 'allower' ->
    before ->
      # init local vars
      setup-permits!

    specify 'return Allower instance' ->
      kris-ability.allower(empty-access).constructor.should.eql Allower

    specify 'Allower sets own access-request obj' ->
      kris-ability.allower(user-access).access-request.should.eql user-access

  describe 'allowed-for' ->
    before ->
      # init local vars

    context 'guest ability' ->
      xspecify 'read a book access should be allowed for admin user' ->
        guest-ability.allowed-for(action: 'read', subject: book).should.be.true

      specify 'write a book access should NOT be allowed for guest user' ->
        guest-ability.allowed-for(action: 'write', subject: book).should.be.false

    context 'admin ability' ->
      xspecify 'write a book access should be allowed for admin user' ->
        admin-ability.allowed-for(action: 'write', subject: book).should.be.true

  xdescribe 'not-allowed-for' ->
    before ->
      # init local vars

    specify 'read a book access should be allowed for admin user' ->
      guest-ability.not-allowed-for(action: 'read', subject: book).should.be.false

    xspecify 'write a book access should NOT be allowed for guest user' ->
      guest-ability.not-allowed-for(action: 'write', subject: book).should.be.true

    xspecify 'write a book access should be allowed for admin user' ->
      admin-ability.not-allowed-for(action: 'write', subject: book).should.be.false
