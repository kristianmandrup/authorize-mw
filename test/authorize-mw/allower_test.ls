require '../test_setup'

_             = require 'prelude-ls'
User          = require '../fixtures/user'
Book          = require '../fixtures/book'
Allower       = require '../../allower'
permit-for    = require '../../permit_for'

describe 'Allower', ->
  var user, guest-user, admin-user
  var allower, book
  var read-book-access, write-book-access
  var read-book-allower, write-book-allower

  book-access = (action, user) ->
    {user: user, action: action, subject: book}

  before ->
    user          := new User name: 'kris'
    guest-user    := new User name: 'kris', role: 'guest'
    admin-user    := new User name: 'kris', role: 'admin'

    book          := new Book title: 'to the moon and back'

    read-book-access    := book-access 'read', guest-user
    write-book-access   := book-access 'write', admin-user

    read-book-allower   := new Allower read-book-access
    write-book-allower  := new Allower write-book-access

  describe 'read-book-allower' ->
    before ->
      # init local vars

    specify 'return Allower instance' ->
      read-book-allower.constructor.should.eql Allower

    specify 'Allower sets own access obj' ->
      read-book-allower.access-request.should.eql read-book-access

  describe 'allows!' ->
    before ->
      # setup permits here !!
      user-permit = permit-for 'User',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type 'Object', user
        rules: ->
          @ucan 'view', 'book'

      guest-permit = permit-for 'Guest',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type 'Object', user
          user.role is 'guest'
        rules: ->
          @ucan 'read', 'book'

      editor-permit = permit-for 'Editor',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type 'Object', user
          user.role is 'editor'
        rules: ->
          @ucan ['read', 'write'], 'book'

    specify 'read a book access should be allowed' ->
      read-book-allower.allows!.should.be.true

    specify 'write a book should NOT be allowed' ->
      write-book-allower.allows!.should.be.false

  describe 'disallows!' ->
    before ->
      # setup permits here !!
      user-permit = permit-for 'User',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type 'Object', user
        rules: ->
          @ucan 'view', 'book'

      guest-permit = permit-for 'Guest',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type('Object', user) and user.role is 'guest'
        rules: ->
          @ucan 'read', 'book'

      editor-permit = permit-for 'Editor',
        match: (access) ->
          user = if access? then access.user else void
          _.is-type('Object', user) and user.role is 'editor'
        rules: ->
          @ucan ['read', 'write'], 'book'

    specify 'read a book access should NOT be disallowed' ->
      read-book-allower.disallows!.should.be.false

    specify 'write a book should be disallowed' ->
      write-book-allower.disallows!.should.be.true
