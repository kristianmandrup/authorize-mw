rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

_             = require 'prelude-ls'

User          = requires.fix 'user'
Book          = requires.fix 'book'

Allower       = requires.file 'allower'
Permit        = requires.file 'permit'
permit-for    = requires.file 'permit_for'

describe 'Allower', ->
  var user, guest-user, admin-user, editor-user
  var allower, book, book-access
  var read-book-allower


  before ->
    user        := new User name: 'kris'
    guest-user  := new User name: 'kris', role: 'guest'
    admin-user  := new User name: 'kris', role: 'admin'
    editor-user := new User name: 'kris', role: 'editor'

    book        := new Book title: 'to the moon and back'
    book-access := (action, user) ->
      {user: user, action: action, subject: book}

  describe 'read-book-allower' ->
    var read-book-access
    
    before ->
      # init local vars
      read-book-access    := book-access 'read', guest-user
      read-book-allower   := new Allower read-book-access

    specify 'return Allower instance' ->
      read-book-allower.constructor.should.eql Allower

    specify 'Allower sets own access obj' ->
      read-book-allower.access-request.should.eql read-book-access
  
  describe 'allows and disallows' ->
    var user-permit, guest-permit, editor-permit
    var read-book-access, write-book-access, non-write-book-access
    var read-book-allower, write-book-allower, non-write-book-allower

    before ->
      Permit.clear-permits!

      # setup permits here !!
      user-permit := permit-for 'User',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type 'Object', user
        rules: ->
          @ucan 'view', 'book'

      guest-permit := permit-for 'Guest',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type('Object', user) and user.role is 'guest'
        rules: ->
          @ucan 'read', 'book'
          @ucannot 'write', 'book'

      editor-permit := permit-for 'Editor',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type('Object', user) and user.role is 'editor'
        rules: ->
          @ucan ['read', 'write'], 'book'

      # any user can view a book
      # a guest user can also read a book
      # an editor user can also read and write a book

      read-book-access        := book-access 'read', guest-user
      write-book-access       := book-access 'write', editor-user
      non-write-book-access   := book-access 'write', guest-user

      read-book-allower       := new Allower read-book-access
      write-book-allower      := new Allower write-book-access
      non-write-book-allower  := new Allower non-write-book-access

    describe 'allows!' ->
      before-each ->
        # local config/setup
        Permit.clean-permits!

      specify 'read a book access should be allowed' ->
        read-book-allower.allows!.should.be.true

      specify 'write a book access should be allowed' ->
        write-book-allower.allows!.should.be.true

      specify 'write a book should NOT be allowed for ' ->
        non-write-book-allower.allows!.should.be.false

    describe 'disallows!' ->
      before-each ->
        # local config/setup
        Permit.clean-permits!

      specify 'read a book access should NOT be disallowed' ->
        read-book-allower.disallows!.should.be.false

      # since explit: @ucannot 'write', 'book' on gues-permit
      specify 'write a book should be disallowed' ->
        non-write-book-allower.disallows!.should.be.true
