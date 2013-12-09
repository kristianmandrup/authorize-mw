require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
Book      = require '../fixtures/book'

describe 'Allower', ->
  var user, allower

  book-rule = (action) ->
    {action: action, subject: book}

  before ->
    user    = new User 'kris'
    book    = new Book title: 'to the moon and back'

    read-book-rule  = book-rule 'read'
    write-book-rule = book-rule 'write'

    read-book-allower   = new Allower read-book-rule
    write-book-allower  = new Allower write-book-rule

  describe 'read-book-allower' ->
    before ->
      # init local vars

    specify 'return Allower instance' ->
      read-book-allower.constructor.should.be.an.instanceOf Allower

    specify 'Allower sets own access obj' ->
      read-book-allower.access.should.eql read-book-rule

  describe 'allows!' ->
    before ->
      # setup permits here !!
      user-permit = permit-for 'User',
        match: (access) ->
          user = access.user
          _.is-type user 'Object'
        rules: ->
          @ucan 'view', 'book'

      guest-permit = permit-for 'Guest',
        match: (access) ->
          user = access.user
          _.is-type user 'Object'
          user.role is 'guest'
        rules: ->
          @ucan 'read', 'book'

      editor-permit = permit-for 'Editor',
        match: (access) ->
          user = access.user
          _.is-type user 'Object'
          user.role is 'editor'
        rules: ->
          @ucan ['read', 'write'], 'book'

    specify 'read a book access should be allowed' ->
      read-book-allower.allows!.should.be true

    specify 'write a book should NOT be allowed' ->
      write-book-allower.allows!.should.be false

  describe 'disallows!' ->
    before ->
      # setup permits here !!
      user-permit = permit-for 'User',
        match: (access) ->
          user = access.user
          _.is-type user 'Object'
        rules: ->
          @ucan 'view', 'book'

      guest-permit = permit-for 'Guest',
        match: (access) ->
          user = access.user
          _.is-type user 'Object'
          user.role is 'guest'
        rules: ->
          @ucan 'read', 'book'

      editor-permit = permit-for 'Editor',
        match: (access) ->
          user = access.user
          _.is-type user 'Object'
          user.role is 'editor'
        rules: ->
          @ucan ['read', 'write'], 'book'

    specify 'read a book access should NOT be disallowed' ->
      read-book-allower.disallows!.should.be false

    specify 'write a book should be disallowed' ->
      write-book-allower.disallows!.should.be true
